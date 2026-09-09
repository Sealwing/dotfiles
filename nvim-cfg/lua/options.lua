-- Cache compiled Lua modules for faster startup. Kept first so it applies to
-- every `require` that follows. See `:help vim.loader`.
vim.loader.enable()

-- [[ Leader keys ]]
-- Must be set before plugins load, so that any <leader> mapping they define
-- resolves against the right key. See `:help mapleader`.
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '
vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>')

-- Plugins (which-key, telescope, neo-tree, blink.cmp) check this to decide
-- whether they may use Nerd Font glyphs.
vim.g.have_nerd_font = true

-- [[ General ]]
-- Deferred: querying the system clipboard provider is slow, and doing it during
-- startup measurably delays the first screen draw. See `:help vim.schedule()`.
vim.schedule(function()
    vim.o.clipboard = 'unnamedplus'
end)
vim.o.mouse = 'a'
vim.o.encoding = 'utf-8'
vim.o.swapfile = false
vim.o.undofile = true -- Persist undo history across sessions
vim.o.exrc = true -- Enable per-project .nvim.lua / .exrc
vim.o.confirm = true -- Prompt to save instead of failing on :q with changes
vim.o.updatetime = 250 -- Faster CursorHold (LSP highlight, gitsigns blame)
vim.o.timeoutlen = 300 -- How long to wait for a mapping sequence to complete

-- Used by the built-in completion menu. blink.cmp drives its own menu, but
-- this still applies to <C-x><C-o> and friends.
vim.opt.completeopt = { 'menu', 'menuone', 'noselect' }

-- [[ Indentation ]]
vim.o.tabstop = 4
vim.o.softtabstop = 4
vim.o.shiftwidth = 4
vim.o.expandtab = true
vim.o.autoindent = true
vim.o.breakindent = true -- Wrapped lines keep the indent of their first line

-- [[ UI ]]
vim.o.number = true
vim.o.relativenumber = true
vim.o.cursorline = true
vim.o.signcolumn = 'yes' -- Always reserve the gutter so text stops jumping
vim.o.splitbelow = true
vim.o.splitright = true
vim.o.scrolloff = 10
vim.o.sidescrolloff = 8
vim.o.termguicolors = true
vim.o.showmatch = true
vim.o.matchtime = 2

-- Show otherwise-invisible whitespace. See `:help 'listchars'`.
vim.o.list = true
vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }

-- [[ Searching ]]
vim.o.incsearch = true
vim.o.hlsearch = true
vim.o.ignorecase = true
vim.o.smartcase = true
vim.o.inccommand = 'split' -- Live preview of :substitute in a split

-- [[ Folding ]]
-- Treesitter-based folds, applied globally rather than to a single window.
-- `vim.treesitter.foldexpr()` degrades gracefully to no folds for filetypes
-- that have no parser installed.
vim.o.foldmethod = 'expr'
vim.o.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
vim.o.foldlevelstart = 99 -- Open files with all folds expanded
