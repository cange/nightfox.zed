local M = {}

---Reads data from extension file
---@return Metadata
function M.fetch_metadata()
  local filename = "extension.toml"
  local file = assert(io.open(filename, "r"))

  if file then
    local file_content = assert(file:read("*all"))
    local data = require("toml").parse(file_content)
    return data
  end
  return { name = "", authors = {}, description = "", repository = "" }
end

function M._neovim_polyfill()
  -- mocks certain endpoint of neovim's API which are required by nightfox.nvim
  vim = {
    fn = {
      has = function() return false end,
      expand = function(args) return args end,
    },
  }
end

---Provides a color in hexadecimal format with an alpha channel
---@param hex_color string
---@param percent number Alpha channel number between 0 and 1
---@return string Hexadecimal color with alpha channel
function M.hex_color_with_alpha(hex_color, percent)
  if percent < 0 or percent > 1 then error("Invalid percentage: must be between 0 and 1") end
  local alpha_value = math.floor(percent * 255)
  local hex_alpha = string.format("%02X", alpha_value)

  return hex_color .. hex_alpha
end

---Maps values of nightfox.vim to zed's theme properties
---@param name "Nightfox" | "Dayfox" | "Dawnfox" | "Duskfox" | "Nordfox" | "Terafox" | "Carbonfox"
---@param appearance "dark" | "light"
---@return table
function M.theme(name, appearance)
  local p = require("nightfox.palette").load(name:lower())
  return {
    name = name,
    appearance = appearance,
    style = {
    },
  }
end

function M.build()
  M._neovim_polyfill()
  local filename = "themes/nightfox.json"
  local file = assert(io.open(filename, "w"))
  local dkjson = require("dkjson")
  local metadata = M.fetch_metadata()
  local content = dkjson.encode({
    ["$schema"] = "https://zed.dev/schema/themes/v0.1.0.json",
    author = metadata.authors[1],
    description = metadata.description,
    name = metadata.name,
    url = metadata.repository,
    themes = {
      M.theme("Nightfox", "dark"),
      M.theme("Dayfox", "light"),
      M.theme("Dawnfox", "light"),
      M.theme("Duskfox", "light"),
      M.theme("Nordfox", "dark"),
      M.theme("Terafox", "dark"),
      M.theme("Carbonfox", "dark"),
    },
  }, { indent = true, keyorder = { "name", "author", "description", "url", "themes" } })

  if file then
    file:write(content)
    file:close()
  end
end

M.build()

---@class Metadata
---@field name string
---@field authors table
---@field description string
---@field repository string
