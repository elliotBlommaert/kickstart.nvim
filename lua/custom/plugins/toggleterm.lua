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
    vim.keymap.set('n', '<leader>ri', function()
      if bottom:is_open() then
        vim.api.nvim_set_current_win(bottom.window)
      else
        bottom:open()
      end
      vim.schedule(function() vim.cmd 'startinsert' end)
    end, { desc = 'Go to terminal' })

    vim.keymap.set('n', '<leader>rn', function()
      if bottom:is_open() then
        vim.api.nvim_set_current_win(bottom.window)
      else
        bottom:open()
        vim.cmd 'stopinsert'
      end
    end, { desc = 'Go to terminal' })

    -- Toggle terminal open/close
    vim.keymap.set('n', '<leader>rr', function()
      if bottom:is_open() then
        bottom:close()
      else
        bottom:open()
      end
    end, { desc = 'Toggle terminal' })

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

    -- Toggle terminal: open maximized → maximize → minimize
    vim.keymap.set('n', '<leader>rf', function()
      if not bottom:is_open() then
        bottom:open()
        vim.api.nvim_set_current_win(bottom.window)
        vim.cmd 'stopinsert'
        vim.cmd('resize ' .. (vim.o.lines - 2))
        maximized = true
      elseif not maximized then
        vim.api.nvim_set_current_win(bottom.window)
        vim.cmd 'stopinsert'
        vim.cmd('resize ' .. (vim.o.lines - 2))
        maximized = true
      else
        vim.cmd 'resize 15'
        maximized = false
      end
    end, { desc = 'Toggle maximize terminal' })

    -- Open terminal and rerun previous command
    vim.keymap.set('n', '<leader>rp', function()
      if not bottom:is_open() then bottom:open() end
      vim.schedule(function() vim.fn.chansend(bottom.job_id, '\027[A\r') end)
    end, { desc = '[R]erun previous terminal command' })

    -- Exit terminal mode
    vim.keymap.set('t', '<C-Space>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })
  end,
}
