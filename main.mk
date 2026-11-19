# Makefile template: https://gist.github.com/grihabor/4a750b9d82c9aa55d5276bd5503829be
# source: https://codeberg.org/CTNOriginals/colorizer/src/branch/main/Makefile

MAKEFLAGS          += --no-print-directory
MAKE_DIR		   := $(dir $(lastword $(MAKEFILE_LIST)))

# Pre-release tags (v1.0.0-rc1) are skipped, their "-" would break the split.
DESCRIBE           := $(shell git describe --match "v*" --exclude "*-*" --tags 2>/dev/null)
DESCRIBE_PARTS     := $(subst -, ,$(DESCRIBE))

# Without a v* tag (or outside a git repo) versions count from v0.0.0.
LAST_TAG           := $(or $(word 1,$(DESCRIBE_PARTS)),v0.0.0)
COMMITS_SINCE_TAG  := $(or $(word 2,$(DESCRIBE_PARTS)),0)

LAST_VERSION       := $(subst v,,$(LAST_TAG))
LAST_VERSION_PARTS := $(subst ., ,$(LAST_VERSION))

MAJOR              := $(word 1,$(LAST_VERSION_PARTS))
MINOR              := $(word 2,$(LAST_VERSION_PARTS))
PATCH              := $(word 3,$(LAST_VERSION_PARTS))

NEXT_MAJOR         := $(shell echo $$(($(MAJOR)+1)))
NEXT_MINOR         := $(shell echo $$(($(MINOR)+1)))
NEXT_PATCH         := $(shell echo $$(($(PATCH)+$(COMMITS_SINCE_TAG))))

# The tag version on a tag, else the version a patch release would get.
VERSION            := $(MAJOR).$(MINOR).$(NEXT_PATCH)

.DEFAULT_GOAL := help

include $(MAKE_DIR)info.mk
include $(MAKE_DIR)git.mk
include $(MAKE_DIR)versioning.mk

