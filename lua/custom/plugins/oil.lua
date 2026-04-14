return {
  'stevearc/oil.nvim',
  dependencies = { 'nvim-tree/nvim-web-devicons' },
  ---@module 'oil'
  ---@type oil.SetupOpts
  opts = {
    default_file_explorer = true,
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
      ['l'] = 'actions.select',
    },
  },
  keys = {
    { '-', '<cmd>Oil<cr>', desc = 'Open parent directory' },
    { '<leader>o', '<cmd>Oil --float<cr>', desc = 'Open oil (float)' },
  },
}
