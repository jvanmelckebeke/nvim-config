return {
  {
    'rmagatti/auto-session',
    config = function()
      require('auto-session').setup {
        log_level = 'error',
        auto_session_suppress_dirs = { '~/', '~/Projects', '~/Downloads', '/' },
        auto_clean_after_session_restore = false,
        pre_save_cmds = {
          'Neotree close',
        },
      }
    end,
  },
}
