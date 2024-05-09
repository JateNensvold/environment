return {
    "Exafunction/codeium.vim",
    event = 'BufEnter',
    config = function()
        vim.keymap.set('i', '<C-y>', function() return vim.fn['codeium#Accept']() end, { expr = true, silent = true })
        vim.keymap.set('i', '<C-n>', function() return vim.fn['codeium#CycleCompletions'](1) end,
            { expr = true, silent = true })
        vim.keymap.set('i', '<C-p>', function() return vim.fn['codeium#CycleCompletions'](-1) end,
            { expr = true, silent = true })
        -- vim.keymap.set('i', '<C-h>', function() return vim.fn['codeium#Clear']() end, { expr = true, silent = true })
        -- c-h doesnt work
        vim.keymap.set('i', '<C-l>', function() return vim.fn['codeium#Complete']() end, {})
        vim.g.codeium_disable_bindings = 1
        vim.g.codeium_manual = true
    end
}
