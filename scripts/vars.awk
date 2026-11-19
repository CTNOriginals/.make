# Print every variable assigned in the makefiles, grouped by the file that
# assigns it first, as aligned "NAME resolved op literal" columns with the
# definition dimmed. The value column is capped at VALUE_MAX characters, a
# longer value only pushes its own definition over. A variable assigned more
# than once (ifeq branches, +=) puts its first definition on that line and
# each next one under it.
# stdin ("-") holds one "name US resolved" line per variable, from make
# itself, since only make knows the resolved values.
# Usage: ... | awk -f vars.awk - $(MAKEFILE_LIST)

BEGIN {
	FS = "\037"
	VALUE_MAX = 12
}

FILENAME == "-" {
	resolved[$1] = $2
	next
}

# Assignment line: NAME op value, with op one of = := ::= :::= ?= += !=
/^[a-zA-Z0-9_.-]+[ \t]*(::?:?|[?+!])?=/ {
	name = $0
	sub(/[ \t]*(::?:?|[?+!])?=.*/, "", name)
	if (!(name in resolved)) next

	# Split "op literal" out of the line.
	lit = $0
	sub(/^[^ \t:?+!=]+[ \t]*/, "", lit)
	op = lit
	sub(/=.*/, "=", op)
	sub(/^[^=]*=[ \t]*/, "", lit)
	if (length(op) > owidth) owidth = length(op)

	if (!(name in ndefs)) {
		file = FILENAME
		sub(/.*\//, "", file)
		if (!(file in count)) order[++files] = file
		names[file, ++count[file]] = name
		if (length(name) > width) width = length(name)
	}
	n = ++ndefs[name]
	ops[name, n] = op
	lits[name, n] = lit
}

END {
	for (name in ndefs) {
		v = resolved[name] == "" ? "(empty)" : resolved[name]
		if (length(v) > vwidth) vwidth = length(v)
	}
	if (vwidth > VALUE_MAX) vwidth = VALUE_MAX
	for (i = 1; i <= files; i++) {
		file = order[i]
		printf "\n\033[1m%s\033[0m\n", file
		for (j = 1; j <= count[file]; j++) {
			name = names[file, j]
			value = sprintf("%-*s", vwidth, resolved[name])
			if (resolved[name] == "") value = sprintf("\033[2m%-*s\033[0m", vwidth, "(empty)")
			printf "  \033[36m%-*s\033[0m  %s", width, name, value
			for (k = 1; k <= ndefs[name]; k++) {
				if (k > 1) printf "  %-*s  %-*s", width, "", vwidth, ""
				printf "  \033[2m%*s %s\033[0m\n", owidth, ops[name, k], lits[name, k]
			}
		}
	}
}
