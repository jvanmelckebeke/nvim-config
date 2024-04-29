require 'custom.config.filetype'
-- Set up key mappings in Normal, Insert, and Visual modes
-- when shift tab is pressed, indent left
vim.api.nvim_set_keymap('n', '<S-Tab>', '<<', { noremap = true, silent = true })
vim.api.nvim_set_keymap('i', '<S-Tab>', '<Esc><<i', { noremap = true, silent = true })
vim.api.nvim_set_keymap('v', '<S-Tab>', '<gv', { noremap = true, silent = true })

-- space + f does telescope live_grep
vim.api.nvim_set_keymap('n', '<Space>f', ':Telescope live_grep<CR>', { noremap = true, silent = true })
