local M = require "utils.functions"
return {
    "nvim-telescope/telescope.nvim",
    branch = "0.1.x",
    dependencies = {
        "nvim-lua/plenary.nvim",
        "folke/trouble.nvim",
        {
            "nvim-telescope/telescope-fzf-native.nvim",
            build =
            "cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build",
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

        require("telescope").load_extension("live_grep_args")

        local live_grep_args = telescope.extensions.live_grep_args
        local live_grep_args_shortcuts = require("telescope-live-grep-args.shortcuts")

        local function live_grep_args_from_project_git_root(opts)
            local default_opts = M.default(opts, {})
            if M.is_git_repo() then
                default_opts.cwd = M.get_git_root()
            end
            live_grep_args.live_grep_args(default_opts)
        end

        local function visual_live_grep_args_from_project_git_root(opts)
            local default_opts = M.default(opts, {})
            if M.is_git_repo() then
                default_opts.cwd = M.get_git_root()
            end
            live_grep_args_shortcuts.grep_visual_selection(default_opts)
        end

        local function word_live_grep_args_from_project_git_root(opts)
            local default_opts = M.default(opts, {})
            if M.is_git_repo() then
                default_opts.cwd = M.get_git_root()
            end
            live_grep_args_shortcuts.grep_word_under_cursor(default_opts)
        end

        local function find_files_from_project_git_root(opts)
            local default_opts = M.default(opts, {})
            if M.is_git_repo() then
                default_opts.cwd = M.get_git_root()
            end
            require("telescope.builtin").find_files(default_opts)
        end

        local builtin = require("telescope.builtin")

        -- find files
        vim.keymap.set("n", "<C-p>", find_files_from_project_git_root)
        vim.keymap.set("n", "<leader>phf", function()
            find_files_from_project_git_root({ hidden = true, no_ignore = true })
        end)
        vim.keymap.set("n", "<leader>pf", builtin.git_files, {})

        -- project commands
        vim.keymap.set("n", "<leader>ps", live_grep_args_from_project_git_root, {})
        vim.keymap.set("n", "<leader>ws", word_live_grep_args_from_project_git_root, {})
        vim.keymap.set("v", "<leader>vs", visual_live_grep_args_from_project_git_root, {})
        vim.keymap.set("n", "<leader>pb", function()
            builtin.buffers({ sort_mru = true, ignore_current_buffer = true })
        end, {})

        -- diagnostic files
        vim.keymap.set("n", "<leader>td", function()
            builtin.diagnostics({ bufnr = 0 })
        end, {})
        vim.keymap.set("n", "<leader>te", function()
            builtin.diagnostics({ severity = vim.diagnostic.severity.ERROR, bufnr = 0 })
        end, {})
        vim.keymap.set("n", "<leader>ts", function()
            builtin.diagnostics()
        end, {})
        vim.keymap.set("n", "<leader>tl", function()
            builtin.diagnostics({ severity = vim.diagnostic.severity.ERROR })
        end, {})

        -- misc telescope commands
        vim.keymap.set("n", "<leader>vh", builtin.help_tags, {})
    end,
}