require("bufferchad").setup({
  mapping = "<leader>bb", -- Map any key, or set to NONE to disable key mapping
  mark_mapping = "<leader>bm", -- The keybinding to display just the marked buffers
  add_mark_mapping = "<leader>mm", -- The keybinding to add a mark to a buffer
  order = "LAST_USED_UP", -- LAST_USED_UP (default)/ASCENDING/DESCENDING/REGULAR
  style = "telescope", -- default, modern (requires dressing.nvim and nui.nvim), telescope (requires telescope.nvim)
  close_mapping = "<Esc><Esc>", -- only for the default style window. 
  normal_editor_mapping = "NONE" -- read use case below
})
