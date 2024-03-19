return {
    -- Plugin to make it easier to setup LSP integration into neovim
    {
        'VonHeikemen/lsp-zero.nvim',
        branch = 'v3.x',
        lazy = true,
        config = false,
    },


    -- Setup LSP integration with nvim
    {
        'neovim/nvim-lspconfig',
        cmd = { 'LspInfo', 'LspInstall', 'LspStart' },
        event = { 'BufReadPre', 'BufNewFile' },
        dependencies = {
            -- Allow neovim to easily install LSP
            { 'williamboman/mason.nvim' },
            -- A bridge between mason.nvim and lspconfig so they can be used together
            --      - Adds name translation between lspconfig and Mason
            --      - Adds Automatic install of translated lsp-servers for lspconfig
            { 'williamboman/mason-lspconfig.nvim' },
            -- Allow neovim to easily install linters and formatters
            {
                'nvimtools/none-ls.nvim',
                dependencies = {
                    "nvim-lua/plenary.nvim"
                }
            },
            -- A bridge between mason.nvim and null-ls so they can be used together
            --      - Adds name translation between null-ls and Mason
            --      - Adds Automatic install of translated formatters and linters for null-ls
            { 'jay-babu/mason-null-ls.nvim' },
            -- Autocompletion
            { 'L3MON4D3/LuaSnip' },
            { 'hrsh7th/nvim-cmp' },
            { 'hrsh7th/cmp-nvim-lsp' },
            { "hrsh7th/cmp-buffer" },
            { "hrsh7th/cmp-path" },
            { "hrsh7th/cmp-cmdline" },
            -- UI for neovim notifiactions and LSP messages
            { "j-hui/fidget.nvim" }
        },
        config = function()
            local lsp_zero = require('lsp-zero')
            lsp_zero.on_attach(function(client, bufnr)
                -- see :help lsp-zero-keybindings
                -- to learn the available actions
                lsp_zero.default_keymaps({ buffer = bufnr })
            end)

            local null_ls = require("null-ls")
            null_ls.setup({
                sources = {
                    null_ls.builtins.formatting.stylua,
                    -- null_ls.builtins.diagnostics.eslint,
                    null_ls.builtins.completion.spell,
                },
            })
            require('mason').setup()
            require("mason-null-ls").setup({
                ensure_installed = { "shfmt" },
                handlers = {}
            })

            local cmp_lsp = require("cmp_nvim_lsp")
            local capabilities = vim.tbl_deep_extend(
                "force",
                {},
                vim.lsp.protocol.make_client_capabilities(),
                cmp_lsp.default_capabilities())

            require('mason-lspconfig').setup({
                -- Preinstall LSP servers here
                ensure_installed = {},
                handlers = {
                    function(server_name) -- default handler (optional)
                        require("lspconfig")[server_name].setup {
                            capabilities = capabilities
                        }
                    end,

                    ["lua_ls"] = function()
                        local lspconfig = require("lspconfig")
                        lspconfig.lua_ls.setup {
                            capabilities = capabilities,
                            settings = {
                                Lua = {
                                    diagnostics = {
                                        globals = { "vim", "it", "describe", "before_each", "after_each" },
                                    }
                                }
                            }
                        }
                    end,
                }
            })

            -- Setup lsp autocompletion
            local cmp = require('cmp')
            local cmp_select = { behavior = cmp.SelectBehavior.Select }

            cmp.setup({
                snippet = {
                    expand = function(args)
                        require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
                    end,
                },
                mapping = cmp.mapping.preset.insert({
                    ['<C-p>'] = cmp.mapping.select_prev_item(cmp_select),
                    ['<C-n>'] = cmp.mapping.select_next_item(cmp_select),
                    ['<C-y>'] = cmp.mapping.confirm({ select = true }),
                    ["<C-Space>"] = cmp.mapping.complete(),
                }),
                sources = cmp.config.sources({
                    { name = 'nvim_lsp' },
                    { name = 'luasnip' }, -- For luasnip users.
                }, {
                    { name = 'buffer' },
                })
            })

            vim.diagnostic.config({
                -- update_in_insert = true,
                float = {
                    focusable = false,
                    style = "minimal",
                    border = "rounded",
                    source = "always",
                    header = "",
                    prefix = "",
                },
            })
        end
    }
}
