package = "nvim-nightfox"
version = "0.3.0-1"
description = {
  summary = "A port of the Neovim Nightfox themes",
  detailed = [[
    A complete port of the Neovim Nightfox colorscheme collection for Zed editor.
    Includes all variants.
  ]],
  license = "MIT",
  homepage = "https://github.com/cange/nightfox.zed",
}
dependencies = {
  "lua >= 5.4",
  "dkjson >= 2.7",
  "lua-toml >= 2.0",
  "nightfox.nvim >= 3.9",
}
build = {
  type = "builtin",
  modules = {
    ["nightfox.build"] = "lib/build.lua",
  },
}
