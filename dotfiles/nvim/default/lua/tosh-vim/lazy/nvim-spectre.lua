return {
	"nvim-pack/nvim-spectre",
	config = function()
		vim.keymap.set("n", "<leader>sw", '<cmd>lua require("spectre").open_visual({select_word=true})<CR>', {
			desc = "Specter: Search current word",
		})
		vim.keymap.set("v", "<leader>sw", '<esc><cmd>lua require("spectre").open_visual()<CR>', {
			desc = "Specter: Search current word",
		})
		vim.keymap.set("n", "<leader>sf", '<cmd>lua require("spectre").open_file_search({select_word=true})<CR>', {
			desc = "Specter: Search on current file",
		})
		vim.keymap.set("v", "<leader>sf", ':lua require("spectre").open_file_search()<CR>', {
			desc = "Specter: Search on current file",
		})
	end,
}
