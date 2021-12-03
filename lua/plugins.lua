return require('packer').startup(function()
    
    -- Packer can manage itself as an optinal plugin
    use { 'wbthomason/packer.nvim', opt = true}

    -- Color scheme
    use { 'dylanaraps/wal.vim' }

    -- Fuzzy finder
    use {
        'nvim-telescope/telescope.nvim',
        requires = {{'nvim-lua/popup.nvim'}, {'nvim-lua/plenary.nvim'}}
    }

    -- LSP and completion
    use { 'neovim/nvim-lspconfig' }
    use { 'hrsh7th/nvim-compe' }
    use { 'nvim-lua/completion-nvim' }

    -- Rust development
    use {
        'simrat39/rust-tools.nvim',
        requires = {
            { 'neovim/nvim-lspconfig' },
            { 'nvim-lua/popup.nvim' },
            { 'nvim-lua/plenary.nvim' },
            { 'nvim-telescope/telescope.nvim' },
        }
    }

    -- Lua development
    use { 'tjdevries/nlua.nvim' }

    -- Vim dispatch
    use { 'tpope/vim-dispatch' }

    -- Highlight word under cursor
    -- use { 'RRethy/vim-illuminate' }

    -- Which key
    use {
        'folke/which-key.nvim',
        config = function() require('which-key').setup {} end
    }

    -- Spashscreen
    use { 'glepnir/dashboard-nvim' }

    -- Status bar
    use {
      'hoob3rt/lualine.nvim',
    }

    -- Indent guides
    use { 'Yggdroot/indentLine' }

    -- Easy motion
    use { 'easymotion/vim-easymotion' }

end)
