return require('packer').startup(function()
  use  {
    'nvim-lualine/lualine.nvim',
    requires = { 'kyazdani42/nvim-web-devicons', opt = true }
  } 
  use 'rcarriga/nvim-notify'
  use {
    'nvim-treesitter/nvim-treesitter',
    run = ':TSUpdate'
  }
  use 'junegunn/fzf.vim'
  use 'airblade/vim-gitgutter'
  use 'tpope/vim-fugitive'
  use 'tpope/vim-vinegar'
  use 'gelguy/wilder.nvim'
  use 'karb94/neoscroll.nvim'
  use 'ryanoasis/vim-devicons'
  use {
    'neoclide/coc.nvim',
    branch = 'release'
  }
  use 'wbthomason/packer.nvim' -- Package manager
  use 'neovim/nvim-lspconfig' -- Collection of configurations for the built-in LSP client
  use 'hashivim/vim-terraform'
  use 'tpope/vim-commentary' -- enables gc and gcc for commenting
  use 'jasonccox/vim-wayland-clipboard'
end)
