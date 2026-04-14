-- [[ Basic Keymaps ]]
--  See `:help vim.keymap.set()`

-- Clear highlights on search when pressing <Esc> in normal mode
--  See `:help hlsearch`
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')
vim.keymap.set('n', 'q', '<cmd>tabclose<CR>', { desc = 'Close tab' })

-- Copy visual selection as @file:start-end reference to clipboard (for Claude Code)
vim.keymap.set('v', '<leader>cy', function()
  local start_line = vim.fn.line 'v'
  local end_line = vim.fn.line '.'
  if start_line > end_line then
    start_line, end_line = end_line, start_line
  end
  local ref = '@' .. vim.fn.expand '%:p' .. ':' .. start_line .. '-' .. end_line
  vim.fn.setreg('+', ref)
  vim.notify('Copied: ' .. ref, vim.log.levels.INFO)
end, { desc = '[C]laude [Y]ank selection reference' })

-- Diagnostic Config & Keymaps
-- See :help vim.diagnostic.Opts
vim.diagnostic.config {
  update_in_insert = false,
  severity_sort = true,
  float = { border = 'rounded', source = 'if_many' },
  underline = { severity = vim.diagnostic.severity.ERROR },

  -- Can switch between these as you prefer
  virtual_text = true,   -- Text shows up at the end of the line
  virtual_lines = false, -- Teest shows up underneath the line, with virtual lines

  -- Auto open the float, so you can easily read the errors when jumping with `[d` and `]d`
  jump = { float = true },
}

vim.keymap.set('n', '<leader>td', function()
  if vim.diagnostic.is_enabled() then
    vim.diagnostic.enable(false)
  else
    vim.diagnostic.enable()
  end
end, { desc = 'Toggle diagnostics' })

vim.keymap.set('n', '<leader>tC', function() require('copilot.suggestion').toggle_auto_trigger() end,
  { desc = 'Toggle [C]opilot auto suggestions' })

vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })

vim.keymap.set('n', '<leader>gB', function()
  require('gitsigns').blame_line { full = true }
  -- The popup shows the hash — press <CR> to open the commit in gitsigns' own viewer
end)

-- Make <C-c> fire InsertLeave (unlike the default hard interrupt behaviour)
vim.keymap.set('i', '<C-c>', '<Esc>', { desc = 'Exit insert mode' })

-- Reselect visual selection after indenting
vim.keymap.set('v', '<', '<gv', { desc = 'Indent left and reselect' })
vim.keymap.set('v', '>', '>gv', { desc = 'Indent right and reselect' })

-- TIP: Disable arrow keys in normal mode
-- vim.keymap.set('n', '<left>', '<cmd>echo "Use h to move!!"<CR>')
-- vim.keymap.set('n', '<right>', '<cmd>echo "Use l to move!!"<CR>')
-- vim.keymap.set('n', '<up>', '<cmd>echo "Use k to move!!"<CR>')
-- vim.keymap.set('n', '<down>', '<cmd>echo "Use j to move!!"<CR>')

-- Keybinds to make split navigation easier.
--  Use CTRL+<hjkl> to switch between windows
--
--  See `:help wincmd` for a list of all window commands
vim.keymap.set('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
vim.keymap.set('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
vim.keymap.set('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
vim.keymap.set('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })

-- NOTE: Some terminals have colliding keymaps or are not able to send distinct keycodes
-- vim.keymap.set("n", "<C-S-h>", "<C-w>H", { desc = "Move window to the left" })
-- vim.keymap.set("n", "<C-S-l>", "<C-w>L", { desc = "Move window to the right" })
-- vim.keymap.set("n", "<C-S-j>", "<C-w>J", { desc = "Move window to the lower" })
-- vim.keymap.set("n", "<C-S-k>", "<C-w>K", { desc = "Move window to the upper" })

vim.keymap.set('n', 'ùd', function() vim.diagnostic.goto_next { float = false } end, { desc = 'Go to next diagnostic' })
vim.keymap.set('n', 'µd', function() vim.diagnostic.goto_prev { float = false } end,
  { desc = 'Go to previous diagnostic' })

vim.keymap.set('n', 'ùc', '[c', { remap = true, desc = 'Prev diff hunk' })
vim.keymap.set('n', 'µc', ']c', { remap = true, desc = 'Next diff hunk' })

vim.keymap.set('n', 'ùq', '<cmd>cprev<cr>', { desc = 'Previous quickfix item' })
vim.keymap.set('n', 'µq', '<cmd>cnext<cr>', { desc = 'Next quickfix item' })
