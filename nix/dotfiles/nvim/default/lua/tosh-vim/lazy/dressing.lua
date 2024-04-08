return {
    "stevearc/dressing.nvim",
    opts = {},
    config = function()
        require("dressing").setup({
            input = {
                insert_only = false,
                mappings = {
                    n = {
                        ["<C-c>"] = "Cancel",
                    },
                    i = {
                        -- dressing does not support remapping C-c to enter normal mode, an autocommand is required
                        -- ["<C-c>"] = "<Plug>DressingInput:Close",
                    },
                }
            }
        })
        -- vim.api.nvim_create_autocmd("FileType", {
        --     local augroup = vim.api.nvim_create_augroup("AutoNvimTree", {})
        --     ---@diagnostic disable-next-line: undefined-global
        --     group = augroup,
        --     pattern = { "DressingInput" },
        --     desc = "Exit Nvim-Tree",
        --     callback = {
        --         -- vim.api.nvim_buf_del_keymap(0, "i", "C-c"),
        --         vim.api.nvim_buf_set_keymap(0, "i", "C-c", "<Esc>", {})
        --     },
        -- })
        -- au FileType DressingInput lua vim.api.nvim_buf_del_keymap(0, "i", "<C-c>"); vim.api.nvim_buf_set_keymap(0, "i", "<C-c>", "<Esc>", {})
    end
}
