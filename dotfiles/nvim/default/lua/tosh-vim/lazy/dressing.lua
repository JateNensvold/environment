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
    end
}
