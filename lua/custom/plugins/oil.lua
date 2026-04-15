return {
  'stevearc/oil.nvim',
  dependencies = { 'nvim-tree/nvim-web-devicons' },
  ---@module 'oil'
  ---@type oil.SetupOpts
  opts = {
    default_file_explorer = true,
    -- Notify the LSP when files are moved/deleted so it can update its index.
    -- Without this, the server keeps stale entries and grr/diagnostics lag behind.
    lsp_file_methods = {
      enabled = true,
      timeout_ms = 1000,
      autosave_changes = false,
    },
    columns = { 'icon', 'permissions', 'size', 'mtime' },
    view_options = {
      show_hidden = false,
    },
    float = {
      padding = 2,
      max_width = 80,
      max_height = 40,
    },
    keymaps = {
      ['<C-p>'] = 'actions.preview',
      ['<C-s>'] = false, -- don't shadow horizontal split
      ['<C-h>'] = false, -- don't shadow window nav
      ['H'] = 'actions.parent',
      ['L'] = 'actions.select',
    },
  },
  keys = {
    { '-', '<cmd>Oil<cr>', desc = 'Open parent directory' },
    { '<leader>o', '<cmd>Oil --float<cr>', desc = 'Open oil (float)' },
  },
}
