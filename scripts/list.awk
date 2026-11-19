# Print every target that has a recipe, followed by its commands.
# Usage: awk -v skip="help list" -f list.awk $(MAKEFILE_LIST)

BEGIN {
	n = split(skip, s, " ")
	for (i = 1; i <= n; i++) skipped[s[i]] = 1
}

function flush() {
	if (target != "" && cmds != "")
		printf "  \033[36m%s\033[0m\n%s\n", target, cmds
	target = ""
	cmds = ""
}

# Target line. Skips special targets (.PHONY etc.) and FOO:=x assignments.
/^[a-zA-Z0-9_-][a-zA-Z0-9_.-]*:([^=]|$)/ {
	flush()
	name = $0
	sub(/:.*/, "", name)
	if (!(name in skipped)) target = name
	next
}

# Recipe line.
/^\t/ && target != "" {
	cmds = cmds "    " substr($0, 2) "\n"
	next
}

# Blank lines and comments do not end a recipe, anything else does.
/^[ \t]*(#|$)/ { next }
{ flush() }

END { flush() }
