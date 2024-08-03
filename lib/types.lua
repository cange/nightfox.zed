---@meta

---@class Metadata
---@field id string
---@field name string
---@field authors table
---@field description string
---@field repository string

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

---@class ZedPlayerColor
---@field cursor string
---@field background string
---@filed selection string

---@class ZedHighlightStyle
---@field color string
---@field font_weight string
---@field font_style string
---@field background_color string
---@field underline string
---@field strikethrough string
---@field fade_out string