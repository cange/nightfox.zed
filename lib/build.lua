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

function M.build()
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
