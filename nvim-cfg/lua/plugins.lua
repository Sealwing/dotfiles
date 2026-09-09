-- Plugin declarations and configuration.
--
-- Every plugin lives in its own `do ... end` block headed by a
--   -- PACKAGE: <name>
-- comment, so you can jump straight to one with `/PACKAGE:` or
--   :grep 'PACKAGE:' lua/plugins.lua
--
-- Blocks are executed top to bottom, and `vim.pack.add()` is synchronous, so
-- the order below IS the dependency order. Anything that other plugins need at
-- setup() time (shared libraries, blink.cmp's LSP capabilities) comes first.
--
-- NOTE: `vim.pack` has no lazy-loading. Every plugin here is loaded at startup;
-- there is no equivalent of lazy.nvim's `ft`/`cmd`/`event` gating.

---Most plugins live on GitHub; this keeps the specs below short.
---@param repo string
---@return string
local function gh(repo)
    return 'https://github.com/' .. repo
end

-- ============================================================
-- BUILD HOOKS
-- Post-install/update steps for plugins that need compiling.
-- See `:help vim.pack-events`.
-- ============================================================
do
    local function run_build(name, cmd, cwd)
        local result = vim.system(cmd, { cwd = cwd }):wait()
        if result.code ~= 0 then
            local output = (result.stderr ~= '' and result.stderr) or result.stdout or ''
            if output == '' then
                output = 'No output from build command.'
            end
            vim.notify(('Build failed for %s:\n%s'):format(name, output), vim.log.levels.ERROR)
        end
    end

    vim.api.nvim_create_autocmd('PackChanged', {
        callback = function(ev)
            local name = ev.data.spec.name
            if ev.data.kind ~= 'install' and ev.data.kind ~= 'update' then
                return
            end

            if name == 'telescope-fzf-native.nvim' and vim.fn.executable('make') == 1 then
                run_build(name, { 'make' }, ev.data.path)
            elseif name == 'LuaSnip' then
                if vim.fn.has('win32') ~= 1 and vim.fn.executable('make') == 1 then
                    run_build(name, { 'make', 'install_jsregexp' }, ev.data.path)
                end
            elseif name == 'nvim-treesitter' then
                if not ev.data.active then
                    vim.cmd.packadd('nvim-treesitter')
                end
                vim.cmd('TSUpdate')
            end
        end,
    })
end

-- ============================================================
-- SHARED LIBRARIES
-- PACKAGE: plenary.nvim
-- PACKAGE: nui.nvim
-- PACKAGE: nvim-web-devicons
-- PACKAGE: mini.nvim
-- ============================================================
-- These provide no UI of their own; they are dependencies of the plugins
-- below (telescope, neo-tree, neogit, render-markdown) and must be installed
-- before those call setup().
vim.pack.add({
    gh('nvim-lua/plenary.nvim'),
    gh('MunifTanjim/nui.nvim'),
    gh('nvim-tree/nvim-web-devicons'),
    gh('nvim-mini/mini.nvim'),
})

-- ============================================================
-- PACKAGE: catppuccin
-- Colorscheme.
-- ============================================================
do
    vim.pack.add({ { src = gh('catppuccin/nvim'), name = 'catppuccin' } })
    require('catppuccin').setup({
        flavour = 'macchiato',
    })
    vim.cmd.colorscheme('catppuccin')
end

-- ============================================================
-- PACKAGE: rainbow-delimiters.nvim
-- Colour-matched brackets. Enables itself via its plugin/ file; no setup().
-- ============================================================
vim.pack.add({ gh('HiPhish/rainbow-delimiters.nvim') })

-- ============================================================
-- PACKAGE: lualine.nvim
-- Statusline.
-- ============================================================
do
    vim.pack.add({ gh('nvim-lualine/lualine.nvim') })
    require('lualine').setup({})
end

-- ============================================================
-- PACKAGE: which-key.nvim
-- Popup listing the available continuations of a pending key sequence.
-- ============================================================
do
    vim.pack.add({ gh('folke/which-key.nvim') })
    require('which-key').setup({})
    require('which-key').add({
        { '<leader>f', group = '[F]ind' },
        { '<leader>l', group = '[L]SP' },
        { '<leader>q', group = '[Q]uickfix / location list' },
        { '<leader>h', group = '[H]ighlight' },
        { '<leader>n', group = '[N]avigation' },
        { '<leader>g', group = '[G]it hunks' },
    })
end

-- ============================================================
-- PACKAGE: gitsigns.nvim
-- Git signs in the gutter plus hunk staging/preview.
-- Complements neogit (full-screen git UI) rather than replacing it.
-- ============================================================
do
    vim.pack.add({ gh('lewis6991/gitsigns.nvim') })
    local gitsigns = require('gitsigns')
    gitsigns.setup({
        signs = {
            add = { text = '+' },
            change = { text = '~' },
            delete = { text = '_' },
            topdelete = { text = '‾' },
            changedelete = { text = '~' },
        },
    })

    vim.keymap.set('n', ']c', function()
        if vim.wo.diff then
            vim.cmd.normal({ ']c', bang = true })
        else
            gitsigns.nav_hunk('next')
        end
    end, { desc = 'Git: next hunk' })

    vim.keymap.set('n', '[c', function()
        if vim.wo.diff then
            vim.cmd.normal({ '[c', bang = true })
        else
            gitsigns.nav_hunk('prev')
        end
    end, { desc = 'Git: previous hunk' })

    vim.keymap.set('n', '<leader>gp', gitsigns.preview_hunk, { desc = 'Git: [P]review hunk' })
    vim.keymap.set('n', '<leader>gs', gitsigns.stage_hunk, { desc = 'Git: [S]tage hunk' })
    vim.keymap.set('n', '<leader>gr', gitsigns.reset_hunk, { desc = 'Git: [R]eset hunk' })
    vim.keymap.set('n', '<leader>gb', gitsigns.blame_line, { desc = 'Git: [B]lame line' })
end

-- ============================================================
-- PACKAGE: telescope.nvim
-- PACKAGE: telescope-live-grep-args.nvim
-- PACKAGE: telescope-fzf-native.nvim
-- PACKAGE: telescope-ui-select.nvim
-- Fuzzy finder. Set up before neogit and neo-tree, which use it.
-- ============================================================
do
    ---@type (string|vim.pack.Spec)[]
    local telescope_plugins = {
        gh('nvim-telescope/telescope.nvim'),
        { src = gh('nvim-telescope/telescope-live-grep-args.nvim'), version = vim.version.range('1.*') },
        gh('nvim-telescope/telescope-ui-select.nvim'),
    }
    -- fzf-native is compiled by the PackChanged hook above; skip it without `make`.
    if vim.fn.executable('make') == 1 then
        table.insert(telescope_plugins, gh('nvim-telescope/telescope-fzf-native.nvim'))
    end
    vim.pack.add(telescope_plugins)

    local telescope = require('telescope')
    local actions = require('telescope.actions')
    telescope.setup({
        defaults = {
            mappings = {
                n = {
                    ['<C-n>'] = actions.cycle_history_next,
                    ['<C-p>'] = actions.cycle_history_prev,
                },
            },
        },
        extensions = {
            ['ui-select'] = { require('telescope.themes').get_dropdown() },
        },
    })

    telescope.load_extension('live_grep_args')
    telescope.load_extension('ui-select')
    if vim.fn.executable('make') == 1 then
        telescope.load_extension('fzf')
    end

    local builtin = require('telescope.builtin')
    vim.keymap.set('n', '<leader>ff', builtin.find_files, { desc = 'Telescope: [F]ind [F]iles' })
    vim.keymap.set('n', '<leader>fa', function()
        telescope.extensions.live_grep_args.live_grep_args()
    end, { desc = 'Telescope: live grep with [A]rgs' })

    -- Replaces bufferchad.nvim, which is no longer maintained. Its marked-buffer
    -- feature (<leader>fm / <leader>ma) has no equivalent here and was dropped.
    vim.keymap.set('n', '<leader>fb', builtin.buffers, { desc = 'Telescope: [F]ind [B]uffers' })
end

-- ============================================================
-- PACKAGE: neo-tree.nvim
-- File explorer.
-- ============================================================
do
    vim.pack.add({ { src = gh('nvim-neo-tree/neo-tree.nvim'), version = 'v3.x' } })

    vim.fn.sign_define('DiagnosticSignError', { text = ' ', texthl = 'DiagnosticSignError' })
    vim.fn.sign_define('DiagnosticSignWarn', { text = ' ', texthl = 'DiagnosticSignWarn' })
    vim.fn.sign_define('DiagnosticSignInfo', { text = ' ', texthl = 'DiagnosticSignInfo' })
    vim.fn.sign_define('DiagnosticSignHint', { text = '󰌵', texthl = 'DiagnosticSignHint' })

    require('neo-tree').setup({
        default_component_configs = {
            name = {
                trailing_slash = false,
                use_git_status_colors = true,
                highlight = 'NeoTreeFileName',
            },
            git_status = {
                symbols = {
                    -- Change type
                    added = '✚',
                    modified = '',
                    deleted = '✖',
                    renamed = '󰁕',
                    -- Status type
                    untracked = '',
                    ignored = '',
                    unstaged = '󰄱',
                    staged = '',
                    conflict = '',
                },
            },
        },
        -- NOTE: `window` is a top-level key, not a `default_component_configs`
        -- one. In the old config it was nested, so the width was never applied.
        window = {
            width = 15,
        },
    })

    vim.keymap.set('n', '<leader>N', '<cmd>Neotree<CR>', { silent = true, desc = 'Neo-tree: toggle' })
end

-- ============================================================
-- PACKAGE: workspaces.nvim
-- Named project directories (:WorkspacesAdd / :WorkspacesOpen).
-- ============================================================
do
    vim.pack.add({ gh('natecraddock/workspaces.nvim') })
    require('workspaces').setup({
        hooks = {
            add = {},
            remove = {},
            rename = {},
            open_pre = {},
            open = {},
        },
    })
end

-- ============================================================
-- PACKAGE: neogit
-- PACKAGE: diffview.nvim
-- Magit-style git interface.
-- ============================================================
do
    vim.pack.add({
        gh('sindrets/diffview.nvim'),
        gh('NeogitOrg/neogit'),
    })
    require('neogit').setup({})

    vim.keymap.set('n', '<leader>G', '<cmd>Neogit<CR>', { silent = true, desc = 'Neogit: open' })
end

-- ============================================================
-- PACKAGE: nvim-treesitter
-- PACKAGE: nvim-treesitter-textobjects
-- Parsers, highlighting, indentation, and textobjects.
--
-- NOTE: this uses the `main` branch, which is a rewrite. It has NO `setup()`
-- and none of the old module tables (`ensure_installed`, `highlight`,
-- `incremental_selection`, ...). Parsers are installed with `.install()` and
-- highlighting is started per-buffer from a FileType autocommand.
--
-- NOTE: `incremental_selection` (<C-n>/<C-b>/<C-m>) is gone with no upstream
-- replacement. Use the textobjects below instead: `vif`, `vaf`, `vic`, ...
-- ============================================================
do
    vim.pack.add({
        { src = gh('nvim-treesitter/nvim-treesitter'), version = 'main' },
        { src = gh('nvim-treesitter/nvim-treesitter-textobjects'), version = 'main' },
    })

    local parsers = {
        'c',
        'go',
        'rust',
        'python',
        'javascript',
        'html',
        'lua',
        'sql',
        'nginx',
        'yaml',
        'json',
        'dockerfile',
        'elixir',
        'clojure',
        -- Needed by render-markdown.nvim and for :help / config editing.
        'markdown',
        'markdown_inline',
        'vim',
        'vimdoc',
        'query',
        'bash',
        'diff',
    }
    require('nvim-treesitter').install(parsers)

    ---Start highlighting/indentation for `buf`, if a parser for `language` exists.
    ---@param buf integer
    ---@param language string
    local function try_attach(buf, language)
        if not vim.treesitter.language.add(language) then
            return
        end
        vim.treesitter.start(buf, language)

        -- Fall back to the built-in indentexpr when a language has no indents query.
        if vim.treesitter.query.get(language, 'indents') ~= nil then
            vim.bo[buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
        end
    end

    local available_parsers = require('nvim-treesitter').get_available()
    vim.api.nvim_create_autocmd('FileType', {
        group = vim.api.nvim_create_augroup('treesitter-attach', { clear = true }),
        callback = function(args)
            local buf, filetype = args.buf, args.match

            local language = vim.treesitter.language.get_lang(filetype)
            if not language then
                return
            end

            local installed = require('nvim-treesitter').get_installed('parsers')
            if vim.tbl_contains(installed, language) then
                try_attach(buf, language)
            elseif vim.tbl_contains(available_parsers, language) then
                require('nvim-treesitter').install(language):await(function()
                    try_attach(buf, language)
                end)
            else
                try_attach(buf, language)
            end
        end,
    })

    -- [[ Textobjects ]]
    require('nvim-treesitter-textobjects').setup({
        select = { lookahead = true },
        move = { set_jumps = true },
    })

    local select = require('nvim-treesitter-textobjects.select')
    local move = require('nvim-treesitter-textobjects.move')

    ---@param key string
    ---@param query string
    ---@param desc string
    local function map_select(key, query, desc)
        vim.keymap.set({ 'x', 'o' }, key, function()
            select.select_textobject(query, 'textobjects')
        end, { desc = desc })
    end

    map_select('af', '@function.outer', 'Select outer function')
    map_select('if', '@function.inner', 'Select inner function')
    map_select('ac', '@class.outer', 'Select outer class')
    map_select('ic', '@class.inner', 'Select inner class')
    map_select('aa', '@parameter.outer', 'Select outer parameter')
    map_select('ia', '@parameter.inner', 'Select inner parameter')

    vim.keymap.set({ 'n', 'x', 'o' }, ']m', function()
        move.goto_next_start('@function.outer', 'textobjects')
    end, { desc = 'Next function start' })
    vim.keymap.set({ 'n', 'x', 'o' }, '[m', function()
        move.goto_previous_start('@function.outer', 'textobjects')
    end, { desc = 'Previous function start' })
end

-- ============================================================
-- PACKAGE: aerial.nvim
-- Symbol outline window. Depends on treesitter/LSP, so it comes after both.
-- ============================================================
do
    vim.pack.add({ gh('stevearc/aerial.nvim') })
    require('aerial').setup({
        on_attach = function(bufnr)
            vim.keymap.set('n', '{', '<cmd>AerialPrev<CR>', { buffer = bufnr, desc = 'Aerial: previous symbol' })
            vim.keymap.set('n', '}', '<cmd>AerialNext<CR>', { buffer = bufnr, desc = 'Aerial: next symbol' })
        end,
    })

    vim.keymap.set('n', '<leader>nn', '<cmd>AerialToggle!<CR>', { desc = 'Aerial: toggle outline' })
end

-- ============================================================
-- PACKAGE: LuaSnip
-- PACKAGE: blink.cmp
-- Snippet engine and completion menu. Replaces nvim-cmp + cmp-nvim-lsp +
-- cmp_luasnip. Must come before the LSP block, which reuses blink's
-- client capabilities.
-- ============================================================
do
    vim.pack.add({
        { src = gh('L3MON4D3/LuaSnip'), version = vim.version.range('2.*') },
        { src = gh('saghen/blink.cmp'), version = vim.version.range('1.*') },
    })
    require('luasnip').setup({})

    require('blink.cmp').setup({
        -- Mappings mirror the old nvim-cmp setup:
        --   <C-k>/<C-j> select previous/next, <CR> accept, <C-b>/<C-f> scroll docs,
        --   <Tab>/<S-Tab> open-or-cycle the menu, falling through when it is closed.
        keymap = {
            preset = 'none',
            ['<C-b>'] = { 'scroll_documentation_up', 'fallback' },
            ['<C-f>'] = { 'scroll_documentation_down', 'fallback' },
            ['<C-k>'] = { 'select_prev', 'fallback' },
            ['<C-j>'] = { 'select_next', 'fallback' },
            ['<C-e>'] = { 'hide', 'fallback' },
            ['<C-space>'] = { 'show', 'show_documentation', 'hide_documentation' },
            ['<CR>'] = { 'accept', 'fallback' },
            ['<Tab>'] = { 'select_next', 'show', 'fallback' },
            ['<S-Tab>'] = { 'select_prev', 'snippet_backward', 'fallback' },
        },

        appearance = {
            nerd_font_variant = 'mono',
        },

        completion = {
            -- `noselect`-like behaviour, matching the old completeopt.
            list = { selection = { preselect = false, auto_insert = true } },
            documentation = { auto_show = false },
            menu = {
                draw = {
                    -- Old cmp `formatting.fields`: label plus a source tag.
                    columns = { { 'label', 'label_description', gap = 1 }, { 'source_name' } },
                },
            },
        },

        sources = {
            default = { 'lsp', 'snippets', 'buffer', 'path' },
            providers = {
                lsp = { name = '[Lsp]' },
                snippets = { name = '[Luasnip]' },
                buffer = { name = '[File]' },
                path = { name = '[Path]' },
            },
        },

        snippets = { preset = 'luasnip' },

        -- The Lua matcher needs no prebuilt binary download.
        fuzzy = { implementation = 'lua' },

        signature = { enabled = true },
    })
end

-- ============================================================
-- PACKAGE: nvim-lspconfig
-- PACKAGE: mason.nvim
-- PACKAGE: mason-lspconfig.nvim
-- Language servers.
--
-- NOTE: the `williamboman/*` repos are archived; mason moved to `mason-org/*`
-- and mason-lspconfig v2 auto-enables installed servers. We turn that off and
-- enable servers explicitly, so this file stays the single source of truth.
-- ============================================================
do
    vim.pack.add({
        gh('neovim/nvim-lspconfig'),
        gh('mason-org/mason.nvim'),
        gh('mason-org/mason-lspconfig.nvim'),
    })

    require('mason').setup({})
    require('mason-lspconfig').setup({
        ensure_installed = { 'pyright', 'gopls' },
        automatic_enable = false,
    })

    -- Buffer-local mappings, applied whenever a server attaches.
    vim.api.nvim_create_autocmd('LspAttach', {
        group = vim.api.nvim_create_augroup('lsp-attach', { clear = true }),
        callback = function(event)
            local function map(mode, keys, func, desc)
                vim.keymap.set(mode, keys, func, { buffer = event.buf, silent = true, desc = 'LSP: ' .. desc })
            end

            map('n', 'gd', vim.lsp.buf.definition, 'goto definition')
            map('n', 'gr', vim.lsp.buf.references, 'goto references')
            map('n', 'gD', vim.lsp.buf.declaration, 'goto declaration')
            map('n', 'gi', vim.lsp.buf.implementation, 'goto implementation')

            map('n', '<leader>ll', vim.lsp.buf.hover, 'hover documentation')
            map('n', '<leader>lj', vim.lsp.buf.signature_help, 'signature help')
            map('n', '<leader>lc', vim.lsp.buf.code_action, '[C]ode action')
            map('n', '<leader>lr', vim.lsp.buf.rename, '[R]ename')
            map('n', '<leader>lf', function()
                vim.lsp.buf.format({ async = true })
            end, '[F]ormat buffer')

            map({ 'n', 'v' }, '<leader>hl', vim.lsp.buf.document_highlight, '[H]ighlight references')
            map({ 'n', 'v' }, '<leader>hu', vim.lsp.buf.clear_references, '[H]ighlight clear')
        end,
    })

    -- blink.cmp advertises the completion capabilities it supports.
    local capabilities = require('blink.cmp').get_lsp_capabilities()

    vim.lsp.config('pyright', {
        capabilities = capabilities,
        settings = {
            python = {},
        },
        before_init = function(_, config)
            -- Point pyright at the project's virtualenv, if there is one.
            local root = config.root_dir
            if not root then
                return
            end
            local venv = vim.fs.joinpath(root, '.venv')
            local unix_python = vim.fs.joinpath(venv, 'bin', 'python')
            local win_python = vim.fs.joinpath(venv, 'Scripts', 'python.exe')

            config.settings = config.settings or {}
            config.settings.python = config.settings.python or {}
            if vim.uv.fs_stat(unix_python) then
                config.settings.python.pythonPath = unix_python
            elseif vim.uv.fs_stat(win_python) then
                config.settings.python.pythonPath = win_python
            end
        end,
    })

    vim.lsp.config('gopls', {
        capabilities = capabilities,
        -- NOTE: these must be nested under `settings.gopls`. In the old config
        -- they sat at the top level of the spec and were silently ignored.
        settings = {
            gopls = {
                analyses = {
                    unusedparams = true,
                },
                staticcheck = true,
                gofumpt = true,
            },
        },
    })

    vim.lsp.enable({ 'pyright', 'gopls' })
end

-- ============================================================
-- PACKAGE: render-markdown.nvim
-- In-buffer markdown rendering. Uses mini.nvim (added above) for icons.
-- ============================================================
do
    vim.pack.add({ gh('MeanderingProgrammer/render-markdown.nvim') })
    require('render-markdown').setup({})
end
