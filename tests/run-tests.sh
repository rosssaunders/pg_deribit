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
PGUSER="${POSTGRES_USER:-deribit}"
PGDB="${POSTGRES_DB:-deribit}"
PGHOST="${POSTGRES_HOST:-localhost}"
PGPORT="${POSTGRES_PORT:-5432}"

# Colors for output
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Test suite selection
TEST_SUITE="${1:-all}"

# Change to tests directory
cd "$(dirname "$0")"

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

    if [ ! -d "$test_dir" ]; then
        echo -e "${YELLOW}⊘ Skipping $test_name tests (directory not found)${NC}"
        return 0
    fi

    local test_files=$(find "$test_dir" -name "*.sql" ! -name "*authenticated*" ! -name "*order*" ! -name "*new-features*" | sort)

    if [ -z "$test_files" ]; then
        echo -e "${YELLOW}⊘ No tests found in $test_dir${NC}"
        return 0
    fi

    echo -e "${GREEN}Running $test_name tests...${NC}"
    echo ""

    local failed=0
    for test_file in $test_files; do
        local test_basename=$(basename "$test_file")
        echo -n "  → $test_basename ... "

        if psql -h "$PGHOST" -p "$PGPORT" -U "$PGUSER" -d "$PGDB" -f "$test_file" -v ON_ERROR_STOP=1 -q > /dev/null 2>&1; then
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
