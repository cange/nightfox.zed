---@class nightfox_zed.Util
---@field color nightfox_zed.UtilColor
---@field neovim_polyfill fun()
---@field tbl_merge fun(base: table, ...: table): table
---@field logger fun(): nightfox_nvim.Logger
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
  -- stylua: ignore start
  blue =    { base = "#0000dd", dim = "#000088", bright = "#0000ff" },
  cyan =    { base = "#00dddd", dim = "#008888", bright = "#00ffff" },
  green =   { base = "#00dd00", dim = "#00a000", bright = "#00ff00" },
  magenta = { base = "#dd00dd", dim = "#880088", bright = "#ff00ff" },
  orange =  { base = "#dd8800", dim = "#996600", bright = "#ff8800" },
  pink =    { base = "#dd88dd", dim = "#996699", bright = "#ff88ff" },
  red =     { base = "#dd0000", dim = "#990000", bright = "#ff0000" },
  yellow =  { base = "#dddd00", dim = "#999900", bright = "#ffff00" },
  -- stylua: ignore end
}

---@class nightfox_zed.UtilColor
---@field alpha fun(hex_color: string, percent: number): string
---@field blend fun(base_color: string, accent_color: string, factor: number): string
---@field debug table<'blue' | 'cyan' | 'green' | 'magenta' | 'orange' | 'pink' | 'red' | 'yellow', nightfox_nvim.Shade>
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
---@param data string | table
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
