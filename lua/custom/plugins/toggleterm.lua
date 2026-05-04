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
    }

    local Terminal = require('toggleterm.terminal').Terminal

    -- Persistent bottom terminal
    local bottom = Terminal:new { direction = 'horizontal' }

    -- Focus terminal (open if needed), stay in normal mode
    vim.keymap.set('n', '<leader>ti', function()
      if bottom:is_open() then
        vim.api.nvim_set_current_win(bottom.window)
        vim.schedule(function() vim.cmd 'startinsert' end)
      else
        bottom:open()
        vim.cmd 'startinsert'
      end
    end, { desc = 'Go to terminal' })

    vim.keymap.set('n', '<leader>tn', function()
      if bottom:is_open() then
        vim.api.nvim_set_current_win(bottom.window)
      else
        bottom:open()
        vim.cmd 'stopinsert'
      end
    end, { desc = 'Go to terminal' })

    -- Close terminal if open, otherwise do nothing
    vim.keymap.set('n', 'T', function()
      if bottom:is_open() then bottom:close() end
    end, { desc = 'Close terminal' })

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
    vim.keymap.set('t', '<C-f>', function() vim.schedule(toggle_maximize) end, { desc = 'Toggle terminal fullscreen' })
    vim.keymap.set('n', '<C-f>', function() vim.schedule(toggle_maximize) end, { desc = 'Toggle terminal fullscreen' })

    -- Focus terminal in normal mode and maximize it
    vim.keymap.set('n', '<leader>tf', function()
      if not bottom:is_open() then bottom:open() end
      vim.api.nvim_set_current_win(bottom.window)
      vim.cmd 'stopinsert'
      vim.cmd('resize ' .. (vim.o.lines - 2))
      maximized = true
    end, { desc = 'Focus and maximize terminal' })

    -- Open terminal and rerun previous command
    vim.keymap.set('n', '<leader>tp', function()
      if not bottom:is_open() then bottom:open() end
      vim.schedule(function() vim.fn.chansend(bottom.job_id, '\027[A\r') end)
    end, { desc = '[R]erun previous terminal command' })

    -- Exit terminal mode
    vim.keymap.set('t', '<C-Space>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })
  end,
}
