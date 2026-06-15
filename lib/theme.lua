---@alias nightfox_nvim.BackgroundAppearance "opaque" | "blurred" | "transparent" Enables blurred mode incl. alpha colors

local util = require("lib.util")
local logger = util.logger()
---@class nightfox_zed.Theme
---@field private _ns string Namespace
local M = {}
M._ns = ""
---@type nightfox_nvim.AlphaLevels | nil
M._alphas = nil

local AS_NONE = nil -- properties explicitly defined as nil in theme
local AS_UNUSED = nil -- public properties; currently unmapped or unused

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
    ["elevated_surface.background"] = spec.bg0, -- Background color. Used for elevated surfaces, like a context menu, popup, or dialog.
    ["surface.background"] = alpha(spec.bg0, M._alphas.MAX), -- Background Color. Used for grounded surfaces like a panel or tab.
    background = alpha(spec.bg1, M._alphas.MAX), -- Background Color. Used for the app background and blank panels or windows.
    ["panel.background"] = alpha(spec.bg0, M._alphas.MAX_POLARIZE),
    ["panel.focused_border"] = alpha(spec.sel1, M._alphas.MAX),
    ["panel.indent_guide"] = AS_NONE,
    ["panel.indent_guide_active"] = AS_NONE,
    ["panel.indent_guide_hover"] = AS_NONE,
    ["panel.overlay_background"] = alpha(spec.bg0, M._alphas.MAX),
    ["panel.overlay_hover"] = AS_NONE,
    ["pane.focused_border"] = AS_NONE,
    -- Border
    border = alpha(spec.bg2, M._alphas.HIGH), -- Border color. Used for most borders, is usually a high contrast color.
    ["border.variant"] = spec.bg4, -- Border color. Used for deemphasized borders, like a visual divider between two sections
    ["border.focused"] = spec.sel0, -- Border color. Used for focused elements, like keyboard focused list item.
    ["border.selected"] = spec.sel1, -- Border color. Used for selected elements, like an active search filter or selected checkbox.
    ["border.transparent"] = alpha(spec.bg1, M._alphas.MAX_POLARIZE), -- Border color. Used for transparent borders. Used for placeholder borders when an element gains a border on state change.
    ["border.disabled"] = spec.bg1, -- Border color. Used for disabled elements, like a disabled input or button.
    -- Text
    ["text"] = spec.fg0, -- Text Color. Default text color used for most text.
    ["text.accent"] = accent.base, -- Text Color. Color used for emphasis or highlighting certain text, like an active filter or a matched character in a search.
    ["text.disabled"] = spec.syntax.comment, -- Text Color. Color used for text denoting disabled elements. Typically, the color is faded or grayed out to emphasize the disabled state.
    ["text.muted"] = spec.fg1, -- Text Color. Color of muted or deemphasized text. It is a subdued version of the standard text color.
    ["text.placeholder"] = spec.fg3, -- Text Color. Color of the placeholder text typically shown in input fields to guide the user to enter valid data.
    ["link_text.hover"] = pal.cyan.base,
    -- Icon
    icon = AS_NONE, -- Fill Color. Used for the default fill color of an icon.
    ["icon.accent"] = AS_NONE, -- Fill Color. Used for the accent fill color of an icon. This might be used to show when a toggleable icon button is selected.
    ["icon.disabled"] = AS_NONE, -- Fill Color. Used for the disabled fill color of an icon. Disabled states are shown when a user cannot interact with an element, like a icon button.
    ["icon.muted"] = AS_NONE, -- Fill Color. Used for the muted or deemphasized fill color of an icon. This might be used to show an icon in an inactive pane, or to deemphasize a series of icons to give them less visual weight.
    ["icon.placeholder"] = AS_NONE, -- Fill Color. Used for the placeholder fill color of an icon. This might be used to show an icon in an input that disappears when the user enters text.
    -- Editor
    ["editor.foreground"] = spec.fg1,
    ["editor.background"] = alpha(editor_bg, M._alphas.MAX_POLARIZE),
    ["editor.gutter.background"] = alpha(spec.bg1, M._alphas.MAX_POLARIZE),
    ["editor.active_line.background"] = alpha(spec.sel0, M._alphas.LOW),
    ["editor.highlighted_line.background"] = AS_NONE,
    ["editor.debugger_active_line.background"] = todo.magenta.base, -- Background of active line of debugger
    ["editor.subheader.background"] = AS_NONE,
    ["editor.active_line_number"] = pal.yellow.base, -- Text Color. Used for the text of the line number in the editor gutter when the line is highlighted.
    ["editor.line_number"] = spec.fg3, -- Text Color. Used for the text of the line number in the editor gutter.
    ["editor.hover_line_number"] = todo.cyan.base, -- Text Color. Used for the text of the line number in the editor gutter when the line is hovered over.
    ["editor.invisible"] = AS_NONE, -- Text Color. Used to mark invisible characters in the editor. Example: spaces, tabs, carriage returns, etc.
    ["editor.wrap_guide"] = alpha(spec.bg2, M._alphas.MID),
    ["editor.active_wrap_guide"] = alpha(spec.bg2, M._alphas.MAX),
    ["editor.indent_guide"] = alpha(spec.bg2, M._alphas.MAX),
    ["editor.indent_guide_active"] = alpha(spec.sel1, M._alphas.MAX),
    ["editor.document_highlight.read_background"] = AS_NONE, -- Read-access of a symbol, like reading a variable. A document highlight is a range inside a text document which deserves special attention. Usually a document highlight is visualized by changing the background color of its range.
    ["editor.document_highlight.write_background"] = AS_NONE, -- Read-access of a symbol, like reading a variable. A document highlight is a range inside a text document which deserves special attention. Usually a document highlight is visualized by changing the background color of its range.
    ["editor.document_highlight.bracket_background"] = alpha(spec.sel0, M._alphas.MAX), -- Highlighted brackets background color. Matching brackets in the cursor scope are highlighted with this background color.
    ["editor.diff_hunk.added.background"] = AS_NONE, -- Filled background color for added diff hunk row highlights in the editor
    ["editor.diff_hunk.added.hollow_background"] = AS_NONE, -- Hollow background color for added diff hunk row highlights in the editor
    ["editor.diff_hunk.added.hollow_border"] = AS_NONE, -- Hollow border color for added diff hunk row highlights in the editor
    ["editor.diff_hunk.deleted.background"] = AS_NONE, -- Filled background color for deleted diff hunk row highlights in the editor
    ["editor.diff_hunk.deleted.hollow_background"] = AS_NONE, -- Hollow background color for deleted diff hunk row highlights in the editor
    ["editor.diff_hunk.deleted.hollow_border"] = AS_NONE, -- Hollow border color for deleted diff hunk row highlights in the editor
    ["search.match_background"] = alpha(spec.sel1, M._alphas.MIN),
    -- Navigation
    ["status_bar.background"] = alpha(spec.bg0, M._alphas.MAX),
    ["title_bar.background"] = alpha(spec.bg0, M._alphas.MAX),
    ["title_bar.inactive_background"] = AS_NONE,
    ["toolbar.background"] = alpha(spec.sel0, M._alphas.MID),
    -- Element
    ["element.active"] = spec.sel1, -- Background Color. Used for the active state of an element that should have a different background than the surface it's on. Active states are triggered by the mouse button being pressed down on an element, or the Return button or other activator being pressed.
    ["element.background"] = spec.sel0, -- Background Color. Used for the background of an element that should have a different background than the surface it's on. Elements might include: Buttons, Inputs, Checkboxes, Radio Buttons... For an element that should have the same background as the surface it's on, use `ghost_element_background`.
    ["element.disabled"] = spec.sel0, -- Background Color. Used for the disabled state of an element that should have a different background than the surface it's on. Disabled states are shown when a user cannot interact with an element, like a disabled button or input.
    ["element.hover"] = fade(accent.dim), -- Background Color. Used for the hover state of an element that should have a different background than the surface it's on. Hover states are triggered by the mouse entering an element, or a finger touching an element on a touch screen.
    ["element.selected"] = fade(accent.base), -- Background Color. Used for the selected state of an element that should have a different background than the surface it's on. Selected states are triggered by the element being selected (or "activated") by the user. This could include a selected checkbox, a toggleable button that is toggled on, etc.
    ["element.selection_background"] = alpha(spec.sel1, M._alphas.LOW), -- Background Color. Used for the background of selections in a UI element.
    -- Ghost Element
    ["ghost_element.active"] = spec.sel1, -- Background Color. Used for the active state of a ghost element that should have the same background as the surface it's on. Active states are triggered by the mouse button being pressed down on an element, or the Return button or other activator being pressed.
    ["ghost_element.background"] = AS_NONE, -- Used for the background of a ghost element that should have the same background as the surface it's on. Elements might include: Buttons, Inputs, Checkboxes, Radio Buttons... For an element that should have a different background than the surface it's on, use `element_background`.
    ["ghost_element.disabled"] = AS_NONE, -- Background Color. Used for the disabled state of a ghost element that should have the same background as the surface it's on. Disabled states are shown when a user cannot interact with an element, like a disabled button or input.
    ["ghost_element.hover"] = spec.sel0, -- Background Color. Used for the hover state of a ghost element that should have the same background as the surface it's on. Hover states are triggered by the mouse entering an element, or a finger touching an element on a touch screen.
    ["ghost_element.selected"] = fade(accent.dim), -- Background Color. Used for the selected state of a ghost element that should have the same background as the surface it's on. Selected states are triggered by the element being selected (or "activated") by the user. This could include a selected checkbox, a toggleable button that is toggled on, etc.
    -- Drop Target
    ["drop_target.background"] = alpha(spec.bg0, M._alphas.MAX),
    ["drop_target.border"] = todo.red.base,
    -- Tabs
    ["tab_bar.background"] = alpha(spec.bg1, M._alphas.MID),
    ["tab.inactive_background"] = alpha(spec.bg1, M._alphas.MID),
    ["tab.active_background"] = alpha(spec.sel0, M._alphas.MID),
    -- Scrollbar
    ["scrollbar.thumb.background"] = alpha(spec.sel0, M._alphas.HIGH),
    ["scrollbar.thumb.hover_background"] = alpha(spec.sel1, M._alphas.MAX),
    ["scrollbar.thumb.active_background"] = alpha(accent.base, M._alphas.HIGH),
    ["scrollbar.thumb.border"] = AS_NONE,
    ["scrollbar.track.background"] = alpha(spec.sel0, M._alphas.LOW),
    ["scrollbar.track.border"] = AS_NONE,
    -- Minimap
    ["minimap.thumb.background"] = alpha(spec.sel0, M._alphas.HIGH),
    ["minimap.thumb.hover_background"] = alpha(spec.sel1, M._alphas.MAX),
    ["minimap.thumb.active_background"] = alpha(accent.base, M._alphas.MID),
    ["minimap.thumb.border"] = AS_NONE,
    -- Version Control
    ["version_control.added"] = spec.git.add,
    ["version_control.deleted"] = spec.git.removed,
    ["version_control.modified"] = spec.git.changed,
    ["version_control.renamed"] = spec.git.changed,
    ["version_control.conflict"] = spec.git.conflict,
    ["version_control.ignored"] = spec.git.ignored,
    ["version_control.conflict_marker.ours"] = todo.blue.base,
    ["version_control.conflict_marker.theirs"] = todo.yellow.base,
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
    ["debugger.accent"] = accent.base, -- Color used to accent some of the debuggers elements Only accent breakpoint & breakpoint related symbols right now
    ["pane_group.border"] = AS_NONE, -- Surface - others
    ["search.active_match_background"] = alpha(spec.sel1, M._alphas.MAX),
  }
end

---@param tokens table
---@return table<nightfox_zed.HighlightStyle>
function M._syntax_theme_merge(tokens)
  local default = {
    background_color = AS_NONE,
    color = AS_NONE,
    font_style = AS_NONE,
    font_weight = AS_NONE,
  }
  return util.tbl_merge(default, tokens)
end

---@param pal nightfox_nvim.Palette
---@param spec nightfox_nvim.Spec
---@return table<string, nightfox_zed.HighlightStyle>
---See: https://github.com/zed-industries/zed/blob/main/crates/theme/src/fallback_themes.rs
---See: https://zed.dev/docs/extensions/languages#syntax-highlighting
function M._syntax_theme(pal, spec)
  local m = M._syntax_theme_merge
  return {
    -- Comments & Docs
    ["comment"] = m({ color = spec.syntax.comment }),
    ["comment.doc"] = m({ color = spec.syntax.comment }),
    -- Strings & Literal
    ["string"] = m({ color = spec.syntax.string }),
    ["string.doc"] = AS_NONE, -- e.g. python
    ["string.special"] = m({ color = spec.syntax.builtin1 }), -- e.g. javascript, tsx
    ["string.special.path"] = AS_NONE, -- e.g. gitcommit
    ["string.special.symbol"] = AS_NONE, -- e.g. gitcommit
    ["text.literal"] = AS_UNUSED,
    -- Numbers & Constants
    boolean = m({ color = spec.syntax.const }),
    ["constant"] = m({ color = spec.syntax.const }),
    ["constant.builtin"] = m({ color = spec.syntax.builtin2 }),
    number = m({ color = spec.syntax.number }),
    -- Keywords & Operators
    ["keyword"] = m({ color = spec.syntax.keyword }),
    ["keyword.control"] = AS_NONE,
    ["keyword.declaration"] = AS_NONE,
    ["keyword.directive"] = m({ color = spec.syntax.func }), -- e.g. jsx
    ["keyword.import"] = m({ color = spec.syntax.preproc }),
    ["keyword.jsdoc"] = AS_NONE,
    ["keyword.modifier"] = AS_NONE,
    ["keyword.operator"] = m({ color = spec.syntax.operator }),
    ["keyword.preproc"] = AS_NONE,
    operator = m({ color = spec.syntax.operator }),
    preproc = m({ color = spec.syntax.preproc }),
    -- Functions & Methods
    ["attribute"] = m({
      color = spec.syntax.field,
      font_style = "italic",
    }),
    ["attribute.builtin"] = m({
      color = spec.syntax.const,
      font_style = "normal",
    }), -- e.g. python
    constructor = m({ color = spec.syntax.ident }),
    ["function"] = m({ color = spec.syntax.func }),
    ["function.builtin"] = m({ color = spec.syntax.builtin0 }),
    ["function.call"] = AS_NONE, -- e.g. cpp, python, go
    ["function.decorator"] = m({ color = spec.syntax.const }), -- e.g. python
    ["function.decorator.call"] = AS_NONE, -- e.g. python
    ["function.definition"] = AS_NONE,
    ["function.kwargs"] = m({ color = spec.syntax.ident }), -- e.g. python
    ["function.method"] = AS_NONE,
    ["function.method.call"] = AS_NONE, -- e.g. python, go
    ["function.method.constructor"] = m({ color = spec.syntax.ident }), -- e.g. python
    ["function.special"] = m({ color = spec.syntax.builtin0 }),
    -- Types & Classes
    ["type"] = m({ color = spec.syntax.type }),
    ["type.builtin"] = AS_NONE,
    ["type.class"] = AS_NONE,
    ["type.class.call"] = m({ color = spec.syntax.ident }), -- e.g. python
    ["type.class.definition"] = AS_NONE, -- e.g. python
    ["type.class.inheritance"] = m({ color = spec.syntax.ident }), -- e.g. python
    ["type.definition"] = AS_NONE,
    ["type.interface"] = AS_NONE, -- e.g. rust
    ["type.name"] = AS_NONE, -- e.g. typescript
    enum = AS_UNUSED,
    namespace = m({ color = spec.syntax.builtin1 }), -- e.g. css, go, cpp
    variant = AS_UNUSED,
    -- Variables & Properties
    label = AS_NONE, -- e.g. c, diff, go, cpp, regex
    ["property"] = m({ color = spec.syntax.field }),
    ["property.json_key"] = AS_NONE,
    ["property.name"] = AS_NONE,
    ["variable"] = m({ color = spec.syntax.variable }),
    ["variable.builtin"] = AS_NONE,
    ["variable.other.member"] = AS_NONE, -- e.g. gitcommit
    ["variable.parameter"] = m({ color = spec.syntax.ident }), -- function/method parameters
    ["variable.special"] = m({ color = spec.syntax.builtin0 }),
    -- Punctuation
    ["punctuation"] = m({ color = spec.syntax.operator }),
    ["punctuation.bracket"] = m({ color = spec.syntax.bracket }),
    ["punctuation.delimiter"] = AS_NONE,
    ["punctuation.list_marker"] = m({ color = spec.syntax.builtin1 }),
    ["punctuation.special"] = m({ color = spec.syntax.builtin1 }),
    -- Markup
    ["tag"] = m({ color = spec.syntax.keyword }),
    ["tag.doctype"] = m({ color = spec.syntax.const }), -- doctypes (e.g., in HTML)
    title = m({
      color = spec.syntax.func,
      font_weight = 700,
    }),
    ["emphasis"] = m({
      color = spec.syntax.builtin0,
      font_style = "italic",
    }),
    ["emphasis.strong"] = m({
      color = spec.syntax.builtin0,
      font_weight = 700,
    }),
    link_text = m({ color = spec.syntax.func }),
    link_uri = m({
      color = spec.syntax.builtin2,
      font_style = "italic",
    }),
    ["selector"] = m({ color = spec.syntax.type }),
    ["selector.pseudo"] = m({ color = spec.syntax.const }),
    -- special: markup
    ["emphasis.markup"] = AS_NONE, -- e.g. markdown-inline
    ["emphasis.strong.markup"] = AS_NONE, -- e.g. markdown-inline
    ["link_text.markup"] = AS_NONE, -- e.g. markdown, markdown-inline
    ["link_uri.markup"] = AS_NONE, -- e.g. markdown, markdown-inline
    ["markup.heading"] = AS_NONE, -- e.g. gitcommit
    ["markup.link_uri"] = AS_NONE, -- e.g. gitcommit
    ["punctuation.embedded.markup"] = m({ color = spec.syntax.keyword }), -- e.g. markdown
    ["punctuation.list_marker.markup"] = AS_NONE, -- e.g. markdown
    ["punctuation.markup"] = m({ color = spec.syntax.keyword }), -- e.g. markdown
    ["strikethrough.markup"] = m({ color = spec.syntax.builtin1 }), -- e.g. markdown-inline
    ["text.literal.markup"] = m({ color = spec.syntax.builtin1 }), -- e.g. markdown-inline
    ["text.markup"] = AS_NONE, -- e.g. markdown
    ["title.markup"] = AS_NONE, -- e.g. markdown
    -- special: jsx
    ["attribute.jsx"] = AS_NONE,
    ["punctuation.bracket.jsx"] = m({ color = spec.syntax.builtin1 }), -- e.g. javascript, tsx
    ["punctuation.delimiter.jsx"] = AS_NONE, -- e.g. tsx
    ["tag.component.jsx"] = m({ color = spec.syntax.func }), -- e.g. javascript, tsx
    ["tag.jsx"] = AS_NONE,
    ["text.jsx"] = AS_NONE,
    -- special: regex
    ["keyword.operator.regex"] = m({ color = spec.syntax.func }), -- e.g. regex, typescript, javascript, jsx
    ["label.regex"] = m({ color = spec.syntax.regex }), -- e.g. regex
    ["number.quantifier.regex"] = AS_NONE, -- e.g. regex
    ["operator.regex"] = AS_NONE, -- e.g. regex
    ["punctuation.bracket.regex"] = AS_NONE, -- e.g. regex
    ["punctuation.delimiter.regex"] = AS_NONE, -- e.g. regex
    ["string.escape"] = m({ color = spec.syntax.builtin2 }), -- e.g. regex
    ["string.escape.regex"] = AS_NONE, -- e.g. regex
    ["string.regex"] = m({ color = spec.syntax.regex }),
    -- Other
    embedded = m({ color = spec.fg1 }), -- embedded content
    hint = AS_UNUSED, -- hints
    predictive = AS_UNUSED, --  predictive text
    primary = AS_UNUSED, -- primary elements
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
