local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

if not (vim.uv or vim.loop).fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable",
        lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
    spec={
        -- UI
--        {
--            "gbprod/nord.nvim",
--            lazy = false,
--            priority = 1000,
--            config = function()
--                require("nord").setup({})
--                vim.cmd.colorscheme("nord")
--            end,
--        },
        {
            "catppuccin/nvim",
            name = "catppuccin",
            priority = 1000,
            config = function()
                require("catppuccin").setup({
                    flavor = "macchiato"
                })
                vim.cmd.colorscheme("catppuccin")
            end,
        },
        {
            "HiPhish/rainbow-delimiters.nvim",
        },
        {
            "nvim-lualine/lualine.nvim",
            config = true,
        },
        -- Project Navigation
        {
            "mrquantumcodes/bufferchad.nvim",
            dependencies = {
                {"nvim-lua/plenary.nvim"},
--                {"MunifTanjim/nui.nvim"},
--                {"stevearc/dressing.nvim"},
                {"nvim-telescope/telescope.nvim"}
            },
            config = function()
                require("config.bufferchad")
            end,
        },
        {
            "natecraddock/workspaces.nvim",
            config = function()
                require("config.workspaces")
            end,
        },
        {
            "nvim-neo-tree/neo-tree.nvim",
            branch = "v3.x",
            dependencies = {
                "nvim-lua/plenary.nvim",
                "nvim-tree/nvim-web-devicons",
                "MunifTanjim/nui.nvim",
            },
            config = function()
                require("config.neotree")
            end,
        },
        -- GIT
        {
            "NeogitOrg/neogit",
            dependencies = {
                "nvim-lua/plenary.nvim",
                "sindrets/diffview.nvim",
                "nvim-telescope/telescope.nvim",
            },
            config = true
        },
        -- Search
        {
            "nvim-telescope/telescope.nvim",
            tag = "0.1.8",
            dependencies = {
                {
                    "nvim-lua/plenary.nvim"
                },
                {
                    "nvim-telescope/telescope-live-grep-args.nvim",
                    version = "^1.0.0",
                },
            },
            config = function()
                require("config.telescope")
            end,
        },
        -- Code
        {
            "nvim-treesitter/nvim-treesitter",
            build = ":TSUpdate",
            config = function()
                require("config.treesitter")
            end,
        },
        {
            "neovim/nvim-lspconfig",
            dependencies = {
                "williamboman/mason.nvim",
                "williamboman/mason-lspconfig.nvim",
            },
            config = function()
                require("config.lsp")
            end,
        },
        {
            "hrsh7th/nvim-cmp",
            dependencies = {
                "hrsh7th/cmp-nvim-lsp",
                "L3MON4D3/LuaSnip",
                "saadparwaiz1/cmp_luasnip",
            },
            config = function()
                require("config.cmp")
            end,
        },
        {
            'stevearc/aerial.nvim',
            opts = {},
            -- Optional dependencies
            dependencies = {
                "nvim-treesitter/nvim-treesitter",
                "nvim-tree/nvim-web-devicons"
            },
            config = function()
                require("config.aerial")
            end,
        },
        -- Languages
        -- # Clojure #
        --{
        --    "Olical/conjure",
        --    ft = { "clojure" },
        --},
        --{
        --    "tpope/vim-dispatch",
        --},
        --{
        --    "clojure-vim/vim-jack-in",
        --},
        --{
        --    "radenling/vim-dispatch-neovim",
        --},
    },
})

