return {
	"nvim-neotest/neotest",
	dependencies = {
		"nvim-neotest/nvim-nio",
		"nvim-lua/plenary.nvim",
		"antoinemadec/FixCursorHold.nvim",
		"nvim-treesitter/nvim-treesitter"
	},
	config = function()
		local neotest = require("neotest")
		-- run current test
		vim.keymap.set("n", "<leader>tt", function()
			neotest.run.run()
		end, {})

		-- Run file
		vim.keymap.set("n", "<leader>tf", function()
			neotest.run.run(vim.fn.expand("%"))
		end, {})

		neotest.setup({
		-- 	adapters = {
		-- 		-- require("neotest-java")({
		-- 		-- 	ignore_wrapper = false, -- whether to ignore maven/gradle wrapper
		-- 		-- 	junit_jar = nil,
		-- 		-- 	-- default: .local/share/nvim/neotest-java/junit-platform-console-standalone-[version].jar
		-- 		-- })
		-- 	}
		})
	end,
}
