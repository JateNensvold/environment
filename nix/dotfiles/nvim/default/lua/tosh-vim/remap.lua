vim.g.mapleader = " "

-- Moves highlighted lines up and down
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

-- C-i and Tab both send U+0009 https://unix.stackexchange.com/questions/563469/conflict-ctrl-i-with-tab-in-normal-mode
-- Remapping C-n to C-i before remapping Tab on the next line
vim.keymap.set("n", "<C-n>", "<C-i>")

-- change line indent
vim.keymap.set("v", "<Tab>", ">gv")
vim.keymap.set("v", "<S-Tab>", "<gv")

-- jump to start and end of current text
vim.keymap.set({ "n", "o" }, "<S-H>", "^")
vim.keymap.set({ "n", "o" }, "<S-L>", "$")
vim.keymap.set("v", "<S-H>", "^")
vim.keymap.set("v", "<S-L>", "$")

-- Merge line below cursor with current line while maintaining cursor position
vim.keymap.set("n", "J", "mzJ`z")

-- keep cursor in middle of screen when jumping around
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

-- Copy text that is pasted over into vim register
vim.keymap.set("x", "<leader>p", [["_dP]])

-- Yank into system clipboard - asbjornHaland
vim.keymap.set({ "n", "v" }, "<leader>y", [["+y]])
vim.keymap.set("n", "<leader>Y", [["+Y]])
-- delete into system register
vim.keymap.set({ "n", "v" }, "<leader>d", [["_d]])

-- This is going to get me cancelled
-- Allow ctrl-c to exit insert mode
vim.keymap.set("i", "<C-c>", "<Esc>")

-- Remove EX mode
vim.keymap.set("n", "Q", "<nop>")
-- Open new tmux pane
vim.keymap.set("n", "<C-f>", "<cmd>silent !tmux neww tmux-sessionizer<CR>")
-- Format current file
vim.keymap.set("n", "<leader>f", vim.lsp.buf.format)
vim.keymap.set("v", "<leader>f", vim.lsp.buf.format)

-- Vim quickfix
vim.keymap.set("n", "<C-k>", "<cmd>cnext<CR>zz")
vim.keymap.set("n", "<C-j>", "<cmd>cprev<CR>zz")
vim.keymap.set("n", "<leader>k", "<cmd>lnext<CR>zz")
vim.keymap.set("n", "<leader>j", "<cmd>lprev<CR>zz")

-- Starts globaly replacing the word the cursor is on
-- vim.keymap.set("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])
-- Set current file to be executable from terminal
vim.keymap.set("n", "<leader>x", "<cmd>!chmod +x %<CR>", { silent = true })

-- source current file
vim.keymap.set("n", "<leader><leader>", function()
	vim.cmd("so")
end)
