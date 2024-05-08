return {
  {
    'benlubas/molten-nvim',
    dependencies = { '3rd/image.nvim' },
    build = ':UpdateRemotePlugins',
    init = function()
      vim.g.molten_image_provider = 'image.nvim'
      vim.g.molten_use_border_highlights = true
      -- add a few new things

      -- don't change the mappings (unless it's related to your bug)
      vim.keymap.set('n', '<localleader>mi', ':MoltenInit<CR>')
      vim.keymap.set('n', '<localleader>me', ':MoltenEvaluateOperator<CR>')
      vim.keymap.set('n', '<localleader>mr', ':MoltenReevaluateCell<CR>')
      vim.keymap.set('v', '<localleader>mr', ':<C-u>MoltenEvaluateVisual<CR>gv')
      vim.keymap.set('n', '<localleader>mo', ':noautocmd MoltenEnterOutput<CR>')
      vim.keymap.set('n', '<localleader>moh', ':MoltenHideOutput<CR>')
      vim.keymap.set('n', '<localleader>md', ':MoltenDelete<CR>')
    end,
  },
  {
    '3rd/image.nvim',
    opts = {
      backend = 'kitty',
      integrations = {},
      max_width = 100,
      max_height = 12,
      max_height_window_percentage = math.huge,
      max_width_window_percentage = math.huge,
      window_overlap_clear_enabled = true,
      window_overlap_clear_ft_ignore = { 'cmp_menu', 'cmp_docs', '' },
      tmux_show_only_in_active_window = true,
    },
    -- version = '1.1.0', -- or comment out for latest
  },
  {
    'vhyrro/luarocks.nvim',
    priority = 1001, -- this plugin needs to run before anything else
    opts = {
      rocks = { 'magick' },
    },
  },
  {
    'GCBallesteros/jupytext.nvim',
    -- Depending on your nvim distro or config you may need to make the loading not lazy
    lazy = true,
    config = {
      style = 'markdown',
      output_extension = 'md',
      force_ft = 'markdown',
    },
  },
}
