local dkjson = require("dkjson")
local toml = require("toml")
local logger = require("lib.util").logger()

---@class nightfox_zed.Build
---@field private _ns string Namespace
local M = {}
M._ns = "nvim-nightfox"

---Reads data from extension file
---@return nightfox_zed.Metadata
function M._fetch_metadata()
  local filename = "extension.toml"
  logger.start("Metadata fetched", filename)
  local ok, file = pcall(io.open, filename, "r")
  if not ok or not file then
    return logger.error("Reading file", filename)
  end

  local file_content = assert(file:read("*all"))
  local data = toml.parse(file_content)
  logger.ok("Metadata fetched", filename)
  return data
end

function M.build()
  logger.start("Start mode", os.getenv("DEV_MODE") ~= nil and "dev" or "prod")
  local metadata = M._fetch_metadata()
  local filename = "themes/" .. metadata.id .. ".json"
  local file = assert(io.open(filename, "w"))
  M._ns = metadata.id or M._ns
  local content = dkjson.encode(require("lib.theme").generate(metadata, M._ns))

  if file then
    file:write(content .. "\n") -- ensure newline at the end of file
    file:close()
    logger.ok("File created", filename)
  else
    return logger.error("Opening file", filename)
  end
end

M.build()
