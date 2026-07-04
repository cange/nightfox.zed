.PHONY: build dev format lint prettify

LUA_ENV := eval $$(luarocks path)

prod:
	@$(LUA_ENV) && lua lib/build.lua
	@$(MAKE) format

dev:
	@$(LUA_ENV) && DEV_MODE=1 lua lib/build.lua
	@$(MAKE) prettify

prettify:
	@jq --sort-keys '.' themes/nvim-nightfox.json > themes/nvim-nightfox.json.tmp
	@mv themes/nvim-nightfox.json.tmp themes/nvim-nightfox.json
	@echo "[nvim-nightfox] ✓ Sort and prettify done"

format:
	@stylua lib/
	@$(MAKE) prettify
	@echo "[nvim-nightfox] ✓ Formatting done"

lint:
	@stylua --check lib/
	@echo "[nvim-nightfox] ✓ Linting done"
