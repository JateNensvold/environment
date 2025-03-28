return { -- using packer.nvim
	'nmac427/guess-indent.nvim',
	config = function()
		local guess_indent = require('guess-indent')
		guess_indent.setup({
			filetype_exclude = {
				"java",
				"kotlin"
			}
		})
	end,
}
