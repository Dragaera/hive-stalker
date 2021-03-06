# Change log

This document represents a high-level overview of changes made to this project.
It will not list every miniscule change, but will allow you to view - at a
glance - what to expact from upgrading to a new version.

## [unpublished]

### Added

### Changed

### Fixed

### Security

### Deprecated

### Removed


## [0.3.1] - 2020-11-01

### Added

- Add `pry` as development dependency.

### Changed

- Update Bundler.

### Fixed

- Clamp marine field & commander skill to `0`.


## [0.3.0] - 2020-11-01

### Added

- Support for per-team and per-position (field & commander) skill values
- Support for skill tiers
- `PlayerData#specific_skills` which returns a struct with such-computed values
- `PlayerData#specific_skill_tiers` which returns a struct with such-computed skill tiers


## [0.2.0] - 2019-03-04

### Added

- Support for latitude / longitude / country fields.

### Removed

- Support for now-removed `badges_enabled` field.


## [0.1.5] - 2016-01-15

### Fixed

- Fixed account IDs starting with 765 being treated as a Steam ID 64.


## [0.1.4] - 2016-12-31

### Fixed

- Fixed case-sensitivity of Steam ID resolving.
- Fixed resolving of Steam IDs of the form STEAM_1:..., as opposed to STEAM_0:...


## [0.1.3] - 2016-12-26

### Fixed

- HiveStalker::SteamID.from_string did not support account IDs with less than
  eight digits.


## [0.1.2] - 2016-12-25

### Changed

- The API client now converts skill values of pre-Hive2 players to an integer.


## [0.1.1] - 2016-12-22

### Fixed

- PlayerData did not initialize `skill` and `alias` attributes.


## [0.1.0] - 2016-12-22

### Added

- Basic client and wrappper to access player data from Hive2 API.
