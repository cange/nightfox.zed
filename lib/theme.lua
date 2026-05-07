---@alias nightfox_nvim.BackgroundAppearance "opaque" | "blurred" | "transparent" Enables blurred mode incl. alpha colors

local util = require("lib.util")
local logger = util.logger()
---@class nightfox_zed.Theme
---@field private _ns string Namespace
local M = {}
M._ns = ""
---@type nightfox_nvim.AlphaLevels | nil
M._alphas = nil

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
    hint = spec.syntax.comment,
    ["hint.background"] = spec.diag_bg.hint,
    ["hint.border"] = AS_NONE,
    info = spec.diag.info,
    ["info.background"] = spec.diag_bg.info,
    ["info.border"] = AS_NONE,
    success = spec.diag.ok,
    ["success.background"] = spec.diag_bg.ok,
    ["success.border"] = AS_NONE,
    warning = spec.diag.warn,
    ["warning.background"] = spec.diag_bg.warn,
    ["warning.border"] = AS_NONE,
    error = spec.diag.error,
    ["error.background"] = spec.diag_bg.error,
    ["error.border"] = AS_NONE,
    created = spec.git.add,
    ["created.background"] = AS_NONE,
    ["created.border"] = AS_NONE,
    modified = spec.git.changed,
    ["modified.background"] = AS_NONE,
    ["modified.border"] = AS_NONE,
    deleted = spec.git.removed,
    ["deleted.background"] = AS_NONE,
    ["deleted.border"] = AS_NONE,
    conflict = spec.git.conflict,
    ["conflict.background"] = AS_NONE,
    ["conflict.border"] = AS_NONE,
    renamed = spec.git.changed,
    ["renamed.background"] = AS_NONE,
    ["renamed.border"] = AS_NONE,
    hidden = spec.fg3,
    ["hidden.background"] = AS_NONE,
    ["hidden.border"] = AS_NONE,
    ignored = spec.git.ignored,
    ["ignored.background"] = AS_NONE,
    ["ignored.border"] = AS_NONE,
    predictive = spec.fg3,
    ["predictive.background"] = AS_NONE,
    ["predictive.border"] = AS_NONE,
    unreachable = AS_NONE,
    ["unreachable.background"] = AS_NONE,
    ["unreachable.border"] = AS_NONE,
  }
end

---@param pal nightfox_nvim.Palette
---@return nightfox_zed.PlayerColor[]
function M._player_colors(pal)
  local alpha = util.color.alpha
  local players = {}
  local colors = { "green", "cyan", "blue", "orange", "yellow", "pink", "magenta", "red" }
  for _, name in ipairs(colors) do
    local color = pal[name]
    table.insert(players, {
      cursor = color.base,
      background = alpha(color.base, M._alphas.HIGH),
      selection = alpha(color.base, M._alphas.LOW),
    })
  end

  return players
end

---@param pal nightfox_nvim.Palette
---@param spec nightfox_nvim.Spec
---@param background_appearance nightfox_nvim.BackgroundAppearance
---@return table
-- see https://github.com/zed-industries/zed/blob/main/crates/theme/src/styles/colors.rs
-- see https://github.com/zed-industries/zed/blob/main/crates/theme/src/fallback_themes.rs
function M._theme_colors(pal, spec, background_appearance)
  local alpha = util.color.alpha
  local editor_bg = pal.bg1
  local function fade(color, amount)
    amount = amount or 0.3
    return util.color.blend(editor_bg, color, amount)
  end
  local todo = util.color.debug
  local accent = pal.orange

  return {
    -- Surface
    background = alpha(spec.bg1, M._alphas.MAX),
    ["surface.background"] = alpha(spec.bg0, M._alphas.MAX),
    ["elevated_surface.background"] = spec.bg0, -- usage: UI popout bg
    ["panel.background"] = alpha(spec.bg0, M._alphas.MAX_POLARIZE),
    ["panel.focused_border"] = alpha(spec.sel1, M._alphas.MAX),
    ["panel.indent_guide"] = AS_NONE,
    ["panel.indent_guide_active"] = AS_NONE,
    ["panel.indent_guide_hover"] = AS_NONE,
    ["panel.overlay_background"] = alpha(spec.bg0, M._alphas.MAX), -- The overlay surface on top of panel.
    ["panel.overlay_hover"] = AS_NONE, -- The overlay surface on top of panel when hovered over.
    ["pane.focused_border"] = AS_NONE,
    -- Border
    border = alpha(spec.bg2, M._alphas.HIGH),
    ["border.variant"] = spec.bg4,
    ["border.focused"] = spec.sel0,
    ["border.selected"] = spec.sel1,
    ["border.transparent"] = alpha(spec.bg1, M._alphas.MAX_POLARIZE),
    ["border.disabled"] = spec.bg1,
    -- Text
    text = spec.fg0,
    ["text.muted"] = spec.fg1,
    ["text.placeholder"] = spec.fg3,
    ["text.disabled"] = spec.syntax.comment,
    ["text.accent"] = accent.dim,
    ["link_text.hover"] = pal.cyan.base,
    -- Icon
    icon = AS_NONE,
    ["icon.muted"] = AS_NONE,
    ["icon.disabled"] = AS_NONE,
    ["icon.accent"] = AS_NONE,
    -- Editor
    ["editor.foreground"] = spec.fg1,
    ["editor.background"] = alpha(editor_bg, M._alphas.MAX_POLARIZE),
    ["editor.gutter.background"] = alpha(spec.bg1, M._alphas.MAX_POLARIZE),
    ["editor.active_line.background"] = alpha(spec.sel0, M._alphas.LOW),
    ["editor.highlighted_line.background"] = AS_NONE,
    ["editor.debugger_active_line.background"] = todo.red,
    ["editor.subheader.background"] = AS_NONE,
    ["editor.active_line_number"] = pal.yellow.base,
    ["editor.line_number"] = spec.fg3,
    ["editor.hover_line_number"] = todo.green,
    ["editor.invisible"] = AS_NONE,
    ["editor.wrap_guide"] = alpha(spec.bg2, M._alphas.MID),
    ["editor.active_wrap_guide"] = alpha(spec.bg2, M._alphas.MAX),
    ["editor.indent_guide"] = alpha(spec.bg2, M._alphas.MAX),
    ["editor.indent_guide_active"] = alpha(spec.sel1, M._alphas.MAX),
    ["editor.document_highlight.read_background"] = AS_NONE,
    ["editor.document_highlight.write_background"] = AS_NONE,
    ["editor.document_highlight.bracket_background"] = alpha(spec.sel0, M._alphas.MAX),
    ["search.match_background"] = alpha(spec.sel1, M._alphas.MIN),
    -- Navigation
    ["status_bar.background"] = alpha(spec.bg0, M._alphas.MAX),
    ["title_bar.background"] = alpha(spec.bg0, M._alphas.MAX),
    ["title_bar.inactive_background"] = AS_NONE,
    ["toolbar.background"] = alpha(spec.sel0, M._alphas.MID),
    -- Element
    ["element.background"] = fade(accent.dim),
    ["element.hover"] = fade(accent.base),
    ["element.active"] = fade(accent.bright),
    ["element.selected"] = fade(accent.bright),
    ["element.selection_background"] = todo.blue,
    ["element.disabled"] = spec.sel0,
    -- Ghost Element
    ["ghost_element.background"] = AS_NONE,
    ["ghost_element.disabled"] = AS_NONE,
    ["ghost_element.hover"] = alpha(spec.sel1, M._alphas.LOW),
    ["ghost_element.active"] = alpha(spec.sel1, M._alphas.MAX), -- usage: UI popout trigger
    ["ghost_element.selected"] = alpha(spec.sel1, M._alphas.HIGH), -- usage: UI popout item
    -- Drop Target
    ["drop_target.background"] = alpha(spec.bg0, M._alphas.MAX),
    ["drop_target.border"] = todo.red,
    -- Tabs
    ["tab_bar.background"] = alpha(spec.bg1, M._alphas.MID),
    ["tab.inactive_background"] = alpha(spec.bg1, M._alphas.MID),
    ["tab.active_background"] = alpha(spec.sel0, M._alphas.MID),
    -- Scrollbar
    ["scrollbar.thumb.background"] = alpha(spec.sel0, M._alphas.HIGH), -- The scrollbar thumb.
    ["scrollbar.thumb.hover_background"] = alpha(spec.sel1, M._alphas.MAX), -- The scrollbar thumb when hovered over.
    ["scrollbar.thumb.active_background"] = alpha(accent.base, M._alphas.HIGH), -- The scrollbar thumb whilst being actively dragged.
    ["scrollbar.thumb.border"] = AS_NONE, -- The border color of the scrollbar thumb.
    ["scrollbar.track.background"] = alpha(spec.sel0, M._alphas.LOW), -- The background color of the scrollbar track.
    ["scrollbar.track.border"] = AS_NONE, -- The border color of the scrollbar track.
    -- Minimap
    ["minimap.thumb.background"] = alpha(spec.sel0, M._alphas.HIGH), -- The minimap thumb.
    ["minimap.thumb.hover_background"] = alpha(spec.sel1, M._alphas.MAX), -- The minimap thumb when hovered over.
    ["minimap.thumb.active_background"] = alpha(accent.base, M._alphas.MID), -- The minimap thumb whilst being actively dragged.
    ["minimap.thumb.border"] = AS_NONE, -- The border color of the minimap thumb.
    -- Version Control
    ["version_control.added"] = spec.git.add,
    ["version_control.deleted"] = spec.git.removed,
    ["version_control.modified"] = spec.git.changed,
    ["version_control.renamed"] = spec.git.changed,
    ["version_control.conflict"] = spec.git.conflict,
    ["version_control.ignored"] = spec.git.ignored,
    ["version_control.conflict_marker.ours"] = todo.blue,
    ["version_control.conflict_marker.theirs"] = todo.yellow,
    -- Terminal
    ["terminal.background"] = alpha(spec.bg1, M._alphas.MAX_POLARIZE),
    ["terminal.foreground"] = spec.fg1,
    ["terminal.bright_foreground"] = spec.fg0,
    ["terminal.dim_foreground"] = spec.fg2,
    ["terminal.ansi.background"] = AS_NONE,
    ["terminal.ansi.red"] = pal.red.base,
    ["terminal.ansi.blue"] = pal.blue.base,
    ["terminal.ansi.cyan"] = pal.cyan.base,
    ["terminal.ansi.black"] = pal.black.base,
    ["terminal.ansi.green"] = pal.green.base,
    ["terminal.ansi.white"] = pal.white.base,
    ["terminal.ansi.yellow"] = pal.yellow.base,
    ["terminal.ansi.magenta"] = pal.magenta.base,
    ["terminal.ansi.bright_red"] = pal.red.bright,
    ["terminal.ansi.bright_blue"] = pal.blue.bright,
    ["terminal.ansi.bright_cyan"] = pal.cyan.bright,
    ["terminal.ansi.bright_black"] = pal.black.bright,
    ["terminal.ansi.bright_green"] = pal.green.bright,
    ["terminal.ansi.bright_white"] = pal.white.bright,
    ["terminal.ansi.bright_yellow"] = pal.yellow.bright,
    ["terminal.ansi.bright_magenta"] = pal.magenta.bright,
    ["terminal.ansi.dim_red"] = pal.red.dim,
    ["terminal.ansi.dim_blue"] = pal.blue.dim,
    ["terminal.ansi.dim_cyan"] = pal.cyan.dim,
    ["terminal.ansi.dim_black"] = pal.black.dim,
    ["terminal.ansi.dim_green"] = pal.green.dim,
    ["terminal.ansi.dim_white"] = pal.white.dim,
    ["terminal.ansi.dim_yellow"] = pal.yellow.dim,
    ["terminal.ansi.dim_magenta"] = pal.magenta.dim,
    -- vim status
    ["vim.normal.background"] = fade(pal.blue.base),
    ["vim.normal.foreground"] = spec.fg1,
    ["vim.insert.background"] = fade(pal.green.base, 0.5),
    ["vim.insert.foreground"] = spec.fg1,
    ["vim.visual.background"] = fade(pal.magenta.base, 0.5),
    ["vim.visual.foreground"] = spec.fg1,
    ["vim.visual_block.background"] = fade(pal.magenta.base, 0.5),
    ["vim.visual_block.foreground"] = spec.fg1,
    ["vim.visual_line.background"] = fade(pal.magenta.base, 0.5),
    ["vim.visual_line.foreground"] = spec.fg1,
    ["vim.replace.background"] = fade(pal.red.base, 0.5),
    ["vim.replace.foreground"] = spec.fg1,
    ["vim.yank.background"] = pal.white.base,
    ["vim.helix_normal.background"] = fade(pal.blue.base),
    ["vim.helix_normal.foreground"] = spec.fg1,
    ["vim.helix_select.background"] = fade(pal.magenta.base, 0.5),
    ["vim.helix_select.foreground"] = spec.fg1,
    -- others - not defined in https://zed.dev/theme-builder
    ["background.appearance"] = background_appearance,
    ["debugger.accent"] = accent.base,
    ["icon.placeholder"] = AS_NONE,
    ["pane_group.border"] = AS_NONE, -- Surface - others
    ["search.active_match_background"] = alpha(spec.sel1, M._alphas.MAX),
  }
end

---@param tokens table
---@return table<nightfox_zed.HighlightStyle>
function M._syntax_theme_merge(tokens)
  local default = {
    background_color = nil,
    color = nil,
    font_style = nil,
    font_weight = nil,
  }
  return util.tbl_merge(default, tokens)
end

---@param pal nightfox_nvim.Palette
---@param spec nightfox_nvim.Spec
---@return table<string, nightfox_zed.HighlightStyle>
---See: https://github.com/zed-industries/zed/blob/main/crates/theme/src/fallback_themes.rs
function M._syntax_theme(pal, spec)
  local todo = util.color.debug
  local m = M._syntax_theme_merge
  return {
    -- Comments & Docs
    ["comment"] = m({ color = spec.syntax.comment }),
    ["comment.doc"] = m({ color = spec.syntax.comment }),
    -- Strings & Literal
    ["string"] = m({ color = spec.syntax.string }),
    ["string.escape"] = m({ color = pal.green.base }),
    ["string.regex"] = m({ color = spec.syntax.regex }),
    ["string.special"] = m({ color = spec.syntax.builtin1 }),
    ["string.special.symbol"] = m({ color = spec.syntax.builtin0 }),
    ["text.literal"] = m({ color = pal.green.base }),
    -- Numbers & Constants
    boolean = m({ color = spec.syntax.const }),
    constant = m({ color = spec.syntax.const }),
    number = m({ color = spec.syntax.number }),
    -- Keywords & Operators
    keyword = m({ color = spec.syntax.keyword }),
    operator = m({ color = spec.syntax.operator }),
    preproc = m({ color = spec.syntax.preproc }),
    -- Functions & Methods
    attribute = m({ color = spec.syntax.field }),
    constructor = m({ color = spec.syntax.builtin2 }),
    ["function"] = m({ color = spec.syntax.func }),
    -- Types & Classes
    type = m({ color = spec.syntax.type }),
    enum = m({ color = todo.red }),
    namespace = m({ color = todo.blue }),
    variant = m({ color = todo.green }),
    -- Variables & Properties
    label = m({ color = todo.magenta }),
    property = m({ color = pal.blue.base }),
    ["variable"] = m({ color = pal.cyan.base }),
    ["variable.special"] = m({ color = spec.syntax.builtin0 }),
    -- Punctuation
    ["punctuation"] = m({ color = spec.syntax.bracket }),
    ["punctuation.bracket"] = m({ color = spec.syntax.bracket }),
    ["punctuation.delimiter"] = m({ color = spec.syntax.bracket }),
    ["punctuation.list_marker"] = m({ color = spec.syntax.builtin1 }),
    ["punctuation.markup"] = m({ color = spec.syntax.bracket }),
    ["punctuation.special"] = m({ color = spec.syntax.bracket }),
    -- Markup
    tag = m({ color = pal.magenta.dim }),
    title = m({
      color = spec.syntax.func,
      font_weight = 700,
    }),
    ["emphasis"] = m({
      color = spec.fg1,
      font_style = "italic",
    }),
    ["emphasis.strong"] = m({
      color = pal.red.base,
      font_weight = 700,
    }),
    link_text = m({
      color = pal.yellow.base,
      font_style = "underline",
    }),
    link_uri = m({ color = spec.syntax.const }),
    ["selector"] = m({ color = todo.cyan }),
    ["selector.pseudo"] = m({
      color = todo.cyan,
      font_style = "italic",
    }),
    -- Other
    primary = m({ color = todo.red, font_weight = 700 }),
    embedded = m({ color = spec.fg1 }),
    predictive = m({ color = todo.yellow }),
    hint = m({ color = todo.yellow }),
  }
end

---@param appearance nightfox_nvim.BackgroundAppearance
---@return nightfox_nvim.AlphaLevels
function M._set_alpha_levels(appearance)
  local is_opaque = appearance == "opaque"
  -- NOTE: Fibonacci sequence are used for golden ratio
  return { ---@diagnostic disable-line: unused-local
    MIN = is_opaque and 0.21 or 0.13,
    LOW = is_opaque and 0.34 or 0.21,
    MID = is_opaque and 0.55 or 0.34,
    HIGH = is_opaque and 0.89 or 0.55,
    MAX = is_opaque and 1 or 0.89,
    MAX_POLARIZE = is_opaque and 1 or 0,
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
  M._alphas = M._set_alpha_levels(background_appearance)

  return {
    name = display_name,
    appearance = theme_appearance,
    style = util.tbl_merge({
      accents = M._accent_colors(pal, M._alphas.MID),
      players = M._player_colors(pal),
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
