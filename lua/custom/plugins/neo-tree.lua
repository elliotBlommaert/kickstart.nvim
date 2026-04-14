return {
  'nvim-neo-tree/neo-tree.nvim',
  branch = 'v3.x',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-tree/nvim-web-devicons', -- for file icons
    'MunifTanjim/nui.nvim',
  },
  config = function()
    require('neo-tree').setup {
      close_if_last_window = true, -- close neotree if it's the last window
      window = {
        position = 'left',
        width = 35,
        mappings = {
          ['<space>'] = 'open',
          ['<cr>'] = 'toggle_node',
        },
      },
      filesystem = {
        follow_current_file = {
          enabled = true, -- auto-expand tree to show current file
        },
        hide_dotfiles = false,
        filtered_items = {
          hide_gitignored = true,
        },
      },
    }

    -- Keymap to toggle the tree
    vim.keymap.set('n', '<leader>e', '<cmd>Neotree toggle<cr>')
  end,
}
