local dkjson = require("dkjson")
local toml = require("toml")

---@class ZedBuild
---@field private _ns string Namespace
local M = {}
M._ns = "nvim-nightfox"

---Reads data from extension file
---@return Metadata
function M._fetch_metadata()
  local filename = "extension.toml"
  print(string.format("[%s] ⚙ Fetch metadata %q", M._ns, filename))
  local file = assert(io.open(filename, "r"))
  if file then
    local file_content = assert(file:read("*all"))
    local data = toml.parse(file_content)
    print(string.format("[%s] ✓ Metadata fetched", M._ns))
    return data
  else
    error(string.format("[%s] Error reading file: %q", M._ns, filename))
  end
end

function M.build()
  print(string.format("[%s] → Start in %q mode", M._ns, os.getenv("DEV_MODE") ~= nil and "dev" or "prod"))
  local metadata = M._fetch_metadata()
  local filename = "themes/" .. metadata.id .. ".json"
  local file = assert(io.open(filename, "w"))
  M._ns = metadata.id or M._ns
  local content = dkjson.encode(require("lib.theme").generate(metadata, M._ns))

  if file then
    file:write(content .. "\n") -- ensure newline at the end of file
    file:close()
    print(string.format("[%s] ✓ %q file created", M._ns, filename))
  else
    error(string.format("[%s] Error opening file: %q", M._ns, filename))
  end
end

M.build()
