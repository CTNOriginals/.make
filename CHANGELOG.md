# Changelog

All notable changes to this project are documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Fixed

- In a repo without a `v*` tag, the version variables held a commit hash and
  the version math failed. They now count from `v0.0.0`.
- A pre-release tag like `v1.0.0-rc1` broke the version variables. Tags with a
  `-` are now skipped.

## [0.3.0] - 2026-11-19

### Added

- `make git-watch` shows the git status and log graph, redrawn on every
  change.

## [0.2.0] - 2026-11-19

### Added

- `make vars` lists all variables with their definition and resolved value.

### Changed

- **BREAKING:** `VERSION` is now the version a patch release would get (the
  last tag plus the commits since it). The last tag's version is now
  `LAST_VERSION`.
- **BREAKING:** Version variables are renamed:
  `VERSION_TAG` -> `LAST_TAG`,
  `VERSION_PARTS` -> `LAST_VERSION_PARTS`,
  `CURRENT_VERSION_PATCH` -> `VERSION`.
- `COMMITS_SINCE_TAG` is `0` on a tag instead of empty.

### Removed

- **BREAKING:** `CURRENT_VERSION_MINOR` and `CURRENT_VERSION_MAJOR`. Use
  `$(MAJOR).$(NEXT_MINOR).0` and `$(NEXT_MAJOR).0.0` instead.

### Fixed

- `NEXT_PATCH` failed on a tag, so `make patch` would tag `vX.Y.` with no
  patch number.

## [0.1.4] - 2026-11-19

### Changed

- The `help` and `list` scripts moved to `scripts/help.awk` and
  `scripts/list.awk`.
- `make help` prints sections in the order they first appear and fits the
  name column to the longest target.
- `make list` groups targets under their category, like `make help`.
- The `help`, `list` and `version` targets moved from the `help` category to
  `info`.

### Removed

- **BREAKING:** The `tag` target. Use `git push --tags` instead.

## [0.1.0] - 2026-11-19

### Changed

- **BREAKING:** `base.mk` is renamed to `main.mk`. Include `.make/main.mk`
  instead of `.make/base.mk`.
- The targets are split into `info.mk`, `git.mk` and `versioning.mk`, included
  by `main.mk`.

### Fixed

- `make help` and `make list` include targets with numbers in their name.

## [0.0.1] - 2026-11-15

### Added

- `make help`, `make list` and `make version`.
- `make patch`, `make minor`, `make major` and `make tag` for version tags.
- `make update-make` to update the `.make` submodule.

[Unreleased]: https://github.com/CTNOriginals/.make/compare/v0.3.0...HEAD
[0.3.0]: https://github.com/CTNOriginals/.make/compare/v0.2.0...v0.3.0
[0.2.0]: https://github.com/CTNOriginals/.make/compare/v0.1.4...v0.2.0
[0.1.4]: https://github.com/CTNOriginals/.make/compare/v0.1.0...v0.1.4
[0.1.0]: https://github.com/CTNOriginals/.make/compare/v0.0.1...v0.1.0
[0.0.1]: https://github.com/CTNOriginals/.make/releases/tag/v0.0.1
