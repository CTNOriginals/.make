#!/bin/sh
# Redraw the git status and log graph whenever they change.
# Polls every $1 seconds (default 1) and only redraws when the frame differs
# from the last one, so no file watcher is needed. tput lines is part of the
# frame, so a terminal resize redraws too.
# --no-optional-locks: a plain git status rewrites .git/index.
# Usage: sh git-watch.sh [interval]

interval=${1:-1}
prev=

while :; do
	frame=$( {
		git -c color.status=always --no-optional-locks status -sb
		echo
		git log --color=always --decorate --oneline --graph --all
	} 2>/dev/null | head -n $(($(tput lines) - 1)) )

	if [ "$frame" != "$prev" ]; then
		clear
		printf '%s\n' "$frame"
		prev=$frame
	fi

	sleep "$interval"
done
