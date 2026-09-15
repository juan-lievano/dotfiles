local vim = vim

-- UI / editor opts
vim.o.number = true
vim.o.relativenumber = true
vim.o.wrap = false
vim.o.tabstop = 4
vim.o.swapfile = false
vim.o.winborder = "rounded"
vim.opt.clipboard = "unnamedplus"

-- searching: case insensitive until the pattern has an uppercase letter
-- (smartcase only does anything with ignorecase on)
vim.o.ignorecase = true
vim.o.smartcase = true

-- :grep uses ripgrep: recursive from the cwd, skips .gitignore'd files and
-- hidden dirs, works with or without a git repo. --follow descends into
-- symlinked dirs (e.g. ~/.config/nvim -> ~/dotfiles). --smart-case mirrors the
-- ignorecase/smartcase settings above. Results land in the quickfix list.
vim.o.grepprg = "rg --vimgrep --smart-case --follow"
vim.o.grepformat = "%f:%l:%c:%m"

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

-- Absolute line numbers while typing a `:` command, relative otherwise.
-- Flip relativenumber off on cmdline enter (and redraw, since the buffer won't
-- repaint on its own mid-command) and back on on leave.
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

-- Ctrl-P/Ctrl-N to scroll command-line history (like readline)
vim.keymap.set("c", "<C-p>", "<Up>", { noremap = true })
vim.keymap.set("c", "<C-n>", "<Down>", { noremap = true })

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

-- colors/terminal.lua names ANSI slots only (no hexes, notermguicolors), so
-- nvim, mini.pick, ls and the zsh prompt all draw from the one palette
-- Ghostty holds (themes/from-image, written by `termbg IMAGE`). Was: slate +
-- ~30 hex overrides (see git history before 2026-09-15).
vim.cmd("colorscheme terminal")

-- dictionary and spelling stuff
-- vim.opt.spell = true
-- vim.opt.spelllang = "es,en" -- spanish, english
-- system word list (used by i_CTRL-X_CTRL-K dictionary completion)
vim.opt.dictionary:append("/usr/share/dict/words")

-- Define autocmds for focus events
vim.api.nvim_create_augroup("FocusSafety", { clear = true })
