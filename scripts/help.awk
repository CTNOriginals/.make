# Print targets tagged "##@section description", grouped by section in the
# order the sections first appear.
# Usage: awk -f help.awk $(MAKEFILE_LIST)

/^[a-zA-Z0-9_-][a-zA-Z0-9_.-]*:([^=]|$)/ && /##@/ {
	name = $0
	sub(/:.*/, "", name)

	rest = $0
	sub(/.*##@/, "", rest)
	section = rest
	sub(/ .*/, "", section)
	desc = rest
	sub(/^[^ ]+ */, "", desc)

	if (!(section in count)) order[++sections] = section
	n = ++count[section]
	names[section, n] = name
	descs[section, n] = desc
	if (length(name) > width) width = length(name)
}

END {
	printf "\nUsage:\n  make <target>\n"
	for (i = 1; i <= sections; i++) {
		section = order[i]
		printf "\n\033[1m%s\033[0m\n", section
		for (j = 1; j <= count[section]; j++)
			printf "  \033[36m%-*s\033[0m  %s\n", width, names[section, j], descs[section, j]
	}
}
