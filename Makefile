.PHONY: all test

ARGS := $(wordlist 2,$(words $(MAKECMDGOALS)),$(MAKECMDGOALS))
$(eval $(ARGS):;@:)

all:
	@echo Select some task of the defined in the Makefile.

setup:
	@docker compose run --rm -e MIX_ENV=dev api mix setup

test:
	@docker compose run --rm -e MIX_ENV=test api mix test $(ARGS)
