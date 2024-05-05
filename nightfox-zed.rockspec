package = "nvim-nightfox"
version = "0.1.0"
source = {
  tag = "0.1.0",
  url = "https://github.com/cange/nightfox.zed",
}
description = {
  summary = "A port of nightfox.nvim theme from Neovim to Zed",
  detailed = [[
    This theme uses the original color palette of nightfox.nvim
    https://github.com/EdenEast/nightfox.nvim theme.
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
    build = "lib/build.lua",
  },
}
