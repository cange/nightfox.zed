# Contributing

Thanks for contributing!

## Guidelines

The following is a set of guidelines for contributing to this project.

1. Create a fork of the repository and clone it locally.
2. Use a descriptive name for your topic branch.
3. Edit the Lua files in `lib/`. _Do not edit `themes/nvim-nightfox.json` directly, as it is generated._
4. Run `make dev` to generate a theme file with theme names suffixed with `(dev)`.

### Testing

To test the changes in Zed directly one can symlink the generated theme file locally like:

1. Run `ln -s $(pwd)/themes/nvim-nightfox.json ~/.config/zed/themes/` (macOS example).
2. Restart Zed.
3. The `(dev)` marked themes should now be available within the editor's theme picker/.

### Prerequisites

To build the theme, you need:

- Lua 5.4+
- Luarocks
- jq (for JSON formatting)

Install the required Lua dependencies:

```bash
luarocks install nvim-nightfox
```

## Recommendations

- Run `make build` before opening a PR, ensure you run the production build.
- Consider using [Conventional Commits] rules for creating explicit and meaningful commit messages.
- If it's your first time contributing to a project then read [About pull requests] on Github's docs.

[Conventional Commits]: https://www.conventionalcommits.org/
[About pull requests]: https://docs.github.com/en/github/collaborating-with-pull-requests/proposing-changes-to-your-work-with-pull-requests/about-pull-requests

## License

By contributing, you agree that your contributions will be licensed under the project's license.
