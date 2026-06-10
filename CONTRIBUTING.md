# Contributing

Thanks for contributing!

## Guidelines

- All changes happen through Pull Requests
- Fork the repo and create your branch from `main`.
- Use [Conventional Commits] for writing explicit and meaningful commit messages.
- Use `stylua .` to format Lua code to maintain consistent coding styles.
- If it's your first time contributing to a project then read [About pull requests] on GitHub's docs.
- Commit only production-ready theme files (`themes/`).

[Conventional Commits]: https://www.conventionalcommits.org/
[About pull requests]: https://docs.github.com/en/github/collaborating-with-pull-requests/proposing-changes-to-your-work-with-pull-requests/about-pull-requests

## Development

Theme lua-based generator lives in `lib/` and can be built via `make` commands.

### Prerequisites

To build the theme, make sure the following are installed:

- [Lua](https://www.lua.org/)
- [Luarocks](https://luarocks.org/)
- [jq](https://jqlang.org/) (for JSON formatting)

Install the required Lua dependencies via (from `nvim-nightfox-<version>.rockspec`):

```bash
luarocks make --only-deps --local
```

### Workflow

1. Create a fork of the repository and clone it locally.
2. Use a descriptive name for your topic branch.
3. Edit the Lua files in `lib/`.
4. Run `make dev` command to generate a Zed theme file in `themes/` with theme names suffixed with `(dev)` for testing.
5. Run `make prod` command to generate the production-ready theme file.

#### Testing

One can test the changes in Zed directly by using a symlink of the generated theme file:

1. Run `ln -s $(pwd)/themes/nvim-nightfox.json ~/.config/zed/themes/` (macOS example).
2. Restart Zed.
3. The `(dev)` marked themes should now be available within the editor's theme picker.

## License

By contributing, you agree that your contributions will be licensed under the project's license.
