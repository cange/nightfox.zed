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
      border = "#1d3337",
      ["border.variant"] = "#1d3337",
      ["border.focused"] = "#293e40",
      ["border.selected"] = "#1d3337",
      ["border.transparent"] = "#1d3337",
      ["border.disabled"] = "#1d3337",
      ["elevated_surface.background"] = "#0f1c1e",
      ["surface.background"] = "#1d3337",
      background = "#152528",
      ["element.background"] = "#ff83491a", -- 1A = 10%
      ["element.hover"] = "#d96f3e33",      -- 33 = 20%
      ["element.active"] = "#ff8349cc",     -- CC = 80%
      ["element.selected"] = "#ff834999",   -- 99 = 60%
      ["element.disabled"] = "#d96f3e1a",   -- 1A = 100
      ["drop_target.background"] = "#0f1c1e",
      ["ghost_element.background"] = nil,
      ["ghost_element.hover"] = "#425e5e80",
      ["ghost_element.selected"] = "#293e40",
      ["ghost_element.active"] = nil,
      ["ghost_element.disabled"] = nil,
      text = "#eaeeee",
      ["text.muted"] = "#e6eaea",
      ["text.disabled"] = "#6d7f8b",
      ["text.placeholder"] = "#587b7b",
      ["text.accent"] = "#cbd9d8",
      icon = "#ff0000",
      ["icon.muted"] = "#00ff00",
      ["icon.disabled"] = "#0000ff",
      ["icon.placeholder"] = "#ffff00",
      ["icon.accent"] = "#00ffff",
      ["status_bar.background"] = "#0f1c1e",
      ["title_bar.background"] = "#0f1c1e",
      ["toolbar.background"] = "#152528aa",
      ["tab_bar.background"] = "#0f1c1e",
      ["tab.inactive_background"] = "#0f1c1e",
      ["tab.active_background"] = "#152528",
      ["search.match_background"] = nil,
      ["panel.background"] = "#152528",
      ["panel.focused_border"] = nil,
      ["pane.focused_border"] = nil,
      ["scrollbar_thumb.background"] = "#282a30",
      ["scrollbar.thumb.hover_background"] = "#4e5157",
      ["scrollbar.thumb.border"] = "#282a30",
      ["scrollbar.track.background"] = "#152528",
      ["scrollbar.track.border"] = "#0f1c1e",
      ["editor.foreground"] = "#e6eaea",
      ["editor.background"] = "#152528",
      ["editor.gutter.background"] = "#152528",
      ["editor.subheader.background"] = nil,
      ["editor.active_line.background"] = "#1d3337",
      ["editor.highlighted_line.background"] = nil,
      ["editor.line_number"] = "#587b7b",
      ["editor.active_line_number"] = "#fda47f",
      ["editor.invisible"] = nil,
      ["editor.wrap_guide"] = "#1d3337",
      ["editor.active_wrap_guide"] = "#1d3337",
      ["editor.document_highlight.read_background"] = nil,
      ["editor.document_highlight.write_background"] = nil,
      ["terminal.background"] = "#152528",
      ["terminal.foreground"] = nil,
      ["terminal.bright_foreground"] = nil,
      ["terminal.dim_foreground"] = nil,
      ["terminal.ansi.black"] = "#2f3239",
      ["terminal.ansi.bright_black"] = "#4e5157",
      ["terminal.ansi.dim_black"] = "#282a30",
      ["terminal.ansi.red"] = "#e85c51",
      ["terminal.ansi.bright_red"] = "#eb746b",
      ["terminal.ansi.dim_red"] = "#c54e45",
      ["terminal.ansi.green"] = "#7aa4a1",
      ["terminal.ansi.bright_green"] = "#8eb2af",
      ["terminal.ansi.dim_green"] = "#688b89",
      ["terminal.ansi.yellow"] = "#fda47f",
      ["terminal.ansi.bright_yellow"] = "#fdb292",
      ["terminal.ansi.dim_yellow"] = "#d78b6c",
      ["terminal.ansi.blue"] = "#5a93aa",
      ["terminal.ansi.bright_blue"] = "#73a3b7",
      ["terminal.ansi.dim_blue"] = "#4d7d90",
      ["terminal.ansi.magenta"] = "#ad5c7c",
      ["terminal.ansi.bright_magenta"] = "#b97490",
      ["terminal.ansi.dim_magenta"] = "#934e69",
      ["terminal.ansi.cyan"] = "#a1cdd8",
      ["terminal.ansi.bright_cyan"] = "#afd4de",
      ["terminal.ansi.dim_cyan"] = "#89aeb8",
      ["terminal.ansi.white"] = "#ebebeb",
      ["terminal.ansi.bright_white"] = "#eeeeee",
      ["terminal.ansi.dim_white"] = "#c8c8c8",
      ["link_text.hover"] = "#a1cdd8",
      conflict = "#fda47f",
      ["conflict.background"] = nil,
      ["conflict.border"] = nil,
      created = "#7aa4a1",
      ["created.background"] = nil,
      ["created.border"] = nil,
      deleted = "#e85c51",
      ["deleted.background"] = nil,
      ["deleted.border"] = nil,
      error = "#e85c51",
      ["error.background"] = nil,
      ["error.border"] = "#e85c51",
      hidden = "#587b7b",
      ["hidden.background"] = nil,
      ["hidden.border"] = nil,
      hint = "#4e5157",
      ["hint.background"] = nil,
      ["hint.border"] = nil,
      ignored = "#587b7b",
      ["ignored.background"] = nil,
      ["ignored.border"] = nil,
      info = nil,
      ["info.background"] = nil,
      ["info.border"] = nil,
      modified = "#fda47f",
      ["modified.background"] = nil,
      ["modified.border"] = nil,
      predictive = nil,
      ["predictive.background"] = nil,
      ["predictive.border"] = nil,
      renamed = "#ad5c7c",
      ["renamed.background"] = nil,
      ["renamed.border"] = nil,
      success = nil,
      ["success.background"] = nil,
      ["success.border"] = nil,
      unreachable = nil,
      ["unreachable.background"] = nil,
      ["unreachable.border"] = nil,
      warning = "#fda47f",
      ["warning.background"] = nil,
      ["warning.border"] = "#ffffff",
      players = {
        {
          cursor = "#7aa4a1ff",
          background = "#7aa4a1ff",
          selection = "#7aa4a13d",
        },
      },
      syntax = {
        boolean = {
          color = "#ff8349",
          font_style = nil,
          font_weight = nil,
        },
        comment = {
          color = "#6d7f8b",
          font_style = nil,
          font_weight = nil,
        },
        ["comment.doc"] = {
          color = "#6d7f8b",
          font_style = nil,
          font_weight = nil,
        },
        constant = {
          color = "#fda47f",
          font_style = nil,
          font_weight = nil,
        },
        constructor = {
          color = "#934e69",
          font_style = nil,
          font_weight = nil,
        },
        ["function"] = {
          color = "#73a3b7",
          font_style = nil,
          font_weight = nil,
        },
        keyword = {
          color = "#ad5c7c",
          font_style = nil,
          font_weight = nil,
        },
        number = {
          color = "#ff8349",
          font_style = nil,
          font_weight = nil,
        },
        operator = {
          color = "#cbd9d8",
          font_style = nil,
          font_weight = nil,
        },
        preproc = {
          color = "#d38d97",
          font_style = nil,
          font_weight = nil,
        },
        property = {
          color = "#5a93aa",
          font_style = nil,
          font_weight = nil,
        },
        punctuation = {
          color = "#cbd9d8",
          font_style = nil,
          font_weight = nil,
        },
        ["punctuation.bracket"] = {
          color = "#cbd9d8",
          font_style = nil,
          font_weight = nil,
        },
        ["punctuation.delimiter"] = {
          color = "#cbd9d8",
          font_style = nil,
          font_weight = nil,
        },
        ["punctuation.list_marker"] = {
          color = "#cbd9d8",
          font_style = nil,
          font_weight = nil,
        },
        ["punctuation.special"] = {
          color = "#cbd9d8",
          font_style = nil,
          font_weight = nil,
        },
        string = {
          color = "#7aa4a1",
          font_style = nil,
          font_weight = nil,
        },
        ["string.escape"] = {
          color = "#7aa4a1",
          font_style = nil,
          font_weight = nil,
        },
        ["string.regex"] = {
          color = "#fdb292",
          font_style = nil,
          font_weight = nil,
        },
        ["string.special"] = {
          color = "#7aa4a1",
          font_style = nil,
          font_weight = nil,
        },
        ["string.special.symbol"] = {
          color = "#7aa4a1",
          font_style = nil,
          font_weight = nil,
        },
        tag = {
          color = "#b97490",
          font_style = nil,
          font_weight = nil,
        },
        ["text.literal"] = {
          color = "#7aa4a1",
          font_style = nil,
          font_weight = nil,
        },
        type = {
          color = "#fda47f",
          font_style = nil,
          font_weight = nil,
        },
        variable = {
          color = "#a1cdd8",
          font_style = nil,
          font_weight = nil,
        },
        ["variable.special"] = {
          color = "#73a3b7",
          font_style = nil,
          font_weight = nil,
        },
      },
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
