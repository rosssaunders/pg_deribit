# Change Log

All notable changes to this project will be documented in this file.

## [Unreleased]

### Added

- **Omnigres Credentials Support**: Integration with `omni_credentials` extension for secure, persistent credential storage
  - New function `deribit.store_credentials()` to store API credentials in `omni_credentials`
  - New function `deribit.has_omni_credentials()` to check if `omni_credentials` is available
  - New function `deribit.get_credentials_from_store()` to retrieve credentials from `omni_credentials`
  - Enhanced `deribit.get_auth()` to support both session variables and `omni_credentials`
  - Automatic fallback to session variables for backwards compatibility
  - Documentation and examples for using `omni_credentials`

### Changed

- `deribit.get_auth()` now accepts optional `credential_name` parameter (defaults to 'deribit')
- Enhanced documentation with detailed instructions for both authentication methods

## [1.0.0] - 2024-01-XX

### Added

- Initial release with Deribit API v2.1.1 support
