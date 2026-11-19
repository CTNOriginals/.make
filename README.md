# .make

A shared set of make targets, used as a git submodule. It adds help and
listing targets, version tagging based on `git describe`, and a few git
helpers to any project with a single `include`.

## Setup

Add the repo as a submodule named `.make` in your project root:

```sh
git submodule add https://github.com/CTNOriginals/.make.git .make
```

Then include it at the top of your project's `Makefile`:

```make
include .make/main.mk
```

`main.mk` sets `help` as the default goal, so a bare `make` prints the
available targets. Your own targets show up in `make help` when you tag them
with `##@<section> [description]`:

```make
build: ##@build Compile the project
	go build ./...
```

## Targets

### info

| Target         | Description                                                  |
|----------------|--------------------------------------------------------------|
| `make help`    | List all tagged targets with their description, by section   |
| `make list`    | List all targets with their commands, by section             |
| `make vars`    | List all variables with their resolved value and definition  |
| `make version` | Print the current version                                    |

### git

| Target             | Description                                              |
|--------------------|----------------------------------------------------------|
| `make update-make` | Update the `.make` submodule to the latest version       |
| `make git-watch`   | Show the git status and log graph, redrawn on every change |

### versioning

| Target       | Description                                         |
|--------------|-----------------------------------------------------|
| `make patch` | Tag `vX.Y.(Z + commits since the last tag)`         |
| `make minor` | Tag `vX.(Y + 1).0`                                  |
| `make major` | Tag `v(X + 1).0.0`                                  |

The versioning targets only create the tag locally. Push it with
`git push --tags`.

## Versioning

Versions come from the latest `v*` tag. Without one, it works as if the
latest tag is `v0.0.0` with no commits since it.

These variables are available in your own targets. The examples are for
`v0.1.4` with 3 commits since it:

| Variable                                 | Example       | Meaning                               |
|------------------------------------------|---------------|---------------------------------------|
| `LAST_TAG`                               | `v0.1.4`      | The latest version tag                |
| `LAST_VERSION`                           | `0.1.4`       | `LAST_TAG` without the `v`            |
| `COMMITS_SINCE_TAG`                      | `3`           | Commits since the tag                 |
| `MAJOR`, `MINOR`, `PATCH`                | `0`, `1`, `4` | The parts of `LAST_VERSION`           |
| `NEXT_MAJOR`, `NEXT_MINOR`, `NEXT_PATCH` | `1`, `2`, `7` | The parts a release would bump to     |
| `VERSION`                                | `0.1.7`       | The version a patch release would get |

Run `make vars` to see the values for your project.

## Requirements

`make`, `git`, `awk` and a POSIX `sh`. `git-watch` also uses `tput` and
`clear`.

## Updating

Run `make update-make`, then commit the new submodule commit in your project.
Check the [changelog](CHANGELOG.md) for breaking changes and how to fix them.
