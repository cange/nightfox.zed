<div align="center">
  <h1>Nightfox for Zed</h1>

_A theme collection – Ported from the beloved [nightfox.nvim](https://github.com/EdenEast/nightfox.nvim) theme_

[![Downloads](https://img.shields.io/badge/dynamic/json?url=https%3A%2F%2Fapi.zed.dev%2Fextensions%3Fmax_schema_version%3D1%26filter%3DNightfox%2520Themes%2520-%2520opaque%2520%2F%2520blurred&query=%24.data%5B%3A1%5D.download_count&style=for-the-badge&logo=zed&label=Downloads&color=blue)](https://github.com/EdenEast/nightfox.nvim)
[![Zed Extension](https://img.shields.io/badge/Zed-Extension-blue?style=for-the-badge&logo=zed)](https://github.com/zed-industries/zed)

</div>

---

## Theme Showcase

- All themes available in both **opaque** and **blurred** variants
- Screenshots using _"JetBrainsMono"_ as font

<table>
  <tr>
    <td align="center" width="50%">
      <h3>🌙 Nightfox</h3>
      <img src="https://github.com/cange/nightfox.zed/assets/28717/c5c979a2-5fb0-4f0c-bbea-3f9ff8b38b8a" alt="Nightfox Theme" width="100%">
      The classic dark theme
    </td>
    <td align="center">
      <h3>🌆 Duskfox</h3>
      <img src="https://github.com/cange/nightfox.zed/assets/28717/c5442cd7-b938-4014-b48d-a2c1e88e28c7" alt="Duskfox Theme" width="100%">
      Balanced twilight theme
    </td>
  </tr>
  <tr>
    <td align="center" width="50%">
      <h3>☀️ Dayfox</h3>
      <img src="https://github.com/cange/nightfox.zed/assets/28717/0de9ba81-aa20-472b-bdca-91f6d95edfa9" alt="Dayfox Theme" width="100%">
      Light theme for bright environments
    </td>
    <td align="center">
      <h3>🌅 Dawnfox</h3>
      <img src="https://github.com/cange/nightfox.zed/assets/28717/454f34b1-70d8-444e-b028-9dee850f9bda" alt="Dawnfox Theme" width="100%">
      Warm dawn colors with soft contrast
    </td>
  </tr>
  <tr>
    <td align="center">
      <h3>🧊 Nordfox</h3>
      <img src="https://github.com/cange/nightfox.zed/assets/28717/24816d4c-d2a7-45ef-a332-5f6dee5393fd" alt="Nordfox Theme" width="100%">
      Cool Nordic-inspired theme
    </td>
    <td align="center">
      <h3>🌍 Terafox</h3>
      <img src="https://github.com/cange/nightfox.zed/assets/28717/4ef6cb17-843e-48c0-96db-b9566621b894" alt="Terafox Theme" width="100%">
      Earthy greens and warm tones
    </td>
  </tr>
  <tr>
    <td align="center" colspan="2">
      <h3>⚫ Carbonfox</h3>
      <div>
        <img src="https://github.com/cange/nightfox.zed/assets/28717/34635356-1c52-4d86-9c95-e603e8b1fa42" alt="Carbonfox Theme" width="50%">
        <br />
        Deep black theme for minimal distraction
      </div>
    </td>
  </tr>
</table>

---

## 🚀 Installation

1. Open Zed editor
2. Press `Cmd+Shift+P` (macOS) or `Ctrl+Shift+P` (Linux/Windows)
3. Type "Extensions" and select "zed: extensions"
4. Search for "Nightfox"
5. Click "Install"

---

## 🛠️ Development

<details>
<summary>For Contributors</summary>

### Prerequisites

To build the theme, make sure the following is installed:

- [Lua](https://www.lua.org/)
- [Luarocks](https://luarocks.org/)
- [jq](https://jqlang.org/) (for JSON formatting)

Install the required Lua dependencies via (from `nvim-nightfox-<version>.rockspec`):

```bash
luarocks make --only-deps --local
```

### Development Workflow

1. Create a fork of the repository and clone it locally.
2. Use a descriptive name for your topic branch.
3. Edit the Lua files in `lib/`.
4. Run `make dev` command to generate a theme file in `themes/` with theme names suffixed with `(dev)`.

#### Testing

One can test the changes in Zed directly by using a symlink of the generated theme file:

1. Run `ln -s $(pwd)/themes/nvim-nightfox.json ~/.config/zed/themes/` (macOS example).
2. Restart Zed.
3. The `(dev)` marked themes should now be available within the editor's theme picker.

### Build

```bash
make build
```

This generates the appropriate production ready Zed theme file.

</details>

---

## 🙏 Acknowledgements

- **[EdenEast](https://github.com/EdenEast)** - Creator of the original [nightfox.nvim](https://github.com/EdenEast/nightfox.nvim)
- **Zed Team** - For creating an amazing editor

---

<div align="center">
  <sub>Made with ❤️ for the Zed community</sub>
</div>
