return {
  'greggh/claude-code.nvim',
  dependencies = {
    'nvim-lua/plenary.nvim',
  },
  config = function()
    require('claude-code').setup {
      window = {
        position = 'vertical', -- open as a vertical split (right side)
        split_ratio = 0.35,
      },
      git = {
        use_git_root = true, -- Set CWD to git root when opening Claude Code (if in git project)
      },
    }
    vim.keymap.set('n', '<leader>tc', '<cmd>ClaudeCode<cr>', { desc = '[T]oggle [C]laude' })
  end,
}
