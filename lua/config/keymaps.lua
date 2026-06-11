-- Keymaps are automatically loaded on the VeryLazy event Default keymaps that
-- are always set:
-- https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- vim.api.nvim_set_keymap("i", "jj", "<Esc>", { noremap = false })

vim.api.nvim_set_keymap("x", "<leader>p", '"_dP', { noremap = false, desc = "Paste without yank" })

vim.api.nvim_set_keymap("t", "<Esc>", [[<C-\><C-n>]], { noremap = false, silent = true })

vim.api.nvim_set_keymap("n", "<leader>t", ":enew | terminal<CR>", { noremap = false, silent = true })
