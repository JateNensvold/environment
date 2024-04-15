return {
    {
        "folke/trouble.nvim",
        branch = "dev",
        config = function()
            require("trouble").setup({
                icons = false,
            })

            vim.keymap.set("n", "<leader>tt", "<cmd>Trouble diagnostics toggle<cr>")
            -- vim.keymap.set("n", "[t", function()
            --     require("trouble").next({ skip_groups = true, jump = true })
            -- end)
            --
            -- vim.keymap.set("n", "]t", function()
            --     require("trouble").previous({ skip_groups = true, jump = true })
            -- end)
        end,
    },
}
