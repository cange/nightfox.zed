---@class ZedTheme
---@field private _ns string Namespace
---@field private _neovim_polyfill function
---@field private _with_alpha function
local M = {}
M._ns = ""

---Merge two or more tables into one.
---@param base table
---@param ... table
---@return table
M._tbl_merge = function(base, ...)
  local tables = { ... }
  for _, tbl in ipairs(tables) do
    for key, value in pairs(tbl) do
      base[key] = value
    end
  end
  return base
end

---@param pal Palette
---@return string[]
function M._accent_colors(pal)
  return {
    pal.blue.dim,
    pal.orange.dim,
    pal.magenta.dim,
    pal.cyan.dim,
    pal.red.dim,
    pal.green.dim,
    pal.yellow.dim,
  }
end

---@param spec Spec
---@return table
function M._status_colors(spec)
  return {
    conflict = spec.git.conflict,
    ["conflict.background"] = nil,
    ["conflict.border"] = nil,
    created = spec.git.add,
    ["created.background"] = nil,
    ["created.border"] = nil,
    deleted = spec.diff.delete,
    ["deleted.background"] = nil,
    ["deleted.border"] = nil,
    error = spec.diag.error,
    ["error.background"] = spec.diag_bg.error,
    ["error.border"] = nil,
    hidden = spec.fg3,
    ["hidden.background"] = nil,
    ["hidden.border"] = nil,
    hint = spec.syntax.comment,
    ["hint.background"] = spec.diag_bg.hint,
    ["hint.border"] = nil,
    ignored = spec.git.ignored,
    ["ignored.background"] = nil,
    ["ignored.border"] = nil,
    info = spec.diag.info,
    ["info.background"] = spec.diag_bg.info,
    ["info.border"] = nil,
    modified = spec.git.changed,
    ["modified.background"] = nil,
    ["modified.border"] = nil,
    predictive = spec.fg3,
    ["predictive.background"] = nil,
    ["predictive.border"] = nil,
    renamed = spec.git.changed,
    ["renamed.background"] = nil,
    ["renamed.border"] = nil,
    success = spec.diag.ok,
    ["success.background"] = spec.diag_bg.ok,
    ["success.border"] = nil,
    unreachable = nil,
    ["unreachable.background"] = nil,
    ["unreachable.border"] = nil,
    warning = spec.diag.warn,
    ["warning.background"] = spec.diag_bg.warn,
    ["warning.border"] = nil,
  }
end

---@param pal Palette
---@return ZedPlayerColor[]
function M._player_colors(pal)
  return {
    {
      cursor = pal.green.base,
      background = pal.green.base,
      selection = M._with_alpha(pal.green.base, 0.24),
    },
  }
end

---Represents [Zed::ThemeColors](https://github.com/zed-industries/zed/blob/v0.138.6/crates/theme/src/theme.rs) definition.
---@param pal Palette
---@param spec Spec
---@return table
function M._theme_colors(pal, spec)
  return {
    border = spec.bg0,
    ["border.variant"] = spec.bg0,
    ["border.focused"] = spec.sel0,
    ["border.selected"] = spec.sel1,
    ["border.transparent"] = spec.bg1,
    ["border.disabled"] = spec.bg1,
    ["elevated_surface.background"] = spec.bg0,
    ["surface.background"] = spec.bg0,
    background = spec.bg0,
    ["element.background"] = spec.sel0,
    ["element.hover"] = M._with_alpha(pal.orange.base, 0.3),
    ["element.active"] = M._with_alpha(pal.orange.base, 0.6),
    ["element.selected"] = M._with_alpha(pal.orange.base, 0.2),
    ["element.disabled"] = nil,
    ["drop_target.background"] = spec.bg0,
    ["ghost_element.background"] = nil,
    ["ghost_element.hover"] = M._with_alpha(spec.sel0, 0.4),
    ["ghost_element.active"] = M._with_alpha(pal.orange.base, 0.4),
    ["ghost_element.selected"] = spec.sel0,
    ["ghost_element.disabled"] = nil,
    text = spec.fg0,
    ["text.muted"] = spec.fg1,
    ["text.placeholder"] = spec.fg3,
    ["text.disabled"] = spec.syntax.comment,
    ["text.accent"] = spec.fg2,
    icon = "#ff0000",                 -- debug apparently not assigned yet
    ["icon.muted"] = "#00ff00",       -- debug apparently not assigned yet
    ["icon.disabled"] = "#0000ff",    -- debug apparently not assigned yet
    ["icon.placeholder"] = "#ffff00", -- debug apparently not assigned yet
    ["icon.accent"] = "#00ffff",      -- debug apparently not assigned yet
    ["status_bar.background"] = spec.bg0,
    ["title_bar.background"] = spec.bg0,
    ["toolbar.background"] = spec.bg1,
    ["tab_bar.background"] = spec.bg0,
    ["tab.inactive_background"] = spec.bg0,
    ["tab.active_background"] = spec.bg1,
    ["search.match_background"] = spec.sel1,
    ["panel.background"] = spec.bg0,
    ["panel.focused_border"] = nil,
    ["pane.focused_border"] = nil,
    ["pane.group_border"] = nil,
    ["scrollbar_thumb.background"] = pal.black.dim,
    ["scrollbar.thumb.hover_background"] = pal.black.bright,
    ["scrollbar.thumb.border"] = pal.black.dim,
    ["scrollbar.track.background"] = spec.bg1,
    ["scrollbar.track.border"] = spec.bg0,
    ["editor.foreground"] = spec.fg1,
    ["editor.background"] = spec.bg1,
    ["editor.gutter.background"] = spec.bg1,
    ["editor.subheader.background"] = nil,
    ["editor.active_line.background"] = spec.bg2,
    ["editor.highlighted_line.background"] = nil,
    ["editor.line_number"] = spec.fg3,
    ["editor.active_line_number"] = pal.yellow.base,
    ["editor.invisible"] = nil,
    ["editor.wrap_guide"] = spec.bg2,
    ["editor.active_wrap_guide"] = spec.bg2,
    ["editor.indent_guide"] = spec.bg2,
    ["editor.indent_guide_active"] = spec.sel1,
    ["editor.document_highlight.read_background"] = nil,
    ["editor.document_highlight.write_background"] = nil,
    ["terminal.background"] = spec.bg1,
    ["terminal.foreground"] = spec.fg1,
    ["terminal.bright_foreground"] = spec.fg0,
    ["terminal.dim_foreground"] = spec.fg2,
    ["terminal.ansi.bright_black"] = pal.black.bright,
    ["terminal.ansi.bright_red"] = pal.red.bright,
    ["terminal.ansi.bright_green"] = pal.green.bright,
    ["terminal.ansi.bright_yellow"] = pal.yellow.bright,
    ["terminal.ansi.bright_blue"] = pal.blue.bright,
    ["terminal.ansi.bright_magenta"] = pal.magenta.bright,
    ["terminal.ansi.bright_cyan"] = pal.cyan.bright,
    ["terminal.ansi.bright_white"] = pal.white.bright,
    ["terminal.ansi.black"] = pal.black.base,
    ["terminal.ansi.red"] = pal.red.base,
    ["terminal.ansi.green"] = pal.green.base,
    ["terminal.ansi.yellow"] = pal.yellow.base,
    ["terminal.ansi.blue"] = pal.blue.base,
    ["terminal.ansi.magenta"] = pal.magenta.base,
    ["terminal.ansi.cyan"] = pal.cyan.base,
    ["terminal.ansi.white"] = pal.white.base,
    ["terminal.ansi.dim_black"] = pal.black.dim,
    ["terminal.ansi.dim_red"] = pal.red.dim,
    ["terminal.ansi.dim_green"] = pal.green.dim,
    ["terminal.ansi.dim_yellow"] = pal.yellow.dim,
    ["terminal.ansi.dim_blue"] = pal.blue.dim,
    ["terminal.ansi.dim_magenta"] = pal.magenta.dim,
    ["terminal.ansi.dim_cyan"] = pal.cyan.dim,
    ["terminal.ansi.dim_white"] = pal.white.dim,
    ["link_text.hover"] = pal.cyan.base,
  }
end

---@param pal Palette
---@param spec Spec
---@return table<string, ZedHighlightStyle>
function M._syntax_theme(pal, spec)
  return {
    boolean = {
      color = spec.syntax.const,
      font_style = nil,
      font_weight = nil,
    },
    comment = {
      color = spec.syntax.comment,
      font_style = nil,
      font_weight = nil,
    },
    ["comment.doc"] = {
      color = spec.syntax.comment,
      font_style = nil,
      font_weight = nil,
    },
    constant = {
      color = spec.syntax.const,
      font_style = nil,
      font_weight = nil,
    },
    constructor = {
      color = spec.syntax.builtin2,
      font_style = nil,
      font_weight = nil,
    },
    ["function"] = {
      color = spec.syntax.func,
      font_style = nil,
      font_weight = nil,
    },
    keyword = {
      color = spec.syntax.keyword,
      font_style = nil,
      font_weight = nil,
    },
    number = {
      color = spec.syntax.number,
      font_style = nil,
      font_weight = nil,
    },
    operator = {
      color = spec.syntax.operator,
      font_style = nil,
      font_weight = nil,
    },
    preproc = {
      color = spec.syntax.preproc,
      font_style = nil,
      font_weight = nil,
    },
    property = {
      color = pal.blue.base,
      font_style = nil,
      font_weight = nil,
    },
    punctuation = {
      color = spec.syntax.bracket,
      font_style = nil,
      font_weight = nil,
    },
    ["punctuation.bracket"] = {
      color = spec.syntax.bracket,
      font_style = nil,
      font_weight = nil,
    },
    ["punctuation.delimiter"] = {
      color = spec.syntax.bracket,
      font_style = nil,
      font_weight = nil,
    },
    ["punctuation.list_marker"] = {
      color = spec.syntax.bracket,
      font_style = nil,
      font_weight = nil,
    },
    ["punctuation.special"] = {
      color = spec.syntax.bracket,
      font_style = nil,
      font_weight = nil,
    },
    string = {
      color = spec.syntax.string,
      font_style = nil,
      font_weight = nil,
    },
    ["string.escape"] = {
      color = pal.green.base,
      font_style = nil,
      font_weight = nil,
    },
    ["string.regex"] = {
      color = spec.syntax.regex,
      font_style = nil,
      font_weight = nil,
    },
    ["string.special"] = {
      color = spec.syntax.builtin1,
      font_style = nil,
      font_weight = nil,
    },
    ["string.special.symbol"] = {
      color = spec.syntax.builtin0,
      font_style = nil,
      font_weight = nil,
    },
    tag = {
      color = pal.magenta.dim,
      font_style = nil,
      font_weight = nil,
    },
    ["text.literal"] = {
      color = pal.green.base,
      font_style = nil,
      font_weight = nil,
    },
    type = {
      color = spec.syntax.type,
      font_style = nil,
      font_weight = nil,
    },
    variable = {
      color = pal.cyan.base,
      font_style = nil,
      font_weight = nil,
    },
    ["variable.special"] = {
      color = spec.syntax.builtin0,
      font_style = nil,
      font_weight = nil,
    },
  }
end

---Maps values of nightfox.vim to zed's theme properties
---@param name "Nightfox" | "Dayfox" | "Dawnfox" | "Duskfox" | "Nordfox" | "Terafox" | "Carbonfox"
---@return table
function M._define_theme(name)
  M._neovim_polyfill()
  local theme = name:lower()
  ---@type Palette
  local pal = require("nightfox.palette").load(theme)
  ---@type Spec
  local spec = require("nightfox.spec").load(theme)
  local appearance = pal.meta.light and "light" or "dark"
  local display_name = name .. (os.getenv("DEV_MODE") ~= nil and " (dev)" or "")

  print(string.format("[%s] ✓ %q %s theme defined", M._ns, display_name, appearance))
  return {
    name = display_name,
    appearance = appearance,
    style = M._tbl_merge({
      accents = M._accent_colors(pal),
      players = M._player_colors(pal),
      syntax = M._syntax_theme(pal, spec), -- https://github.com/zed-industries/zed/blob/main/crates/theme/src/one_themes.rs#L191
    }, M._status_colors(spec), M._theme_colors(pal, spec)),
  }
end

---Mocks Neovim's API since some endpoints are required by nightfox.nvim
function M._neovim_polyfill()
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

---Provides a color in hexadecimal format with an alpha channel
---@param hex_color string
---@param percent number Alpha channel number between 0 and 1
---@return string Hexadecimal color with alpha channel
function M._with_alpha(hex_color, percent)
  if percent < 0 or percent > 1 then
    error(string.format("[%s] Invalid value! Expected: between 0 and 1. Received: %s", M._ns, percent))
  end
  local alpha_value = math.floor(percent * 255)
  return hex_color .. string.format("%02X", alpha_value)
end

---@param namespace string
---@param metadata Metadata
---@return table
function M.generate(metadata, namespace)
  M._neovim_polyfill()
  M._ns = namespace
  print(string.format("[%s] ⚙ Generating themes", M._ns))

  return {
    ["$schema"] = "https://zed.dev/schema/themes/v0.1.0.json",
    author = metadata.authors[1],
    name = metadata.name,
    themes = {
      M._define_theme("Nightfox"),
      M._define_theme("Dayfox"),
      M._define_theme("Dawnfox"),
      M._define_theme("Duskfox"),
      M._define_theme("Nordfox"),
      M._define_theme("Terafox"),
      M._define_theme("Carbonfox"),
    },
  }
end

return M
