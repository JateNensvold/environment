local M = require("utils.functions")
return {
    "nvim-tree/nvim-tree.lua",
    version = "*",
    lazy = false,
    dependencies = {
        "nvim-tree/nvim-web-devicons",
    },
    config = function()
        local HEIGHT_RATIO = 0.8 -- You can change this
        local WIDTH_RATIO = 0.5  -- You can change this too

        local api = require("nvim-tree.api")
        local function on_attach(bufnr)
            local function opts(desc)
                return { desc = 'nvim-tree: ' .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
            end
            api.config.mappings.default_on_attach(bufnr)
            vim.keymap.set('n', '?', api.tree.toggle_help, opts('Help'))
            -- vim.keymap.set('n', '<C-c>', api.tree.close, opts('Close'))
            -- vim.keymap.set('n', '<esc>', api.tree.close, opts('Close'))
            --
            -- move file
            -- mark file with 'm', move marked files with 'bmv'

            -- Remove keybinds
            vim.keymap.del('n', 'D', { buffer = bufnr })
            vim.keymap.del('n', '<C-e>', { buffer = bufnr })
        end

        local function toggle_tree_repo_root(config)
            if M.is_git_repo() then
                config.path = M.get_git_root()
            end
            api.tree.toggle(config)
        end

        -- Custom Mappings
        vim.keymap.set('n', "<leader>pv", function()
            toggle_tree_repo_root({ find_file = true, desc = 'nvim-tree: View directory' })
        end)
        vim.keymap.set('n', "<leader>pp", function()
            api.tree.toggle({ find_file = true, desc = 'nvim-tree: View project' })
        end)

        require('nvim-tree').setup({
            on_attach = on_attach,
            view = {
                float = {
                    enable = true,
                    open_win_config = function()
                        local screen_w = vim.opt.columns:get()
                        local screen_h = vim.opt.lines:get() - vim.opt.cmdheight:get()
                        local window_w = screen_w * WIDTH_RATIO
                        local window_h = screen_h * HEIGHT_RATIO
                        local window_w_int = math.floor(window_w)
                        local window_h_int = math.floor(window_h)
                        local center_x = (screen_w - window_w) / 2
                        local center_y = ((vim.opt.lines:get() - window_h) / 2)
                            - vim.opt.cmdheight:get()
                        return {
                            border = 'rounded',
                            relative = 'editor',
                            row = center_y,
                            col = center_x,
                            width = window_w_int,
                            height = window_h_int,
                        }
                    end,
                    quit_on_focus_loss = false
                },
                width = function()
                    return math.floor(vim.opt.columns:get() * WIDTH_RATIO)
                end,
            },
            actions = {
                open_file = {
                    quit_on_open = true
                }
            }
        })
    end,
}
