return {
    "saecki/crates.nvim",
    tag = "stable",
    config = function()
        require("crates").setup()
        require("cmp").setup.buffer({
            sources = {
                { name = "crates" },
            },
        })
    end,
}
