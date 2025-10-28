# PostgreSQL 18 Upgrade Status

## Overview
This document tracks the status of the PostgreSQL 18 upgrade for pg_deribit.

## Completed Tasks
- ✅ Updated Dockerfile to use `ghcr.io/omnigres/omnigres-18:latest`
- ✅ Updated PG_CONFIG paths from PostgreSQL 17 to 18
- ✅ Updated pgtap package from `postgresql-17-pgtap` to `postgresql-18-pgtap`
- ✅ Updated documentation (README.md, CLAUDE.md)
- ✅ Updated CHANGELOG.md
- ✅ All code references to PostgreSQL version updated

## Pending Tasks / Blockers
- ⏳ **Waiting for Omnigres PostgreSQL 18 Docker image**
  - Status: Omnigres has code support for PostgreSQL 18 (commit [3daa34d](https://github.com/omnigres/omnigres/commit/3daa34d9a805d11d4c3d20cf31019f369d1b05c9))
  - Blocker: Omnigres has not published Docker images for PostgreSQL 18 yet
  - Expected: Should be available soon since PostgreSQL 18 base image (`postgres:18-bookworm`) is now available
  - Required image: `ghcr.io/omnigres/omnigres-18:latest`

## Next Steps
Once the omnigres-18 image is available:
1. Test the Docker build: `docker build -t pg_deribit:test .`
2. Run the container and verify extension installation
3. Run unit tests: `make test-unit`
4. Run integration tests: `make test-integration`
5. Update this status document
6. Merge the PostgreSQL 18 upgrade PR

## Alternative Approaches Considered
1. **Build Omnigres from source**: Too complex, would significantly increase build time and image size
2. **Use postgres:18 directly without Omnigres**: Would require finding alternative implementations for `omni_http` and `omni_httpc` extensions
3. **Wait for Omnigres**: Best approach - minimal changes, clean upgrade path

## Tracking
- Related Omnigres issue: To be filed if the image is not available within a reasonable timeframe
- Omnigres Docker workflow: `.github/workflows/docker.yml` in omnigres/omnigres repository
- Currently builds for: PostgreSQL 14, 15, 16, 17 (not 18 yet)
