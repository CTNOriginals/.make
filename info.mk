.PHONY: help list vars version

help: ##@info Display all commands and descriptions
	@awk -f $(MAKE_DIR)scripts/help.awk $(MAKEFILE_LIST)

list: ##@info List all targets and their commands
	@awk -v skip="" -f $(MAKE_DIR)scripts/list.awk $(MAKEFILE_LIST)

# make passes each variable as "name US resolved" (US = \037), with single
# quotes escaped for the shell. vars.awk keeps only the variables that the
# makefiles assign and reads their literal definitions from the files.
vars: ##@info List all variables with their definition and resolved value
	@{ $(foreach v,$(.VARIABLES),$(if $(filter file override,$(origin $v)), \
		printf '%s\037%s\n' '$v' '$(subst ','\'',$($v))';)) } \
	| awk -f $(MAKE_DIR)scripts/vars.awk - $(MAKEFILE_LIST)

version: ##@info Log the current version
	@echo "v$(VERSION)"


