return {
    -- Plugin to make it easier to setup LSP integration into neovim
    {
        "VonHeikemen/lsp-zero.nvim",
        branch = "v3.x",
        lazy = true,
        config = false,
    },
    -- Setup LSP integration with nvim
    {
        "neovim/nvim-lspconfig",
        cmd = { "LspInfo", "LspInstall", "LspStart" },
        event = { "BufReadPre", "BufNewFile" },
        dependencies = {
            -- Allow neovim to easily install LSP
            { "williamboman/mason.nvim" },
            { "williamboman/mason-lspconfig.nvim" },
            -- Allow neovim to easily install linters and formatters
            {
                "nvimtools/none-ls.nvim",
                dependencies = {
                    "nvim-lua/plenary.nvim",
                },
            },
            -- Autocompletion
            { "L3MON4D3/LuaSnip" },
            { "hrsh7th/nvim-cmp" },
            { "hrsh7th/cmp-nvim-lsp" },
            { "hrsh7th/cmp-nvim-lua" },
            { "hrsh7th/cmp-buffer" },
            { "hrsh7th/cmp-path" },
            { "hrsh7th/cmp-cmdline" },
        },
        opt = {
            servers = {
                tsserver = {
                    root_dir = function(...)
                        return require("lspconfig.util").root_pattern(".git")(...)
                    end,
                }
            }
        },
        config = function()
            local lsp_zero = require("lsp-zero")
            ---@diagnostic disable-next-line: unused-local
            lsp_zero.on_attach(function(client, bufnr)
                -- see :help lsp-zero-keybindings
                -- to learn the available actions
                lsp_zero.default_keymaps({ buffer = bufnr })
            end)

            require("mason").setup()
            require("mason-lspconfig").setup {
                -- only install JDLS with mason, everything else is managed by nix
                ensure_installed = { "jdtls" },
            }
            local cmp_lsp = require("cmp_nvim_lsp")
            local capabilities = vim.tbl_deep_extend(
                "force",
                {},
                vim.lsp.protocol.make_client_capabilities(),
                cmp_lsp.default_capabilities()
            )

            local lspconfig = require("lspconfig")

            --Manually installed linters and formatters
            local null_ls = require("null-ls")

            null_ls.setup({
                sources = {
                    -- formatters
                    null_ls.builtins.formatting.shfmt.with({
                        filetypes = { "zsh", "bash", "sh" },
                    }),
                    null_ls.builtins.formatting.nixfmt,
                    null_ls.builtins.formatting.black,
                    null_ls.builtins.formatting.yamlfmt,
                    -- null_ls.builtins.formatting.prettierd.with({
                    --     filetypes = { "htmldjango", "json", "markdown" }
                    -- }),
                    null_ls.builtins.formatting.sqlfluff.with({
                        extra_args = {
                            "--dialect",
                            "postgres",
                        },
                    }),
                    null_ls.builtins.formatting.markdownlint,
                    -- linters
                    null_ls.builtins.diagnostics.ansiblelint,
                    null_ls.builtins.diagnostics.markdownlint,
                    null_ls.builtins.diagnostics.cfn_lint.with({
                        filetypes = { "yml", "yaml" },
                    }),
                },
            })

            --Manually installed LSP servers
            lspconfig.nil_ls.setup({})
            lspconfig.htmx.setup({})
            lspconfig.bashls.setup({
                filetypes = {
                    "bash",
                    "zsh",
                },
            })
            lspconfig.docker_compose_language_service.setup({})
            lspconfig.ansiblels.setup({})
            lspconfig.pyright.setup({
                capabilities = capabilities,
            })
            lspconfig.dockerls.setup({})

            -- TypeScript
            lspconfig.tsserver.setup({})

            lspconfig.lua_ls.setup({
                capabilities = capabilities,
                settings = {
                    Lua = {
                        diagnostics = {
                            globals = { "vim", "it", "describe", "before_each", "after_each" },
                        },
                    },
                },
            })
            lspconfig.unocss.setup {}

            local jsonls_capabilities = vim.lsp.protocol.make_client_capabilities()
            capabilities.textDocument.completion.completionItem.snippetSupport = true
            lspconfig.jsonls.setup {
                capabilities = jsonls_capabilities
            }

            -- Setup lsp autocompletion
            local cmp = require("cmp")
            local cmp_select = { behavior = cmp.SelectBehavior.Select }

            cmp.setup({
                snippet = {
                    expand = function(args)
                        require("luasnip").lsp_expand(args.body) -- For `luasnip` users.
                    end,
                },
                mapping = cmp.mapping.preset.insert({
                    ["<C-p>"] = cmp.mapping.select_prev_item(cmp_select),
                    ["<C-n>"] = cmp.mapping.select_next_item(cmp_select),
                    ["<C-y>"] = cmp.mapping.confirm({ select = true }),
                    ["<C-Space>"] = cmp.mapping.complete(),
                }),
                -- grouping of sources determines if a source is used,
                -- second group is only used if no values are found for the first group
                sources = cmp.config.sources({
                    { name = "nvim_lua" },
                    { name = "nvim_lsp", trigger_characters = { '-' } },
                }, {
                    { name = "path" },
                    { name = "crates" },
                    { name = "buffer", keyword_length = 5 },
                }, {
                }),
                sorting = {
                    -- yanked from teej https://github.com/tjdevries/config_manager/blob/78608334a7803a0de1a08a9a4bd1b03ad2a5eb11/xdg_config/nvim/after/plugin/completion.lua#L129
                    comparators = {
                        cmp.config.compare.offset,
                        cmp.config.compare.exact,
                        cmp.config.compare.score,
                        function(entry1, entry2)
                            local _, entry1_under = entry1.completion_item.label:find "^_+"
                            local _, entry2_under = entry2.completion_item.label:find "^_+"
                            entry1_under = entry1_under or 0
                            entry2_under = entry2_under or 0
                            if entry1_under > entry2_under then
                                return false
                            elseif entry1_under < entry2_under then
                                return true
                            end
                        end,

                        cmp.config.compare.kind,
                        cmp.config.compare.sort_text,
                        cmp.config.compare.length,
                        cmp.config.compare.order,
                    },
                },
                formatting = {
                    ---@diagnostic disable-next-line: unused-local
                    format = function(entry, vim_item)
                        vim_item.menu = ({
                            buffer = "[buf]",
                            nvim_lsp = "[LSP]",
                            nvim_lua = "[api]",
                            path = "[path]",
                            luasnip = "[snip]",
                            crates = "[crates]"
                            -- gh_issues = "[issues]",
                        })[entry.source.name]
                        return vim_item
                    end,
                },
            })

            -- Set nvim-cmp color scheme
            -- blue
            vim.api.nvim_set_hl(0, 'CmpItemAbbrMatch', { bg = 'NONE', fg = '#569CD6' })
            vim.api.nvim_set_hl(0, 'CmpItemAbbrMatchFuzzy', { link = 'CmpIntemAbbrMatch' })


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
        end,
    },
}
