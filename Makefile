.PHONY: all setup start stop test

ARGS := $(wordlist 2,$(words $(MAKECMDGOALS)),$(MAKECMDGOALS))
$(eval $(ARGS):;@:)

all:
	@echo Select some task of the defined in the Makefile.

setup:
	@docker compose down -v
	@docker compose run --rm -e MIX_ENV=dev -e DEV_CONTAINER=1 api mix setup

start:
	@docker compose up -d

stop:
	@docker compose stop

test:
	@docker compose run --rm -e MIX_ENV=test api mix test $(ARGS)
