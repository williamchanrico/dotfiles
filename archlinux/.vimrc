set nocompatible

syntax on

filetype plugin indent on

set hidden
set backspace=indent,eol,start
set nowrap
set tabstop=4
set number
set showmatch
set ignorecase
set smartcase
set hlsearch
set incsearch
set smartindent
set history=1000
set undolevels=1000
set title
set visualbell
set noerrorbells
set nobackup
set noswapfile
set pastetoggle=<F2>
set mouse=a

cmap w!! w !sudo tee % >/dev/null

let mapleader = ","
nnoremap <leader>l :nohlsearch<cr>:diffupdate<cr>:syntax sync fromstart<cr><c-l>
