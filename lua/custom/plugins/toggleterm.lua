return {
  'akinsho/toggleterm.nvim',
  config = function()
    require('toggleterm').setup {
      size = function(term)
        if term.direction == 'horizontal' then
          return 15
        elseif term.direction == 'vertical' then
          return math.floor(vim.o.columns * 0.4)
        end
      end,
      on_open = function()
        vim.schedule(function() vim.cmd 'startinsert' end)
      end,
    }

    local Terminal = require('toggleterm.terminal').Terminal

    -- Persistent bottom terminal
    local bottom = Terminal:new { direction = 'horizontal' }

    vim.keymap.set('n', 't', function() bottom:toggle() end, { desc = 'Toggle bottom terminal' })

    -- Bottom terminal in current buffer's directory
    vim.keymap.set(
      'n',
      'T',
      function() Terminal:new({ direction = 'horizontal', dir = vim.fn.expand '%:p:h' }):toggle() end,
      { desc = 'Toggle bottom terminal in buffer directory' }
    )

    -- Maximize/restore terminal height
    local maximized = false
    local function toggle_maximize()
      if maximized then
        vim.cmd 'resize 15'
      else
        vim.cmd('resize ' .. (vim.o.lines - 2))
      end
      maximized = not maximized
    end
    vim.keymap.set('n', '<C-f>', toggle_maximize, { desc = 'Toggle terminal fullscreen' })
    vim.keymap.set('t', '<C-f>', function()
      vim.schedule(toggle_maximize)
    end, { desc = 'Toggle terminal fullscreen' })

    -- Exit terminal mode
    vim.keymap.set('t', '<C-Space>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })
  end,
}
