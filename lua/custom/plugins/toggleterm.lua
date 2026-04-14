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
    vim.keymap.set('n', 't', function()
      if bottom:is_open() then
        vim.api.nvim_set_current_win(bottom.window)
      else
        bottom:open()
        vim.cmd 'stopinsert'
      end
    end, { desc = 'Go to terminal' })

    -- Close terminal if open, otherwise do nothing
    vim.keymap.set('n', 'T', function()
      if bottom:is_open() then
        bottom:close()
      end
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

    -- Persistent Claude Code tab
    local claude = Terminal:new { cmd = 'claude', direction = 'tab', close_on_exit = false, dir = 'git_dir' }

    vim.keymap.set('n', 'C', function()
      if claude:is_open() then
        vim.api.nvim_set_current_win(claude.window)
      else
        claude:open()
      end
    end, { desc = 'Open Claude Code tab' })

    -- Exit terminal mode
    vim.keymap.set('t', '<C-Space>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })
  end,
}
