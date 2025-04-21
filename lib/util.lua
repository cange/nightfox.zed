---@class nightfox_zed.Util
---@field color nightfox_zed.UtilColor
---@field neovim_polyfill function
---@field tbl_merge function
local M = {}

---Provides a color in hexadecimal format with an alpha channel
---@param hex_color string
---@param percent number Alpha channel number between 0 and 1
---@return string Hexadecimal color with alpha channel
local function alpha(hex_color, percent)
  if percent < 0 or percent > 1 then
    error(string.format("[%s] Invalid value! Expected: between 0 and 1. Received: %s", M._ns, percent))
  end
  local alpha_value = math.floor(percent * 255)
  return hex_color .. string.format("%02X", alpha_value)
end

---@param base_color string
---@param accent_color string
---@param factor number
---@return string
local function blend(base_color, accent_color, factor)
  local C = require("nightfox.lib.color")
  return C(base_color):blend(C(accent_color), factor):to_css()
end

local debug = {
  blue = "#0000dd",
  cyan = "#00dddd",
  green = "#00dd00",
  magenta = "#dd00dd",
  red = "#dd0000",
  yellow = "#dddd00",
}

---@class nightfox_zed.UtilColor
---@field alpha function
---@field debug nightfox_nvim.Palette
M.color = {
  alpha = alpha,
  blend = blend,
  debug = debug,
}

---Merge two or more tables into one.
---@param base table
---@param ... table
---@return table
function M.tbl_merge(base, ...)
  local tables = { ... }
  for _, tbl in ipairs(tables) do
    for key, value in pairs(tbl) do
      base[key] = value
    end
  end
  return base
end

---Mocks Neovim's API since some endpoints are required by nightfox.nvim
function M.neovim_polyfill()
  vim = {
    fn = {
      has = function()
        return false
      end,
      expand = function(args)
        return args
      end,
    },
  }
end

return M
