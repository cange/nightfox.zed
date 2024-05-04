package = "nightfox-zed"
version = "0.1.0"
source = {
  tag = "0.1.0",
  url = "https://github.com/cange/nightfox.zed",
}
description = {
  summary = "Nightfox theme is a direct Nvim port to Zed",
  detailed = [[
    This theme uses the original color palette of nightfox.vim
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
