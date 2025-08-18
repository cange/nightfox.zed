---@alias nightfox_nvim.BackgroundAppearance "opaque" | "blurred" | "transparent" Enables blurred mode incl. alpha colors

local util = require("lib.util")
local logger = util.logger()
---@class nightfox_zed.Theme
---@field private _ns string Namespace
local M = {}
M._ns = ""
M._alphas = {}

---@type nil -- Marks a nil property as already defined
local AS_NONE = nil

---@param pal nightfox_nvim.Palette
---@param alpha_value number
---@return string[]
function M._accent_colors(pal, alpha_value)
  local alpha = util.color.alpha

  return {
    alpha(pal.blue.bright, alpha_value),
    alpha(pal.orange.bright, alpha_value),
    alpha(pal.magenta.bright, alpha_value),
    alpha(pal.cyan.bright, alpha_value),
    alpha(pal.red.bright, alpha_value),
    alpha(pal.green.bright, alpha_value),
    alpha(pal.yellow.bright, alpha_value),
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
  local alpha = util.color.alpha

  return {
    {
      cursor = spec.fg0,
      background = alpha(spec.bg3, M._alphas.LOW),
      selection = alpha(spec.sel1, M._alphas.HIGH),
    },
  }
end

---@param pal nightfox_nvim.Palette
---@param spec nightfox_nvim.Spec
---@param background_appearance nightfox_nvim.BackgroundAppearance
---@return table
-- see https://github.com/zed-industries/zed/blob/main/crates/theme/src/styles/colors.rs
-- see https://github.com/zed-industries/zed/blob/main/crates/theme/src/fallback_themes.rs
function M._theme_colors(pal, spec, background_appearance)
  local alpha = util.color.alpha
  local blend = util.color.blend

  local editor_bg = pal.bg1
  local accent = pal.orange

  return {
    border = alpha(spec.bg2, M._alphas.HIGH),
    ["border.variant"] = spec.bg4,
    ["border.focused"] = spec.sel0,
    ["border.selected"] = spec.sel1,
    ["border.transparent"] = alpha(spec.bg1, M._alphas.POLARIZED),
    ["border.disabled"] = spec.bg1,

    ["elevated_surface.background"] = spec.bg0, -- usage: UI popout bg
    ["surface.background"] = alpha(spec.bg0, M._alphas.MAX),
    background = alpha(spec.bg1, M._alphas.MAX),
    ["background.appearance"] = background_appearance,

    ["element.background"] = blend(editor_bg, accent.dim, 0.2),
    ["element.hover"] = blend(editor_bg, accent.base, 0.2),
    ["element.active"] = blend(editor_bg, accent.bright, 0.2),
    ["element.selected"] = blend(editor_bg, accent.bright, 0.2),
    ["element.disabled"] = spec.sel0,

    ["drop_target.background"] = alpha(spec.bg0, M._alphas.MAX),

    ["ghost_element.background"] = AS_NONE,
    ["ghost_element.hover"] = alpha(spec.sel1, M._alphas.LOW),
    ["ghost_element.active"] = alpha(spec.sel1, M._alphas.MAX), -- usage: UI popout trigger
    ["ghost_element.selected"] = alpha(spec.sel1, M._alphas.HIGH), -- usage: UI popout item
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
    ["debugger.accent"] = accent.base,

    -- UI Elements
    ["search.match_background"] = alpha(spec.sel1, M._alphas.MAX),
    ["status_bar.background"] = alpha(spec.bg0, M._alphas.MAX),
    ["tab.active_background"] = alpha(spec.sel0, M._alphas.MID),
    ["tab.inactive_background"] = alpha(spec.bg1, M._alphas.MID),
    ["tab_bar.background"] = alpha(spec.bg1, M._alphas.MID),
    ["title_bar.background"] = alpha(spec.bg0, M._alphas.MAX),
    ["title_bar.inactive_background"] = AS_NONE,
    ["toolbar.background"] = alpha(spec.sel0, M._alphas.MID),
    ["panel.background"] = alpha(spec.bg0, M._alphas.LOW),
    ["panel.focused_border"] = alpha(spec.sel1, M._alphas.MAX),
    ["panel.indent_guide"] = AS_NONE,
    ["panel.indent_guide_active"] = AS_NONE,
    ["panel.indent_guide_hover"] = AS_NONE,

    -- The overlay surface on top of panel.
    ["panel.overlay_background"] = alpha(spec.bg0, M._alphas.MAX),
    -- The overlay surface on top of panel when hovered over.
    ["panel.overlay_hover"] = AS_NONE,

    ["pane.focused_border"] = AS_NONE,
    ["pane.group_border"] = AS_NONE,
    -- The scrollbar thumb.
    ["scrollbar.thumb.background"] = alpha(spec.sel0, M._alphas.HIGH),
    -- The scrollbar thumb when hovered over.
    ["scrollbar.thumb.hover_background"] = alpha(spec.sel1, M._alphas.MAX),
    -- The scrollbar thumb whilst being actively dragged.
    ["scrollbar.thumb.active_background"] = alpha(accent.base, M._alphas.HIGH),
    -- The border color of the scrollbar thumb.
    ["scrollbar.thumb.border"] = AS_NONE,
    -- The background color of the scrollbar track.
    ["scrollbar.track.background"] = alpha(spec.sel0, M._alphas.LOW),
    -- The border color of the scrollbar track.
    ["scrollbar.track.border"] = AS_NONE,
    -- The minimap thumb.
    ["minimap.thumb.background"] = alpha(spec.sel0, M._alphas.HIGH),
    -- The minimap thumb when hovered over.
    ["minimap.thumb.hover_background"] = alpha(spec.sel1, M._alphas.MAX),
    -- The minimap thumb whilst being actively dragged.
    ["minimap.thumb.active_background"] = alpha(accent.base, M._alphas.MID),
    -- The border color of the minimap thumb.
    ["minimap.thumb.border"] = AS_NONE,

    -- Editor
    ["editor.foreground"] = spec.fg1,
    ["editor.background"] = alpha(editor_bg, M._alphas.POLARIZED),
    ["editor.gutter.background"] = alpha(spec.bg1, M._alphas.POLARIZED),
    ["editor.subheader.background"] = AS_NONE,
    ["editor.active_line.background"] = alpha(spec.sel0, M._alphas.LOW),
    ["editor.highlighted_line.background"] = AS_NONE,
    ["editor.line_number"] = spec.fg3,
    ["editor.active_line_number"] = pal.yellow.base,
    ["editor.invisible"] = AS_NONE,
    ["editor.wrap_guide"] = alpha(spec.bg2, M._alphas.MID),
    ["editor.active_wrap_guide"] = alpha(spec.bg2, M._alphas.MAX),
    ["editor.indent_guide"] = alpha(spec.bg2, M._alphas.MAX),
    ["editor.indent_guide_active"] = alpha(spec.sel1, M._alphas.MAX),
    ["editor.document_highlight.bracket_background"] = alpha(spec.sel0, M._alphas.MAX),
    ["editor.document_highlight.read_background"] = AS_NONE,
    ["editor.document_highlight.write_background"] = AS_NONE,

    -- Terminal
    ["terminal.background"] = alpha(spec.bg1, M._alphas.POLARIZED),
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

---@param appearance nightfox_nvim.BackgroundAppearance
function M._set_alpha_levels(appearance)
  local is_opaque = appearance == "opaque"
  local is_blurred = appearance == "blurred"

  M._alphas = { ---@diagnostic disable-line: unused-local
    MIN = is_opaque and 0.2 or is_blurred and 0.025 or 0.1,
    LOW = is_opaque and 0.3 or is_blurred and 0.05 or 0.15,
    MID = is_opaque and 0.5 or is_blurred and 0.15 or 0.25,
    HIGH = is_opaque and 0.8 or 0.4,
    MAX = is_opaque and 1 or 0.8,
    POLARIZED = is_opaque and 1 or 0, -- transparent in non-opaque case
  }
end

---Maps values of nightfox.nvim to zed's theme properties
---@param name "Nightfox" | "Dayfox" | "Dawnfox" | "Duskfox" | "Nordfox" | "Terafox" | "Carbonfox"
---@param background_appearance nightfox_nvim.BackgroundAppearance
---@return table
function M._define_theme(name, background_appearance)
  local theme_name = string.lower(name)
  local pal = require("nightfox.palette").load(theme_name)
  local spec = require("nightfox.spec").load(theme_name)
  local theme_appearance = pal.meta.light and "light" or "dark"
  local appearance_label = " - " .. background_appearance
  local dev_label = os.getenv("DEV_MODE") ~= nil and " (dev)" or ""
  local display_name = name .. appearance_label .. dev_label

  logger.ok("Theme defined", { display_name, theme_appearance })
  M._set_alpha_levels(background_appearance)

  return {
    name = display_name,
    appearance = theme_appearance,
    style = util.tbl_merge({
      accents = M._accent_colors(pal, M._alphas.MID),
      players = M._player_colors(spec),
      syntax = M._syntax_theme(pal, spec), -- https://github.com/zed-industries/zed/blob/main/crates/theme/src/one_themes.rs#L191
    }, M._status_colors(spec), M._theme_colors(pal, spec, background_appearance)),
  }
end

---@param namespace string
---@param metadata nightfox_zed.Metadata
---@return table
function M.generate(metadata, namespace)
  util.neovim_polyfill()
  M._ns = namespace
  logger.start("Generating themes")

  return {
    ["$schema"] = "https://zed.dev/schema/themes/v0.2.0.json",
    author = metadata.authors[1],
    name = metadata.name,
    themes = {
      M._define_theme("Nightfox", "opaque"),
      M._define_theme("Dayfox", "opaque"),
      M._define_theme("Dawnfox", "opaque"),
      M._define_theme("Duskfox", "opaque"),
      M._define_theme("Nordfox", "opaque"),
      M._define_theme("Terafox", "opaque"),
      M._define_theme("Carbonfox", "opaque"),
      --
      M._define_theme("Nightfox", "blurred"),
      M._define_theme("Dayfox", "blurred"),
      M._define_theme("Dawnfox", "blurred"),
      M._define_theme("Duskfox", "blurred"),
      M._define_theme("Nordfox", "blurred"),
      M._define_theme("Terafox", "blurred"),
      M._define_theme("Carbonfox", "blurred"),
    },
  }
end

return M
