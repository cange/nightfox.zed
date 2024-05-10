---@class ZedTheme
---@field private _ns string Namespace
---@field private _neovim_polyfill function
---@field private _with_alpha function
local M = {}
M._ns = "" -- namespace

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
  local style = {
    border = spec.bg0,
    ["border.disabled"] = spec.bg1,
    ["border.focused"] = spec.sel0,
    ["border.selected"] = spec.sel1,
    ["border.transparent"] = spec.bg1,
    ["border.variant"] = spec.bg0,
    ["elevated_surface.background"] = spec.bg0,
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
    ["text.disabled"] = spec.syntax.comment,
    ["text.placeholder"] = spec.fg3,
    ["text.accent"] = spec.fg2,
    ["link_text.hover"] = pal.cyan.base,
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
    ["search.match_background"] = nil,
    ["panel.background"] = spec.bg0,
    ["panel.focused_border"] = nil,
    ["pane.focused_border"] = nil,
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
    ["editor.document_highlight.read_background"] = nil,
    ["editor.document_highlight.write_background"] = nil,

    ["terminal.background"] = spec.bg1,
    ["terminal.foreground"] = spec.fg1,
    ["terminal.bright_foreground"] = spec.fg0,
    ["terminal.dim_foreground"] = spec.fg2,
    ["terminal.ansi.black"] = pal.black.base,
    ["terminal.ansi.bright_black"] = pal.black.bright,
    ["terminal.ansi.dim_black"] = pal.black.dim,
    ["terminal.ansi.red"] = pal.red.base,
    ["terminal.ansi.bright_red"] = pal.red.bright,
    ["terminal.ansi.dim_red"] = pal.red.dim,
    ["terminal.ansi.green"] = pal.green.base,
    ["terminal.ansi.bright_green"] = pal.green.bright,
    ["terminal.ansi.dim_green"] = pal.green.dim,
    ["terminal.ansi.yellow"] = pal.yellow.base,
    ["terminal.ansi.bright_yellow"] = pal.yellow.bright,
    ["terminal.ansi.dim_yellow"] = pal.yellow.dim,
    ["terminal.ansi.blue"] = pal.blue.base,
    ["terminal.ansi.bright_blue"] = pal.blue.bright,
    ["terminal.ansi.dim_blue"] = pal.blue.dim,
    ["terminal.ansi.magenta"] = pal.magenta.base,
    ["terminal.ansi.bright_magenta"] = pal.magenta.bright,
    ["terminal.ansi.dim_magenta"] = pal.magenta.dim,
    ["terminal.ansi.cyan"] = pal.cyan.base,
    ["terminal.ansi.bright_cyan"] = pal.cyan.bright,
    ["terminal.ansi.dim_cyan"] = pal.cyan.dim,
    ["terminal.ansi.white"] = pal.white.base,
    ["terminal.ansi.bright_white"] = pal.white.bright,
    ["terminal.ansi.dim_white"] = pal.white.dim,

    hidden = spec.fg3,
    ["hidden.background"] = nil,
    ["hidden.border"] = nil,
    predictive = spec.fg3,
    ["predictive.background"] = nil,
    ["predictive.border"] = nil,
    unreachable = nil,
    ["unreachable.background"] = nil,
    ["unreachable.border"] = nil,
    -- diagnostics
    error = spec.diag.error,
    ["error.background"] = spec.diag_bg.error,
    ["error.border"] = nil,
    hint = spec.syntax.comment, -- also used for git inline blame
    ["hint.background"] = spec.diag_bg.hint,
    ["hint.border"] = nil,
    info = spec.diag.info,
    ["info.background"] = spec.diag_bg.info,
    ["info.border"] = nil,
    success = spec.diag.ok,
    ["success.background"] = spec.diag_bg.ok,
    ["success.border"] = nil,
    warning = spec.diag.warn,
    ["warning.background"] = spec.diag_bg.warn,
    ["warning.border"] = nil,
    -- diff
    add = spec.diff.add,
    ["add.background"] = nil,
    ["add.border"] = nil,
    deleted = spec.diff.delete,
    ["deleted.background"] = nil,
    ["deleted.border"] = nil,
    -- git
    renamed = spec.git.changed,
    ["renamed.background"] = nil,
    ["renamed.border"] = nil,
    modified = spec.git.changed,
    ["modified.background"] = nil,
    ["modified.border"] = nil,
    conflict = spec.git.conflict,
    ["conflict.background"] = nil,
    ["conflict.border"] = nil,
    ignored = spec.git.ignored,
    ["ignored.background"] = nil,
    ["ignored.border"] = nil,
    created = spec.git.add,
    ["created.background"] = nil,
    ["created.border"] = nil,
    players = {
      {
        cursor = pal.green.base,
        background = pal.green.base,
        selection = M._with_alpha(pal.green.base, 0.24),
      },
    },
    syntax = {
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
    },
  }
  local display_name = name .. (os.getenv("DEV_MODE") ~= nil and " (dev)" or "")

  print(string.format("[%s] ✓ %q %s theme defined", M._ns, display_name, appearance))
  return {
    name = display_name,
    appearance = appearance,
    style = style,
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

--#region Types

---@class PaletteMeta
---@field name string
---@field light boolean

---@class Shade
---@field base string
---@field bright string
---@field dim string
---@field light boolean

---@class Palette
---@field meta PaletteMeta
---@field black Shade
---@field red Shade
---@field green Shade
---@field yellow Shade
---@field blue Shade
---@field magenta Shade
---@field cyan Shade
---@field white Shade
---@field orange Shade
---@field pink Shade
---@field comment string
---@field bg0 string Dark bg (status line and float)
---@field bg1 string Default bg
---@field bg2 string Lighter bg (colorcolm folds)
---@field bg3 string Lighter bg (cursor line)
---@field bg4 string Conceal, border fg
---@field fg0 string Lighter fg
---@field fg1 string Default fg
---@field fg2 string Darker fg (status line)
---@field fg3 string Darker fg (line numbers, fold colums)
---@field sel0 string Popup bg, visual selection bg
---@field sel1 string Popup sel bg, search bg

---@class Spec
---@field bg0 string Dark bg (status line and float)
---@field bg1 string Default bg
---@field bg2 string Lighter bg (colorcolm folds)
---@field bg3 string Lighter bg (cursor line)
---@field bg4 string Conceal, border fg
---@field fg0 string Lighter fg
---@field fg1 string Default fg
---@field fg2 string Darker fg (status line)
---@field fg3 string Darker fg (line numbers, fold colums)
---@field sel0 string Popup bg, visual selection bg
---@field sel1 string Popup sel bg, search bg
---@field syntax SpecSyntax
---@field diag SpecDiagnostic
---@field diag_bg SpecDiagnosticBg
---@field diff SpecDiff
---@field git SpecGit

---@class SpecSyntax
---@field bracket string Brackets and Punctuation
---@field builtin0 string Builtin variable
---@field builtin1 string Builtin type
---@field builtin2 string Builtin const
---@field builtin3 string Not used
---@field comment string Comment
---@field conditional string Conditional and loop
---@field const string Constants, imports and booleans
---@field dep string Deprecated
---@field field string Field
---@field func string Functions and Titles
---@field ident string Identifiers
---@field keyword string Keywords
---@field number string Numbers
---@field operator string Operators
---@field preproc string PreProc
---@field regex string Regex
---@field statement string Statements
---@field string string Strings
---@field type string Types
---@field variable string Variables

---@class SpecDiagnostic
---@field error string
---@field warn string
---@field info string
---@field hint string
---@field ok string

---@class SpecDiagnosticBg
---@field error string
---@field warn string
---@field info string
---@field hint string
---@field ok string

---@class SpecDiff
---@field add string
---@field delete string
---@field change string
---@field text string

---@class SpecGit
---@field add string
---@field changed string
---@field conflict string
---@field ignored string
---@field removed string

--#endregion
