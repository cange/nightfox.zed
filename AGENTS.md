# Nightfox for Zed

Port of [nightfox.nvim](https://github.com/EdenEast/nightfox.nvim) color schemes. Lua scripts read `nightfox.nvim`
palettes and generate `themes/nvim-nightfox.json` for Zed.

## Project and commands

| Command         | Description                      |
| --------------- | -------------------------------- |
| `make prod`     | Production build and formatting  |
| `make dev`      | Development build                |
| `make format`   | Run StyLua                       |
| `make prettify` | Sort and prettify generated JSON |
| `make stylua`   | Run StyLua                       |
| `make lint`     | Check JSON and Lua formatting    |

**Key Files**

- `lib/build.lua`: Entry point.
- `lib/theme.lua`: Palette mapping.
- `lib/util.lua`: Helpers and Neovim polyfill.
- `lib/types.lua`: LuaLS type annotations.
- `themes/nvim-nightfox.json`: Generated output (do not edit).
- `extension.toml`: Zed metadata.
- `nvim-nightfox-0.0.0-1.rockspec`: Luarocks spec.

## Commit and PR titles

Follow [Conventional Commits 1.0.0](https://www.conventionalcommits.org/en/v1.0.0/).
Format: `type(scope)!: description`

## Find authoritative documentation

- [nightfox.nvim](https://github.com/EdenEast/nightfox.nvim) for palette specifications.
- [Zed documentation](https://zed.dev/) for theme property definitions.

## Code Style

- **Runtime**: Lua `vim` is a polyfill.
- **Formatting**: StyLua.
- **Module Pattern**: `local M = {}; ... return M`.
- **Types**: LuaLS annotations (`---@class`, `---@param`, etc.).
- **Naming**: `snake_case` (variables/functions), `PascalCase` (themes).
- **Zed Keys**: Dot-notation strings (e.g., `["editor.background"]`).

## Common Pitfalls

- Never edit `themes/nvim-nightfox.json` manually.
- Alpha levels are dependent on appearance mode (`opaque` vs `blurred`).
