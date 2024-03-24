return {
	"nvim-neo-tree/neo-tree.nvim",
	branch = "v3.x",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
		"MunifTanjim/nui.nvim",
		-- "3rd/image.nvim", -- Optional image support in preview window: See `# Preview Mode` for more information
	},
	config = function()
		require("neo-tree").setup({
			filesystem = {
				hijack_netrw_behavior = "open_current",
				window = {
					mappings = {
						["D"] = "delete",
						["d"] = "none",
						["-"] = "navigate_up",
						["Z"] = "expand_all_nodes",
						["Y"] = {
							function(state)
								local node = state.tree:get_node()
								local path = node:get_id()
								print(path)
								vim.fn.setreg("+", path, "c")
							end,
							desc = "copy path to clipboard",
						},
					},
				},
			},
		})
	end,
}
