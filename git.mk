.PHONY: update-make git-watch

update-make: ##@git Update the .make submodule to the latest version
	git submodule update --remote .make

git-watch: ##@git Show git status and the log graph, redrawn on every change
	@sh $(MAKE_DIR)scripts/git-watch.sh
