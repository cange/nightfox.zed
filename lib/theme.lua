local util = require("lib.util")
---@class nightfox_zed.Theme
---@field private _ns string Namespace
local M = {}
M._ns = ""

---@type nil -- Marks a nil property as already defined
local AS_NONE = nil

---@param pal nightfox_nvim.Palette
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

---@param spec nightfox_nvim.Spec
---@return table
function M._status_colors(spec)
  return {
    conflict = spec.git.conflict,
    ["conflict.background"] = AS_NONE,
    ["conflict.border"] = AS_NONE,
    created = spec.git.add,
    ["created.background"] = AS_NONE,
    ["created.border"] = AS_NONE,
    deleted = spec.diff.delete,
    ["deleted.background"] = AS_NONE,
    ["deleted.border"] = AS_NONE,
    error = spec.diag.error,
    ["error.background"] = spec.diag_bg.error,
    ["error.border"] = AS_NONE,
    hidden = spec.fg3,
    ["hidden.background"] = AS_NONE,
    ["hidden.border"] = AS_NONE,
    hint = spec.syntax.comment,
    ["hint.background"] = spec.diag_bg.hint,
    ["hint.border"] = AS_NONE,
    ignored = spec.git.ignored,
    ["ignored.background"] = AS_NONE,
    ["ignored.border"] = AS_NONE,
    info = spec.diag.info,
    ["info.background"] = spec.diag_bg.info,
    ["info.border"] = AS_NONE,
    modified = spec.git.changed,
    ["modified.background"] = AS_NONE,
    ["modified.border"] = AS_NONE,
    predictive = spec.fg3,
    ["predictive.background"] = AS_NONE,
    ["predictive.border"] = AS_NONE,
    renamed = spec.git.changed,
    ["renamed.background"] = AS_NONE,
    ["renamed.border"] = AS_NONE,
    success = spec.diag.ok,
    ["success.background"] = spec.diag_bg.ok,
    ["success.border"] = AS_NONE,
    unreachable = AS_NONE,
    ["unreachable.background"] = AS_NONE,
    ["unreachable.border"] = AS_NONE,
    warning = spec.diag.warn,
    ["warning.background"] = spec.diag_bg.warn,
    ["warning.border"] = AS_NONE,
  }
end

---@param spec nightfox_nvim.Spec
---@return nightfox_zed.PlayerColor[]
function M._player_colors(spec)
  return {
    {
      cursor = spec.fg0,
      background = spec.bg3,
      selection = util.color.alpha(spec.sel0, 0.5),
    },
  }
end

---@param pal nightfox_nvim.Palette
---@param spec nightfox_nvim.Spec
---@return table
---See: https://github.com/zed-industries/zed/blob/main/crates/theme/src/styles/colors.rs
---See: https://github.com/zed-industries/zed/blob/main/crates/theme/src/fallback_themes.rs
function M._theme_colors(pal, spec)
  local editor_bg = pal.bg1
  local accent = pal.orange

  return {
    accents = M._accent_colors(pal),

    border = spec.bg2,
    ["border.variant"] = spec.bg4,
    ["border.focused"] = spec.sel0,
    ["border.selected"] = spec.sel1,
    ["border.transparent"] = spec.bg1,
    ["border.disabled"] = spec.bg1,

    ["elevated_surface.background"] = spec.sel0, -- usage: UI popout bg
    ["surface.background"] = spec.bg0,
    background = spec.sel0,

    ["element.background"] = util.color.blend(editor_bg, accent.dim, 0.2),
    ["element.hover"] = util.color.blend(editor_bg, accent.base, 0.2),
    ["element.active"] = util.color.blend(editor_bg, accent.bright, 0.2),
    ["element.selected"] = util.color.blend(editor_bg, accent.bright, 0.2),
    ["element.disabled"] = spec.sel0,

    ["drop_target.background"] = spec.bg0,

    ["ghost_element.background"] = AS_NONE,
    ["ghost_element.hover"] = util.color.alpha(spec.sel1, 0.25),
    ["ghost_element.active"] = spec.sel1, -- usage: UI popout trigger
    ["ghost_element.selected"] = util.color.alpha(spec.sel1, 0.75), -- usage: UI popout item
    ["ghost_element.disabled"] = AS_NONE,

    text = spec.fg0,
    ["text.muted"] = spec.fg1,
    ["text.placeholder"] = spec.fg3,
    ["text.disabled"] = spec.syntax.comment,
    ["text.accent"] = accent.dim,

    icon = AS_NONE,
    ["icon.muted"] = AS_NONE,
    ["icon.disabled"] = AS_NONE,
    ["icon.placeholder"] = AS_NONE,
    ["icon.accent"] = AS_NONE,

    -- UI Elements
    ["status_bar.background"] = spec.bg0,
    ["title_bar.inactive_background"] = AS_NONE,
    ["title_bar.background"] = spec.bg0,
    ["toolbar.background"] = spec.bg1,
    ["tab_bar.background"] = spec.bg0,
    ["tab.inactive_background"] = spec.bg0,
    ["tab.active_background"] = spec.bg1,
    ["search.match_background"] = spec.sel1,
    ["panel.background"] = spec.bg0,
    ["panel.focused_border"] = spec.sel1,
    ["panel.indent_guide"] = AS_NONE,
    ["panel.indent_guide_active"] = AS_NONE,
    ["panel.indent_guide_hover"] = AS_NONE,
    ["pane.focused_border"] = AS_NONE,
    ["pane.group_border"] = AS_NONE,
    ["scrollbar.thumb.background"] = util.color.alpha(spec.sel1, 0.75),
    ["scrollbar.thumb.hover_background"] = spec.sel1,
    ["scrollbar.thumb.border"] = AS_NONE,
    ["scrollbar.track.background"] = util.color.alpha(spec.sel0, 0.25),
    ["scrollbar.track.border"] = AS_NONE,

    -- Editor
    ["editor.foreground"] = spec.fg1,
    ["editor.background"] = editor_bg,
    ["editor.gutter.background"] = spec.bg1,
    ["editor.subheader.background"] = AS_NONE,
    ["editor.active_line.background"] = spec.bg2,
    ["editor.highlighted_line.background"] = AS_NONE,
    ["editor.line_number"] = spec.fg3,
    ["editor.active_line_number"] = pal.yellow.base,
    ["editor.invisible"] = AS_NONE,
    ["editor.wrap_guide"] = spec.bg2,
    ["editor.active_wrap_guide"] = spec.bg2,
    ["editor.indent_guide"] = spec.bg2,
    ["editor.indent_guide_active"] = spec.sel1,
    ["editor.document_highlight.bracket_background"] = spec.sel0,
    ["editor.document_highlight.read_background"] = AS_NONE,
    ["editor.document_highlight.write_background"] = AS_NONE,

    -- Terminal
    ["terminal.background"] = spec.bg1,
    ["terminal.foreground"] = spec.fg1,
    ["terminal.bright_foreground"] = spec.fg0,
    ["terminal.dim_foreground"] = spec.fg2,
    ["terminal.ansi.background"] = AS_NONE,
    ["terminal.ansi.black"] = pal.black.base,
    ["terminal.ansi.bright_black"] = pal.black.bright,
    ["terminal.ansi.bright_red"] = pal.red.bright,
    ["terminal.ansi.bright_green"] = pal.green.bright,
    ["terminal.ansi.bright_yellow"] = pal.yellow.bright,
    ["terminal.ansi.bright_blue"] = pal.blue.bright,
    ["terminal.ansi.bright_magenta"] = pal.magenta.bright,
    ["terminal.ansi.bright_cyan"] = pal.cyan.bright,
    ["terminal.ansi.bright_white"] = pal.white.bright,
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

    ["version_control.added"] = spec.git.add,
    ["version_control.deleted"] = spec.git.removed,
    ["version_control.modified"] = spec.git.changed,
    ["version_control.renamed"] = spec.git.changed,
    ["version_control.conflict"] = spec.git.conflict,
    ["version_control.ignored"] = spec.git.ignored,
  }
end

---@param pal nightfox_nvim.Palette
---@param spec nightfox_nvim.Spec
---@return table<string, nightfox_zed.HighlightStyle>
---See: https://github.com/zed-industries/zed/blob/main/crates/theme/src/fallback_themes.rs
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
    ["punctuation.markup"] = {
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

---Maps values of nightfox.nvim to zed's theme properties
---@param name "Nightfox" | "Dayfox" | "Dawnfox" | "Duskfox" | "Nordfox" | "Terafox" | "Carbonfox"
---@return table
function M._define_theme(name)
  local theme = string.lower(name)
  ---@type nightfox_nvim.Palette
  local pal = require("nightfox.palette").load(theme)
  ---@type nightfox_nvim.Spec
  local spec = require("nightfox.spec").load(theme)
  local appearance = pal.meta.light and "light" or "dark"
  local display_name = name .. (os.getenv("DEV_MODE") ~= nil and " (dev)" or "")

  print(string.format("[%s] ✓ %q %s theme defined", M._ns, display_name, appearance))
  return {
    name = display_name,
    appearance = appearance,
    style = util.tbl_merge({
      accents = M._accent_colors(pal),
      players = M._player_colors(spec),
      syntax = M._syntax_theme(pal, spec), -- https://github.com/zed-industries/zed/blob/main/crates/theme/src/one_themes.rs#L191
    }, M._status_colors(spec), M._theme_colors(pal, spec)),
  }
end

---@param namespace string
---@param metadata nightfox_zed.Metadata
---@return table
function M.generate(metadata, namespace)
  util.neovim_polyfill()
  M._ns = namespace
  print(string.format("[%s] ⚙ Generating themes", M._ns))

  return {
    ["$schema"] = "https://zed.dev/schema/themes/v0.2.0.json",
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
