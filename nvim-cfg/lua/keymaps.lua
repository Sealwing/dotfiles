-- Core key mappings, diagnostic configuration, and basic autocommands.
--
-- Everything here is plugin-independent: it works with an empty pack directory.
-- Plugin-specific mappings live next to their `PACKAGE:` section in plugins.lua,
-- and LSP buffer-local mappings are set from the LspAttach autocommand there.

local opts = {
    noremap = true,
    silent = true,
}

---Merge a description into the shared options table.
---@param desc string
---@return table
local function with(desc)
    return vim.tbl_extend('force', opts, { desc = desc })
end

--- NORMAL MODE ---

--- Clear search highlight
vim.keymap.set('n', ',<space>', '<cmd>nohlsearch<CR>', opts)

--- Better Window Navigation
vim.keymap.set('n', '<C-h>', '<C-w>h', with('Move focus to the left window'))
vim.keymap.set('n', '<C-j>', '<C-w>j', with('Move focus to the lower window'))
vim.keymap.set('n', '<C-k>', '<C-w>k', with('Move focus to the upper window'))
vim.keymap.set('n', '<C-l>', '<C-w>l', with('Move focus to the right window'))

--- Resize With Arrows
vim.keymap.set('n', '<C-S-Up>', '<cmd>resize -2<CR>', opts)
vim.keymap.set('n', '<C-S-Down>', '<cmd>resize +3<CR>', opts)
vim.keymap.set('n', '<C-S-Left>', '<cmd>vertical resize -2<CR>', opts)
vim.keymap.set('n', '<C-S-Right>', '<cmd>vertical resize +2<CR>', opts)

--- Work With QuickFix List
vim.keymap.set('n', '<leader>qo', '<cmd>copen<CR>', with('Quickfix: open'))
vim.keymap.set('n', '<leader>qc', '<cmd>cclose<CR>', with('Quickfix: close'))
vim.keymap.set('n', '<leader>qn', '<cmd>cnext!<CR>', with('Quickfix: next'))
vim.keymap.set('n', '<leader>qp', '<cmd>cprevious!<CR>', with('Quickfix: previous'))

--- TERMINAL MODE ---

-- Easier to reach than the default <C-\><C-n>.
-- NOTE: may not work in every terminal emulator / tmux configuration.
vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', with('Exit terminal mode'))

--- VISUAL MODE ---

--- Keep the selection after re-indenting
vim.keymap.set('v', '<', '<gv', opts)
vim.keymap.set('v', '>', '>gv', opts)

-- [[ Diagnostics ]]
-- `vim.diagnostic` is core Neovim, not an LSP feature, so it is configured here
-- rather than in the LSP block. See `:help vim.diagnostic.Opts`.
vim.diagnostic.config({
    update_in_insert = false,
    severity_sort = true,
    float = { border = 'rounded', source = 'if_many' },
    underline = { severity = { min = vim.diagnostic.severity.WARN } },

    virtual_text = true, -- Message at the end of the line
    virtual_lines = false, -- Set true (and virtual_text false) to show it below instead

    -- Open the float automatically when jumping with [d / ]d, so the message is
    -- readable without a second keypress.
    jump = {
        on_jump = function(_, bufnr)
            vim.diagnostic.open_float({
                bufnr = bufnr,
                scope = 'cursor',
                focus = false,
            })
        end,
    },
})

vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, with('Diagnostics: show float'))
vim.keymap.set('n', '<leader>ql', vim.diagnostic.setloclist, with('Diagnostics: fill location list'))
vim.keymap.set('n', '[d', function()
    vim.diagnostic.jump({ count = -1 })
end, with('Diagnostics: previous'))
vim.keymap.set('n', ']d', function()
    vim.diagnostic.jump({ count = 1 })
end, with('Diagnostics: next'))

-- [[ Autocommands ]]
-- See `:help lua-guide-autocommands`.

-- Briefly highlight yanked text, so it is obvious what was copied.
vim.api.nvim_create_autocmd('TextYankPost', {
    desc = 'Highlight when yanking (copying) text',
    group = vim.api.nvim_create_augroup('highlight-yank', { clear = true }),
    callback = function()
        vim.hl.on_yank()
    end,
})
