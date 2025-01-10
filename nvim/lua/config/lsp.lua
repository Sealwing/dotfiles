local c = vim.lsp.protocol.make_client_capabilities()
c = require("cmp_nvim_lsp").default_capabilities(c)

require("mason").setup()

require("mason-lspconfig").setup({
    ensure_installed = {"pyright"},
})


-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(client, bufnr)
    -- Enable completion triggered by <c-x><c-o>
    vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

    -- See `:help vim.lsp.*` for documentation on any of the below functions
    local bufopts = { noremap = true, silent = true, buffer = bufnr }
    vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, bufopts)
    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, bufopts)
    vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, bufopts)
    vim.keymap.set('n', 'gr', vim.lsp.buf.references, bufopts)

    vim.keymap.set('n', '<leader>lk', vim.lsp.buf.hover, bufopts)
    vim.keymap.set('n', '<leader>lj', vim.lsp.buf.signature_help, bufopts)
    vim.keymap.set('n', '<leader>lJ', vim.lsp.buf.type_definition, bufopts)

    vim.keymap.set('n', '<leader>wa', vim.lsp.buf.add_workspace_folder, bufopts)
    vim.keymap.set('n', '<leader>wr', vim.lsp.buf.remove_workspace_folder, bufopts)
    vim.keymap.set('n', '<leader>wl', function()
        print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
    end, bufopts)

    vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, bufopts)
    vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, bufopts)
    vim.keymap.set("n", "<leader>fmt", function()
        vim.lsp.buf.format({ async = true })
    end, bufopts)
    vim.keymap.set({'n', 'v'}, '<leader>hl', vim.lsp.buf.document_highlight, opts)
    vim.keymap.set({'n', 'v'}, '<leader>hu', vim.lsp.buf.clear_references, opts)
end

require("lspconfig").pyright.setup {
    capabilities = c,
    on_attach = on_attach,
    before_init = function(params, config)
        local Path = require "plenary.path"
        local venv = Path:new((config.root_dir:gsub("/", Path.path.sep)), ".venv")
        if venv:joinpath("bin"):is_dir() then
            config.settings.python.pythonPath = tostring(venv:joinpath("bin", "python"))
        else
            config.settings.python.pythonPath = tostring(venv:joinpath("Scripts", "python.exe"))
        end
    end
}

local opts = { noremap = true, silent = true }

local next_diagnostic = function()
    vim.diagnostic.jump({count=1, float=true})
end

local prev_diagnostic = function()
    vim.diagnostic.jump({count=-1, float=true})
end

vim.keymap.set('n', '<space>e', vim.diagnostic.open_float, opts)
vim.keymap.set('n', '[d', prev_diagnostic, opts)
vim.keymap.set('n', ']d', next_diagnostic, opts)
vim.keymap.set('n', '<space>q', vim.diagnostic.setloclist, opts)



