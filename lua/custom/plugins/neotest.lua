return {
  'nvim-neotest/neotest',
  dependencies = {
    'nvim-neotest/nvim-nio',
    'nvim-lua/plenary.nvim',
    'antoinemadec/FixCursorHold.nvim',
    'nvim-treesitter/nvim-treesitter',
    'nvim-neotest/neotest-python',
  },
  keys = {
    { '<leader>tn', function() require('neotest').run.run() end,                       desc = 'Test nearest' },
    { '<leader>tf', function() require('neotest').run.run(vim.fn.expand '%') end,      desc = 'Test file' },
    { '<leader>ts', function() require('neotest').run.run { suite = true } end,        desc = 'Test suite' },
    { '<leader>tl', function() require('neotest').run.run_last() end,                  desc = 'Test last' },
    { '<leader>to', function() require('neotest').output.open { enter = true } end,    desc = 'Test output' },
    { '<leader>tO', function() require('neotest').output_panel.toggle() end,           desc = 'Test output panel' },
    { '<leader>tS', function() require('neotest').summary.toggle() end,                desc = 'Test summary' },
    { '<leader>tw', function() require('neotest').watch.toggle(vim.fn.expand '%') end, desc = 'Test watch file' },
  },
  config = function()
    require('neotest').setup {
      adapters = {
        require 'neotest-python',
      },
    }
  end,
}
