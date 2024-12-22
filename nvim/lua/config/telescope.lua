local f = require("telescope.builtin")
vim.keymap.set('n', '<leader>ff', f.find_files, {desc='Telescope find files' })
vim.keymap.set('n', '<leader>fa', f.live_grep, {desc='Telescope live grep'})

require("telescope").setup({
    defaults = {
        mappings = {
            n = {
                ["<C-n>"] = require("telescope.actions").cycle_history_next,
                ["<C-p>"] = require("telescope.actions").cycle_history_prev,
            },
        },
    },
})
