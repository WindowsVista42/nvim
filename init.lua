-- Map leader to space
vim.g.mapleader = ' '

local fn = vim.fn
local execute = vim.api.nvim_command

-- Sensible defaults
require('settings')

-- Auto install packer.nvim if it does not exist
local install_path = fn.stdpath('data')..'/site/pack/packer/opt/packer.nvim'
if fn.empty(fn.glob(install_path)) > 0 then
    execute('!git clone https://github.com/wbthomason/packer.nvim '..'"'..install_path..'"')
end
vim.cmd [[packadd packer.nvim]]
vim.cmd 'autocmd BufWritePost plugins.lua PackerCompile' -- Auto compile when there are changes in plugins.lua

-- Install plugins
require('plugins')

-- Keymappings
require('keybindings')

-- Setup Lua language server using submodule
require('lsp')
require('lang')

-- Read configs
require('config.colorscheme')
require('config.compe')
require('config.completion')
require('config.lualine')
require('config.telescope')

-- Hide TODO highlight (i dont know what sets this so its going here for now)
vim.cmd 'hi clear TODO'
