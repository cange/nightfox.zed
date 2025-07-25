.PHONY: build dev format

build:
	@lua lib/build.lua
	@$(MAKE) format

dev:
	@DEV_MODE=1 lua lib/build.lua
	@$(MAKE) format

format:
	@jq --sort-keys '.' themes/nvim-nightfox.json > themes/nvim-nightfox.json.tmp
	@mv themes/nvim-nightfox.json.tmp themes/nvim-nightfox.json
	@echo "[nvim-nightfox] ✓ Sort and prettify"
