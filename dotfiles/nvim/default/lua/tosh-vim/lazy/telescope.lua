local M = require "utils.functions"
return {
    "nvim-telescope/telescope.nvim",
    branch = "0.1.x",
    dependencies = {
        "nvim-lua/plenary.nvim",
        "folke/trouble.nvim",
        {
            "nvim-telescope/telescope-fzf-native.nvim",
            build = "make",
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
        local actions = require('telescope.actions')
        local builtin = require('telescope.builtin')
        local lga_actions = require("telescope-live-grep-args.actions")

        local transform_mod = require("telescope.actions.mt").transform_mod
        local local_actions = setmetatable({}, {
            __index = function(_, k)
                error("Key does not exist for 'telescope.local_actions': " .. tostring(k))
            end,
        })

        local_actions.open_qfix = function(_)
            builtin.quickfix()
        end
        local_actions = transform_mod(local_actions)
        local qfix = actions.send_to_qflist + local_actions.open_qfix

        telescope.setup({
            defaults = {
                preview = {
                    filesize_hook = function(filepath, bufnr, opts)
                        local max_bytes = 10000
                        local cmd = { "head", "-c", max_bytes, filepath }
                        require('telescope.previewers.utils').job_maker(cmd, bufnr, opts)
                    end
                },
                mappings = {
                    n = {
                        ["<C-c>"] = actions.close,
                    },
                    i = {
                        ["<C-c>"] = false,
                        ["<C-q>"] = qfix,
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
            builtin.find_files(default_opts)
        end

        -- find files
        vim.keymap.set("n", "<C-p>", find_files_from_project_git_root)
        vim.keymap.set("n", "<leader>ph", function()
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
        end, { desc = "Open diagnostic for buffer" })
        vim.keymap.set("n", "<leader>te", function()
            builtin.diagnostics({ severity = vim.diagnostic.severity.ERROR, bufnr = 0 })
        end, { desc = "Open errors for buffer" })
        vim.keymap.set("n", "<leader>tb", function()
            builtin.diagnostics()
        end, { desc = "Open diagnostic for project" })
        vim.keymap.set("n", "<leader>tp", function()
            builtin.diagnostics({ severity = vim.diagnostic.severity.ERROR })
        end, { desc = "Open errors for project" })

        vim.keymap.set("n", "<leader>q", function()
            builtin.quickfix()
            vim.cmd(":cclose")
        end, { desc = "Open Quickfix (Telescope)" })

        -- misc telescope commands
        vim.keymap.set("n", "<leader>vh", builtin.help_tags, { desc = "Open vim help" })
    end,
}
