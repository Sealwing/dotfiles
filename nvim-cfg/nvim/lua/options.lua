vim.opt.clipboard = 'unnamedplus'
vim.opt.completeopt = {'menu', 'menuone', 'noselect'}
vim.opt.mouse = 'a'
vim.opt.encoding = 'utf-8'
vim.opt.swapfile = false
vim.o.exrc = true -- Enable per-project env

-- Remap
vim.api.nvim_set_keymap('n', ',<space>', ':nohlsearch<CR>', {noremap = true})
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '
vim.keymap.set({'n', 'v'}, '<Space>', '<Nop>')

-- Tab
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.autoindent = true

-- UI config
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.cursorline = true
vim.opt.splitbelow = true
vim.opt.splitright = true

-- Searching
vim.opt.incsearch = true
vim.opt.hlsearch = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
