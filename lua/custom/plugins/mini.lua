return { -- Collection of various small independent plugins/modules
  'nvim-mini/mini.nvim',
  config = function()
    -- Better Around/Inside textobjects
    --
    -- Examples:
    --  - va)  - [V]isually select [A]round [)]paren
    --  - yinq - [Y]ank [I]nside [N]ext [Q]uote
    --  - ci'  - [C]hange [I]nside [']quote
    -- mini.ai extends Vim's `a`/`i` textobjects.
    --
    -- Core concepts:
    --   Operators:  d/c/y/v + a<key> or i<key>
    --   Modifiers:  `n` = next, `l` = last (e.g. `valn` = select around next)
    --   Count:      1 = nearest, 2 = surrounding, 3 = outer surrounding, ...
    --               (e.g. `2vaF` selects the function *enclosing* the current one)
    --   Motions:    `gù<key>` / `gµ<key>` jump to start/end of textobject
    --               (e.g. `gùF` jump to start of current/previous function def)
    --
    -- Built-in textobjects (always available):
    --   f  = function *call*  e.g. foo(…)   ← call site, not the definition
    --   a  = argument in a function call
    --   t  = HTML/XML tag
    --   q  = quote  (' " ` |)
    --   b  = balanced bracket  ()  []  {}  (alias for )/]/})
    --   ), ], }, >, ' " ` = specific delimiters
    --
    -- Custom textobjects added below (via Treesitter):
    --   F  = function *definition*  (outer = whole def, inner = body only)
    --   c  = class
    --   o  = conditional  (if/else/…)
    --   L  = loop
    --
    -- Examples:
    --   vaF      select Around current Function definition
    --   viF      select Inside current Function definition (body only)
    --   2vaF     select the Function definition *surrounding* the current one
    --   daF      delete the whole function definition
    --   gùF      jump to start of current/previous function definition
    --   gµF      jump to end   of current/previous function definition
    --   vanF     select Around Next Function definition
    --   vif      select Inside current function Call arguments
    --   daa      delete current function Argument (with comma)

    local ai = require 'mini.ai'
    ai.setup {
      n_lines = 500,
      mappings = {
        goto_left  = 'gù',
        goto_right = 'gµ',
      },
      custom_textobjects = {
        -- Function definitions (Treesitter-powered)
        F = ai.gen_spec.treesitter { a = '@function.outer', i = '@function.inner' },
        -- Class definitions
        c = ai.gen_spec.treesitter { a = '@class.outer', i = '@class.inner' },
        -- Conditionals (if/else/switch/…)
        o = ai.gen_spec.treesitter { a = '@conditional.outer', i = '@conditional.inner' },
        -- Loops (for/while/…)
        L = ai.gen_spec.treesitter { a = '@loop.outer', i = '@loop.inner' },
      },
    }

    -- Add/delete/replace surroundings (brackets, quotes, etc.)
    --
    -- - saiw) - [S]urround [A]dd [I]nner [W]ord [)]Paren
    -- - sd'   - [S]urround [D]elete [']quotes
    -- - sr)'  - [S]urround [R]eplace [)] [']
    require('mini.surround').setup()

    -- Simple and easy statusline.
    --  You could remove this setup call if you don't like it,
    --  and try some other statusline plugin
    local statusline = require 'mini.statusline'
    -- set use_icons to true if you have a Nerd Font
    statusline.setup { use_icons = vim.g.have_nerd_font }

    -- You can configure sections in the statusline by overriding their
    -- default behavior. For example, here we set the section for
    -- cursor location to LINE:COLUMN
    ---@diagnostic disable-next-line: duplicate-set-field
    statusline.section_location = function() return '%2l:%-2v/%L' end

    -- Turn the location badge orange when the current buffer has unsaved changes.
    -- Give the repo name its own teal colour while sharing the devinfo background.
    local function set_modified_hl()
      vim.api.nvim_set_hl(0, 'MiniStatuslineModeModified', { fg = '#1a1b26', bg = '#ff9e3b', bold = true })
      vim.api.nvim_set_hl(0, 'MiniStatuslineRepo',         { fg = '#1abc9c', bg = '#3b4261' })
    end
    set_modified_hl()
    vim.api.nvim_create_autocmd('ColorScheme', { callback = set_modified_hl })

    ---@diagnostic disable-next-line: duplicate-set-field
    statusline.active = function()
      local mode, mode_hl = statusline.section_mode { trunc_width = 120 }
      local git           = statusline.section_git { trunc_width = 40 }
      local diff          = statusline.section_diff { trunc_width = 75 }
      local diagnostics   = statusline.section_diagnostics { trunc_width = 75 }
      local lsp           = statusline.section_lsp { trunc_width = 75 }
      local location      = statusline.section_location()
      local search        = statusline.section_searchcount { trunc_width = 75 }

      local repo = (vim.b.gitsigns_head or '') ~= '' and (' ' .. vim.fn.fnamemodify(vim.fn.getcwd(), ':t')) or ''
      local filename
      if repo ~= '' then
        local abs = vim.api.nvim_buf_get_name(0)
        filename = abs ~= '' and vim.fn.fnamemodify(abs, ':.') or '[No Name]'
      else
        filename = statusline.section_filename { trunc_width = 140 }
      end
      local location_hl = vim.bo.modified and 'MiniStatuslineModeModified' or mode_hl

      return statusline.combine_groups {
        { hl = mode_hl,                  strings = { mode } },
        { hl = 'MiniStatuslineRepo',     strings = { repo } },
        { hl = 'MiniStatuslineDevinfo',  strings = { git, diff, diagnostics, lsp } },
        '%<',
        { hl = 'MiniStatuslineFilename', strings = { filename } },
        '%=',
        { hl = location_hl,              strings = { search, location } },
      }
    end

    -- ... and there is more!
    --  Check out: https://github.com/nvim-mini/mini.nvim
  end,
}
