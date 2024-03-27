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
		{
			"nvim-telescope/telescope-live-grep-args.nvim",
			-- This will not install any breaking changes.
			-- For major updates, this must be adjusted manually.
			version = "^1.0.0",
		},
	},
	config = function()
		local telescope = require("telescope")
		local lga_actions = require("telescope-live-grep-args.actions")

		require("telescope").load_extension("live_grep_args")
		telescope.setup({
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
			extensions = {
				live_grep_args = {
					auto_quoting = true, -- enable/disable auto-quoting
					mappings = {
						i = {
							["<C-k>"] = lga_actions.quote_prompt(),
							["<C-i>"] = lga_actions.quote_prompt({ postfix = " --iglob " }),
						},
					},
				},
			},
		})

		local live_grep_args = telescope.extensions.live_grep_args

		local function is_git_repo()
			vim.fn.system("git rev-parse --is-inside-work-tree")
			return vim.v.shell_error == 0
		end

		local function get_git_root()
			local dot_git_path = vim.fn.finddir(".git", ".;")
			return vim.fn.fnamemodify(dot_git_path, ":h")
		end

		local function live_grep_args_from_project_git_root(opts)
			if is_git_repo() then
				opts.cwd = get_git_root()
			end
			live_grep_args.live_grep_args(opts)
		end

		local function find_files_from_project_git_root(opts)
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
		vim.keymap.set("n", "<leader>ps", function()
			live_grep_args_from_project_git_root({})
		end)
		vim.keymap.set("n", "<leader>mm", "<cmd>Telescope noice<CR>")
	end,
}
