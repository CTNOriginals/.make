.PHONY: update-make

update-make: ##@git Update the .make submodule to the latest version
	git submodule update --remote .make
