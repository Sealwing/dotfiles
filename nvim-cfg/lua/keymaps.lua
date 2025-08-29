local opts = {
    noremap = true,
    silent = true,
}

--- NORMAL MODE ---

--- Better Window Navigation
vim.keymap.set('n', '<C-h>', '<C-w>h', opts)
vim.keymap.set('n', '<C-j>', '<C-w>j', opts)
vim.keymap.set('n', '<C-k>', '<C-w>k', opts)
vim.keymap.set('n', '<C-l>', '<C-w>l', opts)

--- Resize With Arrows

vim.keymap.set('n', '<C-M-Up>', ':resize -2<CR>', opts)
vim.keymap.set('n', '<C-M-Down>', ':resize +2<CR>', opts)
vim.keymap.set('n', '<C-M-Left>', ':vertical resize -2<CR>', opts)
vim.keymap.set('n', '<C-M-Right>', ':vertical resize +2<CR>', opts)

-- Call plugins
vim.keymap.set('n', '<leader>G', '<cmd>Neogit<CR>', opts)
vim.keymap.set('n', '<leader>N', '<cmd>Neotree<CR>', opts)


--- VISUAL MODE ---

--- start visual mode with the same area as the previous area and the same mode
vim.keymap.set('v', '<', '<gv', opts)
vim.keymap.set('v', '>', '>gv', opts)

