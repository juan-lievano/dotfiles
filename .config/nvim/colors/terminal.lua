-- terminal.lua: a colorscheme with no colors in it.
--
-- Every group names an ANSI slot (0-15) or NONE; the terminal's palette
-- decides what those look like. Change the palette (termbg, or `theme =`
-- in the Ghostty config) and a running nvim repaints with it, no restart.
-- Plugins inherit through the standard groups they link to (mini.pick ->
-- NormalFloat/FloatBorder/CursorLine/Visual/Diagnostic*).
--
-- Slot meanings, as ls/git/every 16-color scheme assume them:
--   0 black (bg+)  1 red  2 green  3 yellow  4 blue  5 magenta  6 cyan  7 grey-
--   8 grey (chrome, selection)   9-15 bright variants   NONE = terminal fg/bg
-- Syntax follows Catppuccin's semantics; chrome keeps the old taste (pink
-- float border, peach prompt/current row), transparent backgrounds everywhere.

vim.cmd("highlight clear")
if vim.fn.exists("syntax_on") == 1 then vim.cmd("syntax reset") end
vim.g.colors_name = "terminal"
vim.o.termguicolors = false

local function hl(group, fg, bg, attrs)
	local o = { ctermfg = fg, ctermbg = bg }
	for _, a in ipairs(attrs or {}) do o[a] = true end
	vim.api.nvim_set_hl(0, group, o)
end
local function link(group, to) vim.api.nvim_set_hl(0, group, { link = to }) end
local NONE = "NONE"

-- editor chrome
hl("Normal", NONE, NONE)
hl("NormalNC", NONE, NONE)
hl("NormalFloat", NONE, NONE)
hl("FloatBorder", 1, NONE)
hl("FloatTitle", 3, NONE, { "bold" })
hl("LineNr", 7, NONE)
hl("CursorLineNr", 11, NONE, { "bold" })
hl("CursorLine", NONE, 0)
hl("CursorColumn", NONE, 0)
hl("ColorColumn", NONE, 0)
hl("SignColumn", NONE, NONE)
hl("FoldColumn", 8, NONE)
hl("Folded", 8, NONE, { "italic" })
hl("NonText", 8, NONE)
hl("Whitespace", 8, NONE)
hl("SpecialKey", 8, NONE)
hl("EndOfBuffer", 0, NONE)
hl("WinSeparator", 8, NONE)
hl("VertSplit", 8, NONE)
hl("StatusLine", 15, NONE, { "bold" })
hl("StatusLineNC", 8, NONE)
hl("TabLine", 8, NONE)
hl("TabLineSel", NONE, NONE, { "bold" })
hl("TabLineFill", NONE, NONE)
hl("WinBar", NONE, NONE, { "bold" })
hl("WinBarNC", 8, NONE)
hl("Title", 4, NONE, { "bold" })
hl("Directory", 4, NONE)
hl("ModeMsg", 15, NONE, { "bold" })
hl("MoreMsg", 10, NONE)
hl("Question", 10, NONE)
hl("ErrorMsg", 9, NONE, { "bold" })
hl("WarningMsg", 3, NONE)
hl("Conceal", 8, NONE)
hl("Visual", NONE, 8)
hl("VisualNOS", NONE, 8)
hl("Search", 0, 3)
hl("CurSearch", 0, 11, { "bold" })
hl("IncSearch", 0, 11, { "bold" })
hl("Substitute", 0, 1)
hl("MatchParen", NONE, 8, { "bold" })
hl("QuickFixLine", NONE, 0, { "bold" })
hl("Cursor", 0, 15)
hl("lCursor", 0, 15)
hl("TermCursor", 0, 15)

-- popup menu (completion)
hl("Pmenu", NONE, 0)
hl("PmenuSel", 0, 3, { "bold" })
hl("PmenuKind", 12, 0)
hl("PmenuKindSel", 0, 12, { "bold" })
hl("PmenuExtra", 10, 0)
hl("PmenuExtraSel", 0, 10, { "bold" })
hl("PmenuSbar", NONE, 0)
hl("PmenuThumb", NONE, 3)
hl("PmenuMatch", 11, 0, { "bold" })
hl("PmenuMatchSel", 0, 11, { "bold" })
hl("WildMenu", 0, 3, { "bold" })

-- syntax: Catppuccin's semantics in slots (keywords mauve -> 5, functions
-- blue -> 4, strings green -> 2, numbers peach -> 9 (img2palette puts the
-- image's orange there), types yellow -> 3, preproc/special pink -> 13,
-- operators sky -> 6, variables plain text).
-- Comment on 7 not 8: over a background image the light regions composite
-- to mid grey and slot 8 vanishes there; italics carry the "comment" cue.
hl("Comment", 7, NONE, { "italic" })
hl("Constant", 9, NONE)
hl("String", 2, NONE)
hl("Character", 14, NONE)
hl("Number", 9, NONE)
hl("Boolean", 9, NONE)
hl("Float", 9, NONE)
hl("Identifier", NONE, NONE)
hl("Function", 4, NONE)
hl("Statement", 5, NONE)
hl("Conditional", 5, NONE)
hl("Repeat", 5, NONE)
hl("Label", 14, NONE)
hl("Operator", 6, NONE)
hl("Keyword", 5, NONE)
hl("Exception", 5, NONE)
hl("PreProc", 13, NONE)
hl("Include", 5, NONE)
hl("Define", 13, NONE)
hl("Macro", 5, NONE)
hl("Type", 3, NONE)
hl("StorageClass", 3, NONE)
hl("Structure", 3, NONE)
hl("Typedef", 3, NONE)
hl("Special", 13, NONE)
hl("SpecialChar", 13, NONE)
hl("Tag", 12, NONE)
hl("Delimiter", 7, NONE)
hl("Underlined", 12, NONE, { "underline" })
hl("Ignore", 8, NONE)
hl("Error", 15, 1)
hl("Todo", 0, 3, { "bold" })
hl("Added", 2, NONE)
hl("Removed", 1, NONE)
hl("Changed", 3, NONE)
link("@variable", "Normal")
hl("@variable.builtin", 1, NONE)
hl("@variable.parameter", 9, NONE)
hl("@variable.member", 12, NONE)
hl("@property", 12, NONE)
hl("@module", 12, NONE)
hl("@constructor", 14, NONE)
hl("@attribute", 3, NONE)
hl("@function.builtin", 9, NONE)
link("@punctuation", "Delimiter")
hl("@markup.heading", 4, NONE, { "bold" })
hl("@markup.link", 12, NONE, { "underline" })
hl("@markup.raw", 2, NONE)
hl("@markup.quote", 7, NONE, { "italic" })
hl("@markup.list", 6, NONE)

-- diff
hl("DiffAdd", 2, NONE)
hl("DiffDelete", 1, NONE)
hl("DiffChange", 3, NONE)
hl("DiffText", 0, 3, { "bold" })
link("diffAdded", "DiffAdd")
link("diffRemoved", "DiffDelete")
link("diffChanged", "DiffChange")

-- diagnostics / lsp (signs stay transparent: fg only)
hl("DiagnosticError", 9, NONE)
hl("DiagnosticWarn", 3, NONE)
hl("DiagnosticInfo", 12, NONE)
hl("DiagnosticHint", 14, NONE)
hl("DiagnosticOk", 10, NONE)
hl("DiagnosticUnderlineError", NONE, NONE, { "undercurl" })
hl("DiagnosticUnderlineWarn", NONE, NONE, { "undercurl" })
hl("DiagnosticUnderlineInfo", NONE, NONE, { "undercurl" })
hl("DiagnosticUnderlineHint", NONE, NONE, { "undercurl" })
hl("LspReferenceText", NONE, 0)
hl("LspReferenceRead", NONE, 0)
hl("LspReferenceWrite", NONE, 0, { "bold" })
hl("SpellBad", 1, NONE, { "undercurl" })
hl("SpellCap", 3, NONE, { "undercurl" })
hl("SpellRare", 5, NONE, { "undercurl" })
hl("SpellLocal", 6, NONE, { "undercurl" })

-- quickfix
link("qfFileName", "Identifier")
link("qfError", "WarningMsg")

-- mini.pick: everything else comes through its links to the groups above;
-- these two carried the old look (peach prompt, dark-on-peach current row).
hl("MiniPickPrompt", 3, NONE, { "bold" })
hl("MiniPickMatchCurrent", 0, 3, { "bold" })
