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

    -- ... and there is more!
    --  Check out: https://github.com/nvim-mini/mini.nvim
  end,
}
