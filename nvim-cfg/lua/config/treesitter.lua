local configs = require("nvim-treesitter.configs")

configs.setup({
    ensure_installed = { 
        "c", 
        "go",
        "rust",
        "python", 
        "javascript", 
        "html",
        "lua", 
        "sql",
        "nginx",
        "yaml",
        "json",
        "dockerfile",
        "elixir",
        "clojure",
    },
    sync_install = false,
    auto_install = true,
    highlight = {
        enable = true,
        additional_vim_regex_highlighting = false,
    },
    incremental_selection = {
        enable = true,
        keymaps = {
            init_selection = "<C-n>",
            node_incremental = "<C-n>",
            node_decremental = "<C-b>",
            scope_incremental = "<C-m>",
        },
    },
})

vim.wo.foldmethod = 'expr'
vim.wo.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
