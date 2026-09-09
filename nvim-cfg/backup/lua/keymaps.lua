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

vim.keymap.set('n', '<C-SUp>', ':resize -2<CR>', opts)
vim.keymap.set('n', '<C-S-Down>', ':resize +3<CR>', opts)
vim.keymap.set('n', '<C-S-Left>', ':vertical resize -2<CR>', opts)
vim.keymap.set('n', '<C-S-Right>', ':vertical resize +2<CR>', opts)

--- Call Plugins
vim.keymap.set('n', '<leader>G', '<cmd>Neogit<CR>', opts)
vim.keymap.set('n', '<leader>N', '<cmd>Neotree<CR>', opts)

--- Work With QuickFix List
vim.keymap.set('n', '<leader>qo', ':copen<CR>', opts) -- open
vim.keymap.set('n', '<leader>qc', ':cclose<CR>', opts) -- close
vim.keymap.set('n', '<leader>qn', ':cnext!<CR>', opts) -- next
vim.keymap.set('n', '<leader>qp', ':cprevious!<CR>', opts) -- previous

--- VISUAL MODE ---

--- start visual mode with the same area as the previous area and the same mode
vim.keymap.set('v', '<', '<gv', opts)
vim.keymap.set('v', '>', '>gv', opts)

