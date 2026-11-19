.PHONY: help list version

help: ##@help Display all commands and descriptions
	@awk -f $(MAKE_DIR)scripts/help.awk $(MAKEFILE_LIST)

list: ##@help List all targets and their commands
	@awk -v skip="help list" -f $(MAKE_DIR)scripts/list.awk $(MAKEFILE_LIST)

version: ##@help Log the current version
	@echo "v$(CURRENT_VERSION_PATCH)"


