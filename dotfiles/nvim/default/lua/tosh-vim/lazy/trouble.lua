return {
    "folke/trouble.nvim",
    keys = {
        {
            "<leader>tt",
            "<cmd>Trouble diagnostics toggle<cr>",
            desc = "Diagnostics (Trouble)",
        },
        -- {
        --     "<leader>qq",
        --     "<cmd>Trouble telescope toggle<cr>",
        --     desc = "Quickfix List (Trouble)",
        -- },
        -- {
        --     "[t",
        --     "<cmd>lua require(\"trouble\").next({ mode = \"diagnostic\", skip_groups = true, jump = true })<cr>",
        --     desc = "Quickfix List (Trouble)",
        -- },
        -- {
        --     "]t",
        --     "<cmd>lua require(\"trouble\").prev({ mode = \"diagnostic\", skip_groups = true, jump = true })<cr>",
        --     desc = "Quickfix List (Trouble)",
        -- },
        -- {
        --     "<C-j>",
        --     "<cmd>lua require(\"trouble\").next({ mode = \"qflist\", skip_groups = true, jump = true })<cr>",
        --     desc = "Quickfix List (Trouble)",
        -- },
        -- {
        --     "<C-k>",
        --     "<cmd>lua require(\"trouble\").prev({ mode = \"qflist\", skip_groups = true, jump = true })<cr>",
        --     desc = "Quickfix List (Trouble)",
        -- },
    },
    opts = {},
    modes = {
        test = {
            mode = "diagnostics",
            preview = {
                type = "split",
                relative = "win",
                position = "right",
                size = 0.3,
            },
        },
    },
}
