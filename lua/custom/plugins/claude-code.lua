return {
  'coder/claudecode.nvim',
  dependencies = {
    'folke/snacks.nvim',
  },
  opts = {
    split_side = 'right',
    split_width_percentage = 0.35,
  },
  keys = {
    { '<leader>cf', '<cmd>ClaudeCodeFocus<cr>',      desc = '[C]laude [F]ocus' },
    { '<leader>cr', '<cmd>ClaudeCode --resume<cr>',  desc = '[C]laude [R]esume' },
    { '<leader>cs', '<cmd>ClaudeCodeSend<cr>',       mode = 'v',                     desc = '[C]laude [S]end selection' },
    { '<leader>ca', '<cmd>ClaudeCodeDiffAccept<cr>', desc = '[C]laude [A]ccept diff' },
    { '<leader>cd', '<cmd>ClaudeCodeDiffDeny<cr>',   desc = '[C]laude [D]eny diff' },
    { '<leader>cb', '<cmd>ClaudeCodeAdd %<cr>',      desc = '[C]laude add [B]uffer' },
  },
}
