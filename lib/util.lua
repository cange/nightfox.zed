---@class nightfox_zed.Util
---@field color nightfox_zed.UtilColor
---@field neovim_polyfill function
---@field tbl_merge function
---@field logger function
local M = {}
M._ns = "util"

---Provides a color in hexadecimal format with an alpha channel
---@param hex_color string
---@param percent number Alpha channel number between 0 and 1
---@return string Hexadecimal color with alpha channel
local function alpha(hex_color, percent)
  if percent < 0 or percent > 1 then
    error(string.format("[%s] Invalid value! Expected: between 0 and 1. Received: %s", M._ns, percent))
  end
  local alpha_value = math.floor(percent * 255 + 0.5) -- 255 + 0.5 Round to nearest integer for 8-bit alpha value
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

---Simple table serialization for logging
---@param data table
---@return string
local function stringify(data)
  if type(data) ~= "table" then
    return tostring(data or "")
  end

  local parts = {}
  for k, v in pairs(data) do
    local key_str = type(k) == "string" and k or nil
    local val_str = type(v) == "table" and stringify(v) or tostring(v)
    table.insert(parts, (key_str and key_str .. " = " or "") .. val_str)
  end
  return "{ " .. table.concat(parts, ", ") .. " }"
end

---Logs a message with a type and optional metadata.
---@param type 'ok' | 'start' | 'error'
---@param msg string | table
---@param meta? string | table
local function log(type, msg, meta)
  local icons = { ok = "✓", start = "⚙", error = "✕" }
  local msg_str = stringify(msg)
  local meta_str = meta and stringify(meta) or nil
  if meta_str then
    print(string.format("[%s] %s %s %s", M._ns, icons[type], msg_str, meta_str))
  else
    print(string.format("[%s] %s %s", M._ns, icons[type], msg_str))
  end
end

---@class nightfox_nvim.Logger
---@field start fun(msg: string | table, meta?: table)
---@field ok fun(msg: string | table, meta?: table)
---@field error fun(msg: string | table, details: string | table)

M._ns = "nvim-nightfox"

---@return nightfox_nvim.Logger
M.logger = function()
  return {
    ok = function(msg, meta)
      log("ok", msg, meta)
    end,
    start = function(msg, meta)
      log("start", msg, meta)
    end,
    error = function(msg, meta)
      log("error", msg, meta)
    end,
  }
end

return M
