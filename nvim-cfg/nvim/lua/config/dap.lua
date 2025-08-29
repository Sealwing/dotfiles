pydap = require("dap-python")

pydap.setup("python")

opts = {
    noremap = true,
    silent = true,
}

dap = require("dap")

vim.keymap.set('n', '<leader>dp', dap.toggle_breakpoint, opts)
vim.keymap.set('n', '<leader>dc', dap.continue, opts)
vim.keymap.set('n', '<leader>do', dap.step_over, opts)
vim.keymap.set('n', '<leader>di', dap.step_into, opts)
vim.keymap.set('n', '<leader>de', dap.repl.open, opts)

vim.keymap.set('n', '<leader>dr', pydap.test_method, opts)
vim.keymap.set('n', '<leader>dR', pydap.test_class, opts)
