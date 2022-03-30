local utils = require('utils')

utils.map('n', '<C-c>', '<cmd>noh<CR>') -- Clear highlights
utils.map('i', '<C-j>', '<Esc>') -- Escape with C-j

-- Tab and window movement
utils.map('n', '<C-l>', ':tabn<CR>')
utils.map('n', '<C-h>', ':tabp<CR>')
utils.map('n', '<C-j>', '<C-w>w')
utils.map('n', '<C-k>', '<C-w>W')

-- No arrow keys --- force yourself to use the home row
utils.map('', '<up>', '<nop>')
utils.map('', '<down>', '<nop>')
utils.map('', '<left>', '<nop>')
utils.map('', '<right>', '<nop>')

-- TODO listing
-- utils.map('', '', ':grep TODO')

-- SPC SPC to switch between buffers quickly
-- utils.map('n', '<leader>q', '<C-^>')
