local vim = vim

vim.pack.add({
	"https://github.com/nvim-lua/plenary.nvim",
	"https://github.com/MunifTanjim/nui.nvim",
	"https://github.com/kawre/leetcode.nvim",
})

vim.keymap.set("n", "<leader>lr", ":Leet run<CR>", { desc = "Leet: run" })
vim.keymap.set("n", "<leader>ls", ":Leet submit<CR>", { desc = "Leet: submit" })

require("leetcode").setup({
	lang = "python3",
	hooks = {
		-- when entering a problem, close any other tabs that only hold
		-- an empty unnamed buffer (e.g. the initial scratch tab)
		question_enter = {
			function()
				local cur = vim.fn.tabpagenr()
				for i = vim.fn.tabpagenr("$"), 1, -1 do
					if i ~= cur then
						local bufs = vim.fn.tabpagebuflist(i)
						if #bufs == 1 then
							local buf = bufs[1]
							if vim.api.nvim_buf_get_name(buf) == "" and not vim.bo[buf].modified then
								vim.cmd(i .. "tabclose")
							end
						end
					end
				end
			end,
		},
	},
})
