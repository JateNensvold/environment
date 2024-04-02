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

        local function is_git_repo()
            vim.fn.system("git rev-parse --is-inside-work-tree")
            return vim.v.shell_error == 0
        end
        local function get_git_root()
            local dot_git_path = vim.fn.finddir(".git", ".;")
            return vim.fn.fnamemodify(dot_git_path, ":h")
        end

        local neo_command = require("neo-tree.command")

        -- Open vim file tree
        vim.keymap.set("n", "<leader>pv", function()
            local cwd = vim.fn.getcwd()
            if is_git_repo() then
                cwd = get_git_root()
            end

            local reveal_file = vim.fn.expand("%:p")
            print(reveal_file)

            neo_command.execute({
                action = "focus",
                position = "current",
                source = "filesystem",
                reveal_file = reveal_file,
                reveal = true,
                -- reveal_force_cwd = true,
                dir = cwd,
            })
        end)
        -- vim.keymap.set("n", "<leader>pv", "<cmd>Neotree dir=%:p:h:h position=current<CR>")
        -- vim.keymap.set("n", "<leader>pb", "<cmd>Neotree position=current source=buffers<CR>")
        -- vim.keymap.set("n", "<leader>gd", "<cmd>Neotree float reveal_file=<cfile> reveal_force_cwd<CR>")
    end,
}
