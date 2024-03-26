return {
    {
        "nathom/filetype.nvim",
        config = function()
            require("filetype").setup({
                overrides = {
                    shebang = {
                        zsh = "bash",
                        bash = "bash",
                    },
                },
            })
        end,
    },
}
