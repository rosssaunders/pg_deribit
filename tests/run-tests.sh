#!/bin/bash
#
# pgTAP Test Runner for pg_deribit
#
# Usage:
#   ./run-tests.sh              # Run all tests
#   ./run-tests.sh unit         # Run only unit tests
#   ./run-tests.sh integration  # Run only integration tests
#

set -e

# Configuration
export PGPASSWORD="${POSTGRES_PASSWORD:-deribitpwd}"
export PGCONNECT_TIMEOUT="${PGCONNECT_TIMEOUT:-5}"
PGUSER="${POSTGRES_USER:-deribit}"
PGDB="${POSTGRES_DB:-deribit}"
PGHOST="${POSTGRES_HOST:-localhost}"
PGPORT="${POSTGRES_PORT:-5432}"
TEST_OUTPUT_DIR="${TEST_OUTPUT_DIR:-}"
USE_EXISTING_DB="${USE_EXISTING_DB:-}"
AUTO_DOCKER="${AUTO_DOCKER:-1}"
TEST_DOCKER_IMAGE="${TEST_DOCKER_IMAGE:-pg_deribit:test}"
TEST_DOCKER_PORT="${TEST_DOCKER_PORT:-0}"
DERIBIT_CLIENT_ID="${DERIBIT_CLIENT_ID:-${DERIBIT_TESTNET_CLIENT_ID:-}}"
DERIBIT_CLIENT_SECRET="${DERIBIT_CLIENT_SECRET:-${DERIBIT_TESTNET_CLIENT_SECRET:-}}"
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
DOCKER_CONTAINER_NAME=""
DOCKER_STARTED=""

is_running_in_docker() {
    if [ -f "/.dockerenv" ]; then
        return 0
    fi
    if [ -f "/proc/1/cgroup" ] && grep -qaE 'docker|containerd|kubepods' /proc/1/cgroup; then
        return 0
    fi
    return 1
}

wait_for_postgres() {
    local container_name=$1
    local ready=""

    for _ in $(seq 1 60); do
        if docker exec "$container_name" pg_isready -U "$PGUSER" >/dev/null 2>&1; then
            ready="yes"
            break
        fi
        sleep 1
    done

    if [ -z "$ready" ]; then
        echo -e "${RED}✗ PostgreSQL did not become ready${NC}"
        return 1
    fi

    sleep 2
    return 0
}

cleanup_docker() {
    if [ -n "$DOCKER_STARTED" ] && [ -n "$DOCKER_CONTAINER_NAME" ]; then
        docker rm -f "$DOCKER_CONTAINER_NAME" >/dev/null 2>&1 || true
    fi
}

wait_for_psql() {
    for _ in $(seq 1 30); do
        if psql -h "$PGHOST" -p "$PGPORT" -U "$PGUSER" -d "$PGDB" \
            -q -c "select 1" >/dev/null 2>&1; then
            return 0
        fi
        sleep 1
    done

    echo -e "${RED}✗ PostgreSQL is not accepting connections at $PGHOST:$PGPORT${NC}"
    return 1
}

maybe_start_docker() {
    if [ -n "$USE_EXISTING_DB" ] || [ "$AUTO_DOCKER" = "0" ]; then
        return 0
    fi

    if is_running_in_docker; then
        return 0
    fi

    if [ "$PGHOST" != "localhost" ] && [ "$PGHOST" != "127.0.0.1" ]; then
        return 0
    fi

    if psql -h "$PGHOST" -p "$PGPORT" -U "$PGUSER" -d "$PGDB" -c "select 1" >/dev/null 2>&1; then
        return 0
    fi

    if ! command -v docker >/dev/null 2>&1; then
        echo -e "${RED}✗ Docker is required to start PostgreSQL automatically${NC}"
        return 1
    fi

    echo "Building Docker image $TEST_DOCKER_IMAGE..."
    docker build -t "$TEST_DOCKER_IMAGE" "$REPO_ROOT"

    DOCKER_CONTAINER_NAME="pg_deribit_test_$$"
    echo "Starting PostgreSQL container $DOCKER_CONTAINER_NAME..."
    local publish_port_arg="5432"
    if [ "$TEST_DOCKER_PORT" != "0" ]; then
        publish_port_arg="${TEST_DOCKER_PORT}:5432"
    fi

    docker run -d --name "$DOCKER_CONTAINER_NAME" \
        -e POSTGRES_PASSWORD="$PGPASSWORD" \
        -e POSTGRES_USER="$PGUSER" \
        -e POSTGRES_DB="$PGDB" \
        -p "$publish_port_arg" \
        "$TEST_DOCKER_IMAGE" >/dev/null

    DOCKER_STARTED="yes"
    trap cleanup_docker EXIT

    wait_for_postgres "$DOCKER_CONTAINER_NAME"

    local mapped_port
    mapped_port="$(docker port "$DOCKER_CONTAINER_NAME" 5432/tcp | awk -F: 'NF>1 && $NF != "" {print $NF}' | head -n1)"
    if [ -z "$mapped_port" ]; then
        echo -e "${RED}✗ Unable to determine mapped PostgreSQL port${NC}"
        return 1
    fi

    PGHOST="127.0.0.1"
    PGPORT="$mapped_port"
    export PGHOST
    export PGPORT
    return 0
}

ensure_integration_creds() {
    if [ "$TEST_SUITE" = "unit" ]; then
        return 0
    fi

    if ! wait_for_psql; then
        exit 1
    fi

    if [ -n "$DERIBIT_CLIENT_ID" ] && [ -n "$DERIBIT_CLIENT_SECRET" ]; then
        if ! psql -h "$PGHOST" -p "$PGPORT" -U "$PGUSER" -d "$PGDB" \
            -v ON_ERROR_STOP=1 \
            -v client_id="$DERIBIT_CLIENT_ID" \
            -v client_secret="$DERIBIT_CLIENT_SECRET" \
            -q >/dev/null <<SQL
ALTER DATABASE $PGDB SET deribit.test_client_id = :'client_id';
ALTER DATABASE $PGDB SET deribit.test_client_secret = :'client_secret';
SQL
        then
            echo -e "${RED}✗ Failed to store Deribit credentials in the database${NC}"
            exit 1
        fi
        return 0
    fi

    local db_client_id
    local db_client_secret
    db_client_id="$(psql -h "$PGHOST" -p "$PGPORT" -U "$PGUSER" -d "$PGDB" -tA -q \
        -c "SELECT current_setting('deribit.test_client_id', true);" 2>/dev/null)"
    db_client_secret="$(psql -h "$PGHOST" -p "$PGPORT" -U "$PGUSER" -d "$PGDB" -tA -q \
        -c "SELECT current_setting('deribit.test_client_secret', true);" 2>/dev/null)"

    if [ -n "$db_client_id" ] && [ -n "$db_client_secret" ]; then
        return 0
    fi

    echo -e "${RED}✗ Missing Deribit TestNet credentials for integration tests${NC}"
    echo "Set DERIBIT_CLIENT_ID/DERIBIT_CLIENT_SECRET (or DERIBIT_TESTNET_CLIENT_ID/DERIBIT_TESTNET_CLIENT_SECRET),"
    echo "or configure the database with:"
    echo "  ALTER DATABASE $PGDB SET deribit.test_client_id = 'your_id';"
    echo "  ALTER DATABASE $PGDB SET deribit.test_client_secret = 'your_secret';"
    exit 1
}

# Colors for output
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Test suite selection
TEST_SUITE="${1:-all}"

# Change to tests directory
cd "$SCRIPT_DIR"

maybe_start_docker
ensure_integration_creds

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "  pg_deribit Test Suite"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "Configuration:"
echo "  Database: $PGDB"
echo "  User:     $PGUSER"
echo "  Host:     $PGHOST:$PGPORT"
echo "  Suite:    $TEST_SUITE"
echo ""

# Function to run tests in a directory
run_tests() {
    local test_dir=$1
    local test_name=$2
    local output_dir=""

    if [ ! -d "$test_dir" ]; then
        echo -e "${YELLOW}⊘ Skipping $test_name tests (directory not found)${NC}"
        return 0
    fi

    local test_files=""
    test_files=$(find "$test_dir" -name "*.sql" | sort)

    if [ -z "$test_files" ]; then
        echo -e "${YELLOW}⊘ No tests found in $test_dir${NC}"
        return 0
    fi

    if [ -n "$TEST_OUTPUT_DIR" ]; then
        output_dir="$TEST_OUTPUT_DIR/$test_dir"
        mkdir -p "$output_dir"
    fi

    echo -e "${GREEN}Running $test_name tests...${NC}"
    echo ""

    local failed=0
    for test_file in $test_files; do
        local test_basename=$(basename "$test_file")
        echo -n "  → $test_basename ... "

        local tap_file=""
        if [ -n "$output_dir" ]; then
            tap_file="$output_dir/${test_basename%.sql}.tap"
        fi

        if [ -n "$tap_file" ]; then
            if psql -h "$PGHOST" -p "$PGPORT" -U "$PGUSER" -d "$PGDB" -f "$test_file" -v ON_ERROR_STOP=1 > "$tap_file" 2>&1; then
                echo -e "${GREEN}✓ PASSED${NC}"
            else
                echo -e "${RED}✗ FAILED${NC}"
                failed=1
                echo ""
                echo "Output:"
                cat "$tap_file"
                echo ""
            fi
        elif psql -h "$PGHOST" -p "$PGPORT" -U "$PGUSER" -d "$PGDB" -f "$test_file" -v ON_ERROR_STOP=1 -q > /dev/null 2>&1; then
            echo -e "${GREEN}✓ PASSED${NC}"
        else
            echo -e "${RED}✗ FAILED${NC}"
            failed=1
            echo ""
            echo "Re-running with output:"
            psql -h "$PGHOST" -p "$PGPORT" -U "$PGUSER" -d "$PGDB" -f "$test_file" -v ON_ERROR_STOP=1
            echo ""
        fi
    done

    echo ""

    return $failed
}

# Run tests based on suite selection
total_failed=0

if [ "$TEST_SUITE" = "all" ] || [ "$TEST_SUITE" = "unit" ]; then
    run_tests "unit" "Unit"
    total_failed=$((total_failed + $?))
fi

if [ "$TEST_SUITE" = "all" ] || [ "$TEST_SUITE" = "integration" ]; then
    run_tests "integration" "Integration"
    total_failed=$((total_failed + $?))
fi

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

if [ $total_failed -eq 0 ]; then
    echo -e "${GREEN}✅ All tests passed!${NC}"
    echo ""
    exit 0
else
    echo -e "${RED}❌ Some tests failed${NC}"
    echo ""
    exit 1
fi
