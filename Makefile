build:
	@lua lib/build.lua && make format

dev:
	@DEV_MODE=1 lua lib/build.lua && make format

format:
	@echo "[nvim-nightfox] ⚙ Sort and prettify" && jq --sort-keys '.' themes/nvim-nightfox.json > tmp.json && mv tmp.json themes/nvim-nightfox.json
