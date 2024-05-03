require("tosh-vim.remap")
require("tosh-vim.lazy_init")
require("tosh-vim.set")

local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

local ToshGroup = augroup("AutoTosh", {})
local yank_group = augroup("HighlightYank", {})

function R(name)
    require("plenary.reload").reload_module(name)
end

vim.filetype.add({
    extension = {
        templ = "templ",
    },
    filename = {
        ["docker-compose.yaml"] = "yaml.docker-compose",
        ["docker-compose.yml"] = "yaml.docker-compose",
    },
    pattern = {
        [".*yaml.ansible"] = "yaml.ansible",
        [".*"] = {
            priority = -math.huge,
            ---@diagnostic disable-next-line: unused-local
            function(path, bufnr)
                local content = vim.filetype.getlines(bufnr, 1)
                if vim.filetype.matchregex(content, [[^#!.*bash]]) then
                    return 'bash'
                end
            end,
        }
    }
})

autocmd("TextYankPost", {
    group = yank_group,
    pattern = "*",
    callback = function()
        vim.highlight.on_yank({
            higroup = "IncSearch",
            timeout = 100,
        })
    end,
})

autocmd({ "BufWritePre" }, {
    group = ToshGroup,
    pattern = "*",
    command = [[%s/\s\+$//e]],
})



---@param key string
---@param direction "next"|"prev"
---@param severity string?
---@param bufnr number
local function diagnostic_goto(key, direction, severity, bufnr)
    local go = direction == "next" and vim.diagnostic.goto_next or vim.diagnostic.goto_prev
    severity = severity or nil
    vim.keymap.set(
        "n",
        key,
        function() go({ severity = severity }) end,
        { silent = true, buffer = bufnr }
    )
end



local function show_documentation()
    local filetype = vim.bo.filetype
    if vim.tbl_contains({ 'vim', 'help' }, filetype) then
        vim.cmd('h ' .. vim.fn.expand('<cword>'))
    elseif vim.tbl_contains({ 'man' }, filetype) then
        vim.cmd('Man ' .. vim.fn.expand('<cword>'))
    elseif vim.fn.expand('%:t') == 'Cargo.toml' and require('crates').popup_available() then
        require('crates').show_popup()
    else
        vim.lsp.buf.hover()
    end
end


autocmd("LspAttach", {
    group = ToshGroup,
    callback = function(e)
        local opts = { buffer = e.buf }
        vim.keymap.set("n", "gd", function()
            vim.lsp.buf.definition()
        end, opts)
        vim.keymap.set("n", "K", function()
            show_documentation()
        end, opts)
        vim.keymap.set("n", "<leader>vws", function()
            vim.lsp.buf.workspace_symbol()
        end, opts)
        vim.keymap.set("n", "<leader>vd", function()
            vim.diagnostic.open_float()
        end, opts)
        vim.keymap.set("n", "<leader>vca", function()
            vim.lsp.buf.code_action()
        end, opts)
        vim.keymap.set("n", "<leader>vrr", function()
            vim.lsp.buf.references()
        end, opts)
        vim.keymap.set("n", "<leader>vrn", function()
            vim.lsp.buf.rename()
        end, opts)
        vim.keymap.set("i", "<C-h>", function()
            vim.lsp.buf.signature_help()
        end, opts)
        diagnostic_goto("[d", "next", nil, e.bufnr)
        diagnostic_goto("]d", "prev", nil, e.bufnr)
        diagnostic_goto("[e", "next", vim.diagnostic.severity.ERROR, e.bufnr)
        diagnostic_goto("]e", "prev", vim.diagnostic.severity.ERROR, e.bufnr)
    end,
})

vim.g.netrw_browse_split = 0
vim.g.netrw_banner = 0
vim.g.netrw_winsize = 25
