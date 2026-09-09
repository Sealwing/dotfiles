-- Neovim configuration entry point.
--
-- Layout:
--   lua/options.lua  -- vim.opt / vim.o settings, leader keys
--   lua/keymaps.lua  -- plugin-independent key mappings
--   lua/plugins.lua  -- vim.pack.add() + setup() for every plugin
--
-- Plugins are managed by Neovim's built-in package manager, `vim.pack`
-- (requires Neovim 0.12+). See `:help vim.pack`.
--
--   Inspect state / pending updates:  :lua vim.pack.update(nil, { offline = true })
--   Update everything:                :lua vim.pack.update()
--   Remove unused plugins:            :lua vim.pack.del({ 'name' })
--
-- To find where a given plugin is configured, search for `PACKAGE: <name>`
-- in lua/plugins.lua.

-- Leader must be set before any plugin defines a <leader> mapping.
require('options')
require('keymaps')
require('plugins')
