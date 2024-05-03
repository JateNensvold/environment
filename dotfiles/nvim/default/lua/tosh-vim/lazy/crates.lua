return {
    "saecki/crates.nvim",
    tag = "stable",
    config = function()
        local crates = require("crates")
        local opts = { silent = true }

        crates.setup {
            null_ls = {
                enabled = true,
                name = "crates.nvim",
            },
            on_attach = function(buffnr)
                vim.keymap.set("n", "<leader>ct", crates.toggle, opts)
                vim.keymap.set("n", "<leader>cr", crates.reload, opts)

                vim.keymap.set("n", "<leader>cv", crates.show_versions_popup, opts)
                vim.keymap.set("n", "<leader>cf", crates.show_features_popup, opts)
                vim.keymap.set("n", "<leader>cd", crates.show_dependencies_popup, opts)
            end
        }
        require("cmp").setup.buffer({
            sources = {
                { name = "crates" },
            },
        })
    end,
}
