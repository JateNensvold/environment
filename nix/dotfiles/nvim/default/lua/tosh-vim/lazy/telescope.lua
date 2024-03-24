return {
	"nvim-telescope/telescope.nvim",
	tag = "0.1.5",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"folke/trouble.nvim",
		{
			"nvim-telescope/telescope-fzf-native.nvim",
			build = "cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build",
		},
	},
	config = function()
		require("telescope").setup({
			-- actions = require("telescope.actions"),

			defaults = {
				preview = {
					filesize_limit = 0.2, -- MB
				},
				mappings = {
					n = {
						["<C-c>"] = require("telescope.actions").close,
					},
					i = {
						["<C-c>"] = false,
					},
				},
			},
		})

		---@diagnostic disable-next-line: lowercase-global
		function live_grep_from_project_git_root(opts)
			local function is_git_repo()
				vim.fn.system("git rev-parse --is-inside-work-tree")
				return vim.v.shell_error == 0
			end
			local function get_git_root()
				local dot_git_path = vim.fn.finddir(".git", ".;")
				return vim.fn.fnamemodify(dot_git_path, ":h")
			end
			if is_git_repo() then
				opts.cwd = get_git_root()
			end
			require("telescope.builtin").live_grep(opts)
		end

		---@diagnostic disable-next-line: lowercase-global
		function find_files_from_project_git_root(opts)
			local function is_git_repo()
				vim.fn.system("git rev-parse --is-inside-work-tree")
				return vim.v.shell_error == 0
			end
			local function get_git_root()
				local dot_git_path = vim.fn.finddir(".git", ".;")
				return vim.fn.fnamemodify(dot_git_path, ":h")
			end
			if is_git_repo() then
				opts.cwd = get_git_root()
			end
			require("telescope.builtin").find_files(opts)
		end

		local builtin = require("telescope.builtin")
		vim.keymap.set("n", "<leader>pf", function()
			find_files_from_project_git_root({}) -- Find hidden files
		end)
		vim.keymap.set("n", "<leader>ph", function()
			find_files_from_project_git_root({ hidden = true, no_ignore = true }) -- Find hidden files
		end)
		vim.keymap.set("n", "<C-p>", builtin.git_files, {})
		vim.keymap.set("n", "<leader>pg", function()
			live_grep_from_project_git_root({})
		end)
		vim.keymap.set("n", "<leader>ps", function()
			live_grep_from_project_git_root({ hidden = true, no_ignore = true }) -- Grep (root dir)
		end)
		vim.keymap.set("n", "<leader>mm", "<cmd>Telescope noice<CR>")
	end,
}
