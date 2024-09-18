return {
  'akinsho/git-conflict.nvim',
  version = "*",
  config = function()
        require('git-conflict').setup({
            list_opener = function()
                local builtin = require('telescope.builtin')
                builtin.quickfix()
                vim.cmd(":cclose")
            end
        })
        vim.keymap.set('n', '<leader>gr', "<cmd>:GitConflictRefresh<CR>")
        vim.keymap.set('n', '<leader>gq', '<Cmd>GitConflictListQf<CR>')
        -- default mappings
        --    vim.keymap.set('n', 'co', '<Plug>(git-conflict-ours)')
        --    vim.keymap.set('n', 'ct', '<Plug>(git-conflict-theirs)')
        --    vim.keymap.set('n', 'cb', '<Plug>(git-conflict-both)')
        --    vim.keymap.set('n', 'c0', '<Plug>(git-conflict-none)')
        --    vim.keymap.set('n', '[x', '<Plug>(git-conflict-prev-conflict)')
        --    vim.keymap.set('n', ']x', '<Plug>(git-conflict-next-conflict)')
    end,
}
