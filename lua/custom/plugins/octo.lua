-- People offered when assigning via <localleader>ca in an Octo buffer.
-- Extend this list with your teammates' GitHub logins.
local my_assignees = {
  'elliotBlommaert',
}

-- Mnemonic for Octo buffer mappings: <localleader>c = "change", then the
-- object. Lowercase adds, uppercase removes:
--   cc/cC comment, cr reply, cl/cL label, ca/cA assignee, cv/cV reviewer,
--   ct/cT issue type, cm/cM milestone, cs suggestion (reviews), cx close, co reopen.
-- The description/title have no mapping: edit the buffer text and `:w` to sync.
-- Navigation follows the global ù = previous / µ = next convention.
local change_mappings = {
  close_issue = { lhs = '<localleader>cx', desc = 'change state: close' },
  reopen_issue = { lhs = '<localleader>co', desc = 'change state: reopen' },
  add_comment = { lhs = '<localleader>cc', desc = 'change comment: add' },
  delete_comment = { lhs = '<localleader>cC', desc = 'change comment: delete' },
  add_reply = { lhs = '<localleader>cr', desc = 'change comment: reply' },
  add_label = { lhs = '<localleader>cl', desc = 'change label: add' },
  remove_label = { lhs = '<localleader>cL', desc = 'change label: remove' },
  remove_assignee = { lhs = '<localleader>cA', desc = 'change assignee: remove' },
  -- add_assignee stays on its default <localleader>aa as a search-everyone
  -- fallback; <localleader>ca (defined below) picks from `my_assignees`.
  next_comment = { lhs = 'µc', desc = 'next comment' },
  prev_comment = { lhs = 'ùc', desc = 'previous comment' },
}

return { -- GitHub issues and PRs inside Neovim (uses the `gh` CLI)
  'pwntester/octo.nvim',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-telescope/telescope.nvim',
    'nvim-tree/nvim-web-devicons',
  },
  cmd = 'Octo',
  keys = {
    { '<leader>Oi', '<cmd>Octo issue list<cr>',   desc = '[O]cto [i]ssue list' },
    { '<leader>OI', '<cmd>Octo issue create<cr>', desc = '[O]cto [I]ssue create' },
    { '<leader>Op', '<cmd>Octo pr list<cr>',      desc = '[O]cto [p]r list' },
    { '<leader>OP', '<cmd>Octo pr create<cr>',    desc = '[O]cto [P]r create' },
    { '<leader>Or', '<cmd>Octo review<cr>',       desc = '[O]cto [r]eview (start/resume)' },
    { '<leader>Os', '<cmd>Octo search<cr>',       desc = '[O]cto [s]earch' },
    { '<leader>Oo', '<cmd>Octo<cr>',              desc = '[O]cto picker (all commands)' },
  },
  opts = {
    picker = 'telescope',
    enable_builtin = true, -- `:Octo` with no args opens a picker of all subcommands
    default_to_projects_v2 = true,
    users = 'assignable',  -- assignee/reviewer pickers list repo collaborators, not all of GitHub
    mappings = {
      issue = change_mappings,
      pull_request = vim.tbl_extend('force', change_mappings, {
        add_reviewer = { lhs = '<localleader>cv', desc = 'change reviewer: add' },
        remove_reviewer = { lhs = '<localleader>cV', desc = 'change reviewer: remove' },
      }),
      review_thread = {
        add_comment = { lhs = '<localleader>cc', desc = 'change comment: add' },
        delete_comment = { lhs = '<localleader>cC', desc = 'change comment: delete' },
        add_reply = { lhs = '<localleader>cr', desc = 'change comment: reply' },
        add_suggestion = { lhs = '<localleader>cs', desc = 'change suggestion: add' },
        next_comment = { lhs = 'µc', desc = 'next comment' },
        prev_comment = { lhs = 'ùc', desc = 'previous comment' },
        select_next_entry = { lhs = '<Tab>', desc = 'next changed file' },
        select_prev_entry = { lhs = '<S-Tab>', desc = 'previous changed file' },
      },
      review_diff = {
        add_review_comment = { lhs = '<localleader>cc', desc = 'change comment: add', mode = { 'n', 'x' } },
        add_review_suggestion = { lhs = '<localleader>cs', desc = 'change suggestion: add', mode = { 'n', 'x' } },
        next_thread = { lhs = 'µt', desc = 'next comment thread' },
        prev_thread = { lhs = 'ùt', desc = 'previous comment thread' },
        select_next_entry = { lhs = '<Tab>', desc = 'next changed file' },
        select_prev_entry = { lhs = '<S-Tab>', desc = 'previous changed file' },
        select_first_entry = { lhs = 'ùQ', desc = 'first changed file' },
        select_last_entry = { lhs = 'µQ', desc = 'last changed file' },
        select_next_unviewed_entry = { lhs = 'µu', desc = 'next unviewed file' },
        select_prev_unviewed_entry = { lhs = 'ùu', desc = 'previous unviewed file' },
      },
      file_panel = {
        select_next_entry = { lhs = '<Tab>', desc = 'next changed file' },
        select_prev_entry = { lhs = '<S-Tab>', desc = 'previous changed file' },
        select_first_entry = { lhs = 'ùQ', desc = 'first changed file' },
        select_last_entry = { lhs = 'µQ', desc = 'last changed file' },
        select_next_unviewed_entry = { lhs = 'µu', desc = 'next unviewed file' },
        select_prev_unviewed_entry = { lhs = 'ùu', desc = 'previous unviewed file' },
      },
    },
  },
  config = function(_, opts)
    require('octo').setup(opts)

    -- Assign from the hardcoded list above instead of searching GitHub.
    vim.api.nvim_create_autocmd('FileType', {
      pattern = 'octo',
      group = vim.api.nvim_create_augroup('octo-custom-mappings', { clear = true }),
      callback = function(event)
        vim.keymap.set('n', '<localleader>ca', function()
          vim.ui.select(my_assignees, { prompt = 'Assign user:' }, function(choice)
            if choice then vim.cmd('Octo assignee add ' .. choice) end
          end)
        end, { buffer = event.buf, desc = 'change assignee: add (from my list)' })

        -- Issue types have no default mapping; `Octo type add` opens a picker
        -- of the repo's issue types (issues only, not PRs).
        vim.keymap.set('n', '<localleader>ct', '<cmd>Octo type add<cr>',
          { buffer = event.buf, desc = 'change type: set' })
        vim.keymap.set('n', '<localleader>cT', '<cmd>Octo type remove<cr>',
          { buffer = event.buf, desc = 'change type: remove' })

        -- Milestones also ship without a default mapping; `Octo milestone add`
        -- opens a picker of the repo's milestones (works on issues and PRs).
        vim.keymap.set('n', '<localleader>cm', '<cmd>Octo milestone add<cr>',
          { buffer = event.buf, desc = 'change milestone: set' })
        vim.keymap.set('n', '<localleader>cM', '<cmd>Octo milestone remove<cr>',
          { buffer = event.buf, desc = 'change milestone: remove' })
      end,
    })
  end,
}
