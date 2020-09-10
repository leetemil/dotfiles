set nocompatible            " disable compatibility to old-time vi
set showmatch               " show matching brackets.
set ignorecase              " case insensitive matching
set mouse=v                 " middle-click paste with mouse
set hlsearch                " highlight search results
set tabstop=4               " number of columns occupied by a tab character
set softtabstop=4           " see multiple spaces as tabstops so <BS> does the right thing
set expandtab               " converts tabs to white space
set shiftwidth=4            " width for autoindents
set autoindent              " indent a new line the same amount as the line just typed
set number                  " add line numbers
set wildmode=longest,list   " get bash-like tab completions
set cc=80                   " set an 80 column border for good coding style

filetype plugin indent on   " allows auto-indenting depending on file type
syntax on                   " syntax highlighting

let mapleader = " "
inoremap jk <ESC>
nnoremap <ESC> :noh<RETURN><ESC>

call plug#begin('~/.config/nvim/plugged')
    Plug 'morhetz/gruvbox'
    Plug 'preservim/nerdtree'
    Plug 'valloric/youcompleteme'
    Plug 'vim-airline/vim-airline'
    Plug 'airblade/vim-gitgutter'
    Plug 'scrooloose/syntastic'
    Plug 'tpope/vim-surround'
    Plug 'tpope/vim-fugitive'
    Plug 'takac/vim-hardtime' " this will annoy you, but probably help
    Plug 'junegunn/fzf'
call plug#end()

autocmd vimenter * colorscheme gruvbox

" Syntastic recommended settings
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0

" hardtime activated in every instance buffer
let g:hardtime_default_on = 1
