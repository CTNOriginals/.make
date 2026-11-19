.PHONY: help list version

help: ##@help Display all commands and descriptions
	@awk 'BEGIN {FS = ":.*##@"; printf "\nUsage:\n  make <target>\n"} \
	/^[.a-zA-Z0-9_-]+:.*?##@/ { \
		split($$2, parts, " "); \
		section = parts[1]; \
		description = substr($$2, length(section) + 2); \
		sections[section] = sections[section] sprintf("  \033[36m%-15s\033[0m %s\n", $$1, description); \
	} \
	END { \
		for (section in sections) { \
			printf "\n\033[1m%s\033[0m\n", section; \
			printf "%s", sections[section]; \
		} \
	}' $(MAKEFILE_LIST)

list: ##@help List all targets and their commands
	@awk 'BEGIN { \
		target = ""; cmds = ""; \
	} \
	/^[.a-zA-Z0-9_-]+:/ && !/^\.PHONY/ { \
		if (target != "" && cmds != "") { \
			printf "  \033[36m%-15s\033[0m\n%s\n", target, cmds; \
		} \
		split($$0, a, ":"); \
		target = (a[1] == "help" || a[1] == "list") ? "" : a[1]; \
		cmds = ""; \
	} \
	/^\t/ && target != "" { \
		cmds = cmds "    " substr($$0, 2) "\n"; \
	} \
	END { \
		if (target != "" && cmds != "") { \
			printf "  \033[36m%-15s\033[0m\n%s\n", target, cmds; \
		} \
	}' $(MAKEFILE_LIST)

version: ##@help Log the current version
	@echo "v$(CURRENT_VERSION_PATCH)"


