return {
	'MeanderingProgrammer/render-markdown.nvim',
	dependencies = { 'nvim-treesitter/nvim-treesitter', 'echasnovski/mini.nvim' }, -- if you use the mini.nvim suite
	-- dependencies = { 'nvim-treesitter/nvim-treesitter', 'echasnovski/mini.icons' }, -- if you use standalone mini plugins
	-- dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-tree/nvim-web-devicons' }, -- if you prefer nvim-web-devicons
	---@module 'render-markdown'
	---@type render.md.UserConfig
	opts = {},
	config = function()
		-- Define color variables
		local color1_bg = "#22223B"
		local color2_bg = "#4A4E69"
		local color3_bg = "#9A8C98"
		local color4_bg = "#C9ADA7"
		local color5_bg = "#F2E9E4"
		local color6_bg = "#f7c67f"
		local color_fg = "#323449"


		-- Heading colors (when not hovered over), extends through the entire line
		vim.cmd(string.format([[highlight Headline1Bg guifg=%s guibg=%s]], color_fg, color1_bg))
		vim.cmd(string.format([[highlight Headline2Bg guifg=%s guibg=%s]], color_fg, color2_bg))
		vim.cmd(string.format([[highlight Headline3Bg guifg=%s guibg=%s]], color_fg, color3_bg))
		vim.cmd(string.format([[highlight Headline4Bg guifg=%s guibg=%s]], color_fg, color4_bg))
		vim.cmd(string.format([[highlight Headline5Bg guifg=%s guibg=%s]], color_fg, color5_bg))
		vim.cmd(string.format([[highlight Headline6Bg guifg=%s guibg=%s]], color_fg, color6_bg))

		require('render-markdown').setup({
			heading = {
				-- left_pad = 2,
				-- left_margin = 2;
				border = true,
				position = "inline",
				-- Highlight for the heading icon and extends through the entire line
				backgrounds = {
					"Headline1Bg",
					"Headline2Bg",
					"Headline3Bg",
					"Headline4Bg",
					"Headline5Bg",
					"Headline6Bg",
				},
			},
			indent = {
				enabled = true,
				per_level = 5
			}
		})
		-- vim.keymap.set("n", "c-r", require('render-markdown').buf_toggle())
	end
}
