local utils = require('utils')

local cmd = vim.cmd
local indent = 2

cmd 'syntax enable'
cmd 'filetype plugin indent on'
utils.opt('b', 'expandtab', true)
utils.opt('b', 'shiftwidth', indent)
utils.opt('b', 'smartindent', true)
utils.opt('b', 'tabstop', indent)
utils.opt('o', 'hidden', true)
utils.opt('o', 'ignorecase', true)
utils.opt('o', 'scrolloff', 4)
utils.opt('o', 'shiftround', true)
utils.opt('o', 'smartcase', true)
utils.opt('o', 'splitbelow', true)
utils.opt('o', 'splitright', true)
utils.opt('o', 'wildmode', 'list:longest')
utils.opt('w', 'number', true)
utils.opt('w', 'relativenumber', true)
utils.opt('o', 'clipboard', 'unnamed,unnamedplus')
utils.opt('o', 'mouse', 'a')
utils.opt('o', 'signcolumn', 'yes')

-- Highlight on yank
vim.cmd 'au TextYankPost * lua vim.highlight.on_yank {on_visual = true}'

vim.o.updatetime = 100
vim.cmd 'autocmd CursorHold,CursorHoldI * lua vim.diagnostic.open_float({focusable=false})'

-- Autosave on alt-tabbing type stuff
vim.cmd 'au FocusLost * silent! wa'
vim.cmd 'set autowriteall'
vim.cmd 'set nowrap'

-- Set spell checking
vim.cmd 'autocmd FileType markdown setlocal spell' -- markdown
vim.cmd 'autocmd FileType gitcommit setlocal spell' -- git commit

-- Set spell completion
vim.cmd 'autocmd FileType markdown setlocal complete+=kspell' -- markdown
vim.cmd 'autocmd FileType gitcommit setlocal complete+=kspell' -- git commit
