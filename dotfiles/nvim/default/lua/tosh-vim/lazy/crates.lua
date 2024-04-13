return {
	"saecki/crates.nvim",
	tag = "stable",
	config = function()
		require("crates").setup({

			null_ls = {
				enabled = true,
				name = "creates.nvim",
			},
		})
	end,
}
