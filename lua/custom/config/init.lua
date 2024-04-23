-- Set up key mappings in Normal, Insert, and Visual modes
vim.api.nvim_set_keymap('n', '<S-Tab>', '<<', { noremap = true, silent = true })
vim.api.nvim_set_keymap('i', '<S-Tab>', '<Esc><<i', { noremap = true, silent = true })
vim.api.nvim_set_keymap('v', '<S-Tab>', '<gv', { noremap = true, silent = true })
