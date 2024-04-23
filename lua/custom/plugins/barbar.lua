return {
  'romgrk/barbar.nvim',
  init = function()
    vim.g.barbar_auto_setup = false
  end,
  dependencies = {
    'lewis6991/gitsigns.nvim', -- OPTIONAL: for git status
    'nvim-tree/nvim-web-devicons', -- OPTIONAL: for file icons
  },
  opts = {
    animation = true,
    sidebar_filetypes = {
      NvimTree = true,
      ['neo-tree'] = { event = 'BufWipeout' },
    },
  },
}
