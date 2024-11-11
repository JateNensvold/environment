function ColorMyPencils(color)
    -- This function shouldn't be needed, but for some reason when its present
    -- even without being called eyeliner highlight colors change
    color = color or "rose-pine"
    vim.cmd.colorscheme(color)
    -- vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
    -- vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
end

return {
    {
        "folke/tokyonight.nvim",
        config = function()
            require("tokyonight").setup({
                -- your configuration comes here
                -- or leave it empty to use the default settings
                style = "storm",    -- The theme comes in three styles, `storm`, `moon`, a darker variant `night` and `day`
                transparent = true, -- Enable this to disable setting the background color
                dim_inactive_windows = false,
                -- disable_background = true,
                terminal_colors = true, -- Configure the colors used when opening a `:terminal` in Neovim
                styles = {
                    -- Style to be applied to different syntax groups
                    -- Value is any valid attr-list value for `:help nvim_set_hl`
                    comments = { italic = false },
                    keywords = { italic = false },
                    -- Background styles. Can be "dark", "transparent" or "normal"
                    sidebars = "dark", -- style for sidebars, see below
                    floats = "dark",   -- style for floating windows
                },
            })
        end
    },
    {
        "rose-pine/neovim",
        name = "rose-pine",
        config = function()
            require('rose-pine').setup({
                styles = { transparency = true },
                -- https://github.com/neovim/neovim/issues/18576
                -- Neovim only supports fully or none opacity. When fixed upstream use the following command
                -- to change highlighting of non current windows so dim_inactive_windows can utilize semi transparent backgrounds
                -- https://neovim.io/doc/user/syntax.html#hl-NormalNC
                --     vim.api.nvim_set_hl(0, "NormalNC", { bg ="none", blend=40 })
                dim_inactive_windows = true,
                highlight_groups = {
                    NormalNC = { inherit = true, blend = 10 }
                }
            })

            vim.cmd.colorscheme("rose-pine")
            -- Deleting the following line changes highlight colors???
            -- ColorMyPencils()
        end
    },
}
