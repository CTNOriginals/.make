.PHONY: tag patch minor major

patch: ##@versioning Create and add a patch tag (vx.x.+commits)
	git tag "v$(MAJOR).$(MINOR).$(NEXT_PATCH)"

minor: ##@versioning Create and add a minor tag (vx.+1.x)
	git tag "v$(MAJOR).$(NEXT_MINOR).0"

major: ##@versioning Create and add a major tag (v+1.x.x)
	git tag "v$(NEXT_MAJOR).0.0"
