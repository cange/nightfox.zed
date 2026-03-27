.PHONY: build dev format

LUA_ENV := eval $$(luarocks --lua-version=5.5 path)

build:
	@$(LUA_ENV) && lua lib/build.lua
	@$(MAKE) format

dev:
	@$(LUA_ENV) && DEV_MODE=1 lua lib/build.lua
	@$(MAKE) format

format:
	@jq --sort-keys '.' themes/nvim-nightfox.json > themes/nvim-nightfox.json.tmp
	@mv themes/nvim-nightfox.json.tmp themes/nvim-nightfox.json
	@echo "[nvim-nightfox] ✓ Sort and prettify"
