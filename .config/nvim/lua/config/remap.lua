vim.g.mapleader = " "

vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)

vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv") -- move lines in visual mode
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv") -- move lines in visual mode

vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

vim.keymap.set("n", "<leader>f", function()
    vim.lsp.buf.format()
end)