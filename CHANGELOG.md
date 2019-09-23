# Changelog
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.1.2] - 2019-09-23
### Changed
- Fixed issue whereby `‌--itms-transporter-path` flag was ignored.

## [1.1.1] - 2019-07-23
### Changed
- Fixed issue whereby `verbose-on-failure` flag was not obeyed correctly.

## [1.1.0] - 2019-07-23
### Added
- Added the ability to specify whether or not the application name is emitted as part of output using `--emit-app-name`.
- Added the ability to notify only on failures using `--notify-only-on-failure`.
- Added the ability to provide more verbose output only where a failure occurs to help diagnose the issue using --verbose-on-failure`.

## [1.0.0] - 2019-07-11
### Added
- Return code emitted to fail CI jobs where upload fails.
- `--verbose` flag added in order to obtain more detailed output.

### Changed
- Output made more concise.

## [0.0.2] - 2018-11-26
### Added
- Ability to specify a timeout in seconds for the upload using the `--timeout` parameter.

## [0.0.1] - 2018-11-23

### Added
- Initial release.