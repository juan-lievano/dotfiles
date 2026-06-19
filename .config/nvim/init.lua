local vim = vim

-- UI / editor opts
vim.o.number = true
vim.o.relativenumber = true
vim.o.wrap = false
vim.o.tabstop = 4
vim.o.swapfile = false
vim.o.winborder = "rounded"
vim.opt.clipboard = "unnamedplus"

-- one global statusline at the bottom instead of one per window
-- (avoids duplicate bars between stacked splits, e.g. in leetcode.nvim)
vim.opt.laststatus = 3

vim.g.mapleader = " "

vim.keymap.set('n', '<leader>o', ':update<CR> :source<CR>')
vim.keymap.set('n', '<leader>w', ':write<CR>')
vim.keymap.set('n', '<leader>q', ':quit<CR>')
vim.keymap.set('n', '<leader>lf', vim.lsp.buf.format)
vim.keymap.set("n", "<leader>r", ":w <CR>:!python %<CR>")
vim.keymap.set("n", "<leader>yf", ":%y<CR>", { desc = "Yank whole file" })
vim.keymap.set("n", "<leader>pf", "ggVGp", { desc = "Replace whole file with clipboard" })

-- plugins
vim.pack.add({
	"https://github.com/echasnovski/mini.files",
	"https://github.com/echasnovski/mini.pick",
	"https://github.com/neovim/nvim-lspconfig",
	"https://github.com/mluders/comfy-line-numbers.nvim",
})

vim.lsp.enable({ "lua_ls", "pyright", "texlab" })
local pick = require("mini.pick")
pick.setup({
	mappings = {
		-- Ctrl-J behaves like Enter inside the picker (terminal sends Ctrl-J as
		-- <NL>, not <CR>, so it doesn't match the default `choose` key on its
		-- own). Replicates the built-in choose: pick current item, then stop.
		choose_ctrl_j = {
			char = "<C-j>",
			func = function()
				local item = pick.get_picker_matches().current
				if item == nil then return true end
				pick.get_picker_opts().source.choose(item)
				return true
			end,
		},
	},
})
require("mini.files").setup()
require("comfy-line-numbers").setup()

-- Absolute line numbers while typing a `:` command, relative otherwise.
-- comfy-line-numbers renders absolute numbers whenever relativenumber is off,
-- so we just flip it off on cmdline enter (and redraw, since the buffer won't
-- repaint on its own mid-command) and flip it back on leave.
local cmdline_nums = vim.api.nvim_create_augroup("CmdlineAbsoluteNumbers", { clear = true })
vim.api.nvim_create_autocmd("CmdlineEnter", {
	group = cmdline_nums,
	pattern = ":",
	callback = function()
		if vim.wo.relativenumber then
			vim.wo.relativenumber = false
			vim.cmd("redraw")
		end
	end,
})
vim.api.nvim_create_autocmd("CmdlineLeave", {
	group = cmdline_nums,
	pattern = ":",
	callback = function()
		vim.wo.relativenumber = true
	end,
})

require("leetcode_config")

-- -- things for :make to work (simpler than below but doesn't produce all the links)
-- vim.api.nvim_create_autocmd("FileType", {
-- 	pattern = "python",
-- 	callback = function(args)
-- 		vim.cmd("compiler pyunit")
-- 		vim.bo[args.buf].makeprg = "python3 %"
-- 	end,
-- })

-- things for :make to work
-- good enough for now but probably can be better.
vim.api.nvim_create_autocmd("FileType", {
	pattern = "python",
	callback = function(args)
		vim.bo[args.buf].makeprg = "python3 %"
		-- Python traceback error format
		vim.bo[args.buf].errorformat = table.concat({
			'%A  File "%f"\\, line %l\\, in %m', -- Each stack frame
			'%+C    %.%#',  -- Code lines (append to message)
			'%Z%m',         -- Capture the entire error line
			'%-GTraceback%.%#', -- Ignore "Traceback" line
			'%-G%.%#',      -- Ignore other lines
		}, ',')
	end,
})

  -- LaTeX: <leader>ll builds the current file with latexmk and opens the PDF.
  -- Build layout is configured in ~/.latexmkrc.
  vim.api.nvim_create_autocmd("FileType", {
    pattern = { "tex", "plaintex" },
    callback = function(args)
      vim.keymap.set("n", "<leader>ll", function()
        local file = vim.fn.expand("%:p")
        local dir  = vim.fn.expand("%:p:h")
        local name = vim.fn.expand("%:t:r")
        vim.cmd("silent! write")
        local cmd = { "latexmk", "-cd", file }
        vim.notify("latexmk: building " .. name .. ".tex ...")
        vim.fn.jobstart(cmd, {
          stdout_buffered = true,
          stderr_buffered = true,
          on_exit = function(_, code)
            if code == 0 then
              vim.fn.jobstart({ "open", dir .. "/" .. name .. ".pdf" })
            else
              vim.notify("latexmk failed (exit " .. code .. ")", vim.log.levels.ERROR)
              vim.cmd("cfile " .. vim.fn.fnameescape(dir .. "/build/" .. name .. ".log"))
              vim.cmd("copen")
            end
          end,
        })
      end, { buffer = args.buf, desc = "latexmk current file and open PDF" })
    end,
  })

-- misc keymaps
vim.keymap.set('n', '<leader>f', ":Pick files<CR>")
vim.keymap.set('n', '<leader>b', ":Pick buffers<CR>")
vim.keymap.set('n', '<leader>e', function() MiniFiles.open() end)
vim.keymap.set('n', '<leader>m', ":write | :make<CR>")

-- buffers
vim.keymap.set('n', '[b', ':bprevious<CR>')
vim.keymap.set('n', ']b', ':bnext<CR>')
vim.keymap.set('n', '[B', ':bfirst<CR>')
vim.keymap.set('n', ']B', ':blast<CR>')

-- window navigation (like tmux)
vim.keymap.set("n", "<C-h>", "<C-w>h")
vim.keymap.set("n", "<C-j>", "<C-w>j")
vim.keymap.set("n", "<C-k>", "<C-w>k")
vim.keymap.set("n", "<C-l>", "<C-w>l")

-- LSP keymaps
-- k
vim.api.nvim_create_autocmd("LspAttach", {
	callback = function(args)
		vim.keymap.set("n", "gd", vim.lsp.buf.definition, { buffer = args.buf, silent = true })
		vim.keymap.set("n", "gD", vim.lsp.buf.declaration, { buffer = args.buf, silent = true })
		vim.keymap.set("n", "gr", vim.lsp.buf.references, { buffer = args.buf, silent = true })
		vim.keymap.set("n", "gi", vim.lsp.buf.implementation, { buffer = args.buf, silent = true })
		vim.keymap.set("n", "K", vim.lsp.buf.hover, { buffer = args.buf, silent = true })
		vim.keymap.set("n", "<leader>d", vim.diagnostic.open_float, { buffer = args.buf, silent = true })
		vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, { buffer = args.buf, silent = true })
		vim.keymap.set("n", "]d", vim.diagnostic.goto_next, { buffer = args.buf, silent = true })
	end,
})
-- make splash screen (home screen) be just blank
vim.opt.shortmess:append("I")

vim.opt.termguicolors = true
vim.cmd("colorscheme slate")

-- better colors for mini.pick window
-- colorful + slate-friendly, pink & peach, no gray
vim.api.nvim_set_hl(0, "MiniPickNormal", { fg = "#FFD7BA", bg = "NONE" })                       -- peach text on dark background
vim.api.nvim_set_hl(0, "MiniPickBorder", { fg = "#FF6F91", bg = "NONE" })                       -- vibrant pink-red border
vim.api.nvim_set_hl(0, "MiniPickPrompt", { fg = "#FFB347", bg = "NONE", bold = true })          -- peach-orange prompt
-- vim.api.nvim_set_hl(0, "MiniPickMatch",   { fg = "#FF85A1", italic = true, underline = true }) -- rosy highlight for matches
vim.api.nvim_set_hl(0, "MiniPickMatchCurrent", { fg = "#000000", bg = "#FFB6A0", bold = true }) -- dark text on soft peach stripe

--- floating window (like minipick)
vim.api.nvim_set_hl(0, "NormalFloat", { bg = "None", fg = "#ffd7ba" }) -- peach text on warm dark bg
vim.api.nvim_set_hl(0, "FloatBorder", { bg = "None", fg = "#ff6f91" }) -- pink border

-- tabline (matches wezterm tab colors: peach-tan active, gray inactive)
vim.api.nvim_set_hl(0, "TabLine", { fg = "#888888", bg = "NONE" })                  -- inactive tab
vim.api.nvim_set_hl(0, "TabLineSel", { fg = "#e6c9a8", bg = "NONE", bold = true })  -- active tab
vim.api.nvim_set_hl(0, "TabLineFill", { bg = "NONE" })                              -- empty fill

-- line numbers
vim.api.nvim_set_hl(0, "LineNr", { fg = "#ffd7ba" })                    -- regular line numbers
vim.api.nvim_set_hl(0, "CursorLineNr", { fg = "#ffb347", bold = true }) -- current line number

-- Pmenu stuff (the stuff for autocomplete words and maybe other things)
vim.api.nvim_set_hl(0, "Pmenu", { bg = "#3b322e", fg = "#f0e6df" })                 -- very muted earthy peach background
vim.api.nvim_set_hl(0, "PmenuSel", { bg = "#f4b183", fg = "#1c1c1c", bold = true }) -- strong peach selection

vim.api.nvim_set_hl(0, "PmenuKind", { fg = "#a0c4ff", bg = "NONE" })                -- pastel blue accent
vim.api.nvim_set_hl(0, "PmenuKindSel", { fg = "#ffffff", bg = "#a0c4ff", bold = true })

vim.api.nvim_set_hl(0, "PmenuExtra", { fg = "#caffbf", bg = "NONE" }) -- pastel green accent
vim.api.nvim_set_hl(0, "PmenuExtraSel", { fg = "#1c1c1c", bg = "#caffbf", bold = true })

vim.api.nvim_set_hl(0, "PmenuSbar", { bg = "#463a34" })               -- darker muted peach for scrollbar track
vim.api.nvim_set_hl(0, "PmenuThumb", { bg = "#ffd6a5" })              -- soft pastel peach thumb

vim.api.nvim_set_hl(0, "PmenuMatch", { fg = "#eab676", bold = true }) -- amber highlight
vim.api.nvim_set_hl(0, "PmenuMatchSel", { fg = "#1c1c1c", bg = "#eab676", bold = true })

-- Transparent sign column
vim.api.nvim_set_hl(0, "SignColumn", { bg = "NONE" })

-- Transparent diagnostic signs
vim.api.nvim_set_hl(0, "DiagnosticSignError", { bg = "NONE" })
vim.api.nvim_set_hl(0, "DiagnosticSignWarn", { bg = "NONE" })
vim.api.nvim_set_hl(0, "DiagnosticSignInfo", { bg = "NONE" })
vim.api.nvim_set_hl(0, "DiagnosticSignHint", { bg = "NONE" })

--change comments color (slate is too gray and hard to read)

vim.api.nvim_set_hl(0, "Comment", { fg = "#aaaaaa", italic = true })
-- vim.cmd(":hi statusline guibg=#000000, guifg=#00FFFF")
-- vim.cmd(":hi statuslineNC guibg=#FFFFFF, guifg=#999999")

-- make active/inactive statuslines nicer
vim.api.nvim_set_hl(0, "StatusLine", { fg = "#FFFFFF", bg = "NONE" })
vim.api.nvim_set_hl(0, "StatusLineNC", { fg = "#aaaaaa", bg = "NONE" })

-- fix the split divider color
vim.api.nvim_set_hl(0, "WinSeparator", { fg = "#555555", bg = "NONE" })

-- changing color scheme on the qf list to be nicer
vim.api.nvim_set_hl(0, 'qfFileName', { link = 'Identifier' }) -- Usually a softer blue/cyan
vim.api.nvim_set_hl(0, 'qfError', { link = 'WarningMsg' })    -- Usually orange/yellow, less harsh than Error

vim.opt.termguicolors = true
-- vim.cmd("highlight Normal guibg=none guifg=none") --this might be making it so that kws like False aren't propery colorized
vim.cmd("highlight Normal guibg=none")
-- Makes the Visual and VisualMode banner below not an annoying yellow
vim.api.nvim_set_hl(0, "ModeMsg", { fg = "#ffffff", bg = "None", bold = true })

-- dictionary and spelling stuff
-- vim.opt.spell = true
-- vim.opt.spelllang = "es,en" -- spanish, english
-- system word list (used by i_CTRL-X_CTRL-K dictionary completion)
vim.opt.dictionary:append("/usr/share/dict/words")

-- Define autocmds for focus events
vim.api.nvim_create_augroup("FocusSafety", { clear = true })
