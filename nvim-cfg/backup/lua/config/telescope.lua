
ts = require("telescope")
ts.setup({
    defaults = {
        mappings = {
            n = {
                ["<C-n>"] = require("telescope.actions").cycle_history_next,
                ["<C-p>"] = require("telescope.actions").cycle_history_prev,
            },
        },
    },
})

ts.load_extension("live_grep_args")

local f = require("telescope.builtin")
vim.keymap.set('n', '<leader>ff', f.find_files, {desc='Telescope find files' })
vim.keymap.set('n', '<leader>fa', ":lua require('telescope').extensions.live_grep_args.live_grep_args()<CR>", {desc='Telescope live grep'})
