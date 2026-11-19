.PHONY: help list version

help: ##@info Display all commands and descriptions
	@awk -f $(MAKE_DIR)scripts/help.awk $(MAKEFILE_LIST)

list: ##@info List all targets and their commands
	@awk -v skip="" -f $(MAKE_DIR)scripts/list.awk $(MAKEFILE_LIST)

version: ##@info Log the current version
	@echo "v$(VERSION)"


