CURL := curl --silent --location --create-dirs
DEPDIR := .tmp
LUA_ENV := eval $$(luarocks path)
THEME_PATH := themes/nvim-nightfox.json

# --- install ---
ifeq ($(shell uname -s),Darwin)
	JQ_ARCH ?= jq-macos-arm64
	STYLUA_ARCH ?= macos-aarch64
else
	JQ_ARCH ?= jq-linux-amd64
	STYLUA_ARCH ?= linux-x86_64
endif

# jq ---
# Use the system jq if available, otherwise fallback to the downloaded .tmp version
JQ := $(shell command -v jq 2>/dev/null || echo $(DEPDIR)/$(JQ_ARCH)/jq)
$(JQ):
	@$(CURL) https://github.com/jqlang/jq/releases/latest/download/$(notdir $(JQ_ARCH)) -o $(JQ)
	@chmod +x $(JQ)

# stylua ---
STYLUA := $(DEPDIR)/stylua-$(STYLUA_ARCH)
STYLUA_TARBALL := $(STYLUA).zip
$(STYLUA):
	@$(CURL) https://github.com/JohnnyMorganz/StyLua/releases/latest/download/$(notdir $(STYLUA_TARBALL)) -o $(STYLUA_TARBALL)
	@unzip $(STYLUA_TARBALL) -d $(STYLUA)
	@rm -rf $(STYLUA_TARBALL)

# --- jobs ---
.PHONY: prod
prod:
	@$(LUA_ENV) && lua lib/build.lua
	@$(MAKE) prettify
	@$(MAKE) format

.PHONY: dev
dev:
	@$(LUA_ENV) && DEV_MODE=1 lua lib/build.lua
	@$(MAKE) prettify

.PHONY: prettify
prettify: $(JQ)
	@$(JQ) --sort-keys '.' $(THEME_PATH) > themes/tmp.json
	@mv themes/tmp.json $(THEME_PATH)
	@echo "[nvim-nightfox] ✓ Sort and prettify done"

.PHONY: stylua
stylua: $(STYLUA)

.PHONY: format
format: $(STYLUA)
	@$(STYLUA)/stylua .

.PHONY: lint
lint: $(STYLUA)
	@cat $(THEME_PATH) | $(JQ) empty
	@$(STYLUA)/stylua --check lib/
