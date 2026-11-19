# Print every target that has a recipe, followed by its commands, grouped by
# its "##@section" tag in the order the sections first appear. Untagged
# targets go under "other".
# Usage: awk -v skip="help list" -f list.awk $(MAKEFILE_LIST)

BEGIN {
	n = split(skip, s, " ")
	for (i = 1; i <= n; i++) skipped[s[i]] = 1
}

# Store the current target if it has commands.
function flush() {
	if (target != "" && cmds != "") {
		if (!(section in count)) order[++sections] = section
		n = ++count[section]
		names[section, n] = target
		recipes[section, n] = cmds
	}
	target = ""
	cmds = ""
}

# Target line. Skips special targets (.PHONY etc.) and FOO:=x assignments.
/^[a-zA-Z0-9_-][a-zA-Z0-9_.-]*:([^=]|$)/ {
	flush()
	name = $0
	sub(/:.*/, "", name)
	if (name in skipped) next
	target = name

	section = "other"
	if (match($0, /##@[^ ]+/)) section = substr($0, RSTART + 3, RLENGTH - 3)
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

END {
	flush()
	for (i = 1; i <= sections; i++) {
		section = order[i]
		printf "\n\033[1m%s\033[0m\n", section
		for (j = 1; j <= count[section]; j++)
			printf "  \033[36m%s\033[0m\n%s", names[section, j], recipes[section, j]
	}
}
