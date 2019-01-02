set nocompatible

syntax on

filetype off
filetype plugin indent on

" Enable completion where available.
" This setting must be set before ALE is loaded.
let g:ale_completion_enabled=1

set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

" Let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'

Plugin 'vimwiki/vimwiki'
Plugin 'tomasr/molokai'
Plugin 'jiangmiao/auto-pairs'
Plugin 'vim-airline/vim-airline'
Plugin 'vim-airline/vim-airline-themes'
Plugin 'ntpeters/vim-better-whitespace'
Plugin 'fatih/vim-go'
Plugin 'elzr/vim-json'
Plugin 'scrooloose/nerdtree'
Plugin 'Xuyuanp/nerdtree-git-plugin'
Plugin 'airblade/vim-gitgutter'
Plugin 'scrooloose/nerdcommenter'
Plugin 'ervandew/supertab'
Plugin 'AutoComplPop'
Plugin 'Rainbow-Parenthesis'
Plugin 'junegunn/fzf.vim'
Plugin 'davidhalter/jedi-vim'
Plugin 'w0rp/ale'

call vundle#end()

" FZF
" Customize fzf colors to match your color scheme
let g:fzf_colors =
\ { 'fg':      ['fg', 'Normal'],
  \ 'bg':      ['bg', 'Normal'],
  \ 'hl':      ['fg', 'Comment'],
  \ 'fg+':     ['fg', 'CursorLine', 'CursorColumn', 'Normal'],
  \ 'bg+':     ['bg', 'CursorLine', 'CursorColumn'],
  \ 'hl+':     ['fg', 'Statement'],
  \ 'info':    ['fg', 'PreProc'],
  \ 'border':  ['fg', 'Ignore'],
  \ 'prompt':  ['fg', 'Conditional'],
  \ 'pointer': ['fg', 'Exception'],
  \ 'marker':  ['fg', 'Keyword'],
  \ 'spinner': ['fg', 'Label'],
  \ 'header':  ['fg', 'Comment'] }

" Enable per-command history.
" CTRL-N and CTRL-P will be automatically bound to next-history and
" previous-history instead of down and up. If you don't like the change,
" explicitly bind the keys to down and up in your $FZF_DEFAULT_OPTS.
let g:fzf_history_dir='~/.local/share/fzf-history'

" Remove FZF status line
autocmd! FileType fzf
autocmd  FileType fzf set laststatus=0 noshowmode noruler
  \| autocmd BufLeave <buffer> set laststatus=2 showmode ruler

let g:fzf_command_prefix='Fz'
let g:fzf_commands_expect='alt-enter'

nnoremap <C-p> :FzFiles<CR>

function! s:set_fzf_maps()
  tnoremap <buffer> <C-t> <C-\><C-n>:close<CR>:sleep 100m<CR>:FzFiles<CR>
  tnoremap <buffer> <C-f> <C-\><C-n>:close<CR>:sleep 100m<CR>:FzBuffers<CR>
  tnoremap <buffer> <C-s> <C-\><C-n>:close<CR>:sleep 100m<CR>:FzGFiles?<CR>
  tnoremap <buffer> <C-g> <C-\><C-n>:close<CR>:sleep 100m<CR>:FzAg<CR>
  tnoremap <buffer> <C-l> <C-\><C-n>:close<CR>:sleep 100m<CR>:FzBLines<CR>
  tnoremap <buffer> <C-o> <C-\><C-n>:close<CR>:sleep 100m<CR>:FzHistory<CR>
  tnoremap <buffer> <C-c> <C-\><C-n>:close<CR>:sleep 100m<CR>:FzCommands<CR>
endfunction

augroup fzfMappingsAu
  autocmd!
  autocmd FileType fzf call <SID>set_fzf_maps()
augroup END

" Supertab
let g:SuperTabDefaultCompletionType="<c-n>"

" ALE
let g:airline#extensions#ale#enabled=1
let g:ale_lint_on_text_changed='never'
" Set this variable to 1 to fix files when you save them.
let g:ale_fix_on_save=1
let g:ale_fixers={
\	'python': ['yapf'],
\	'javascript': ['prettier'],
\	'cpp': ['clang-format'],
\	'sh': ['shfmt'],
\	'yaml': ['prettier'],
\	'css': ['prettier'],
\	'html': ['prettier'],
\	'markdown': ['prettier'],
\	'sql': ['sqlfmt'],
\}

let g:ale_c_clangformat_options='-style=webkit'

nmap <silent> <C-k> <Plug>(ale_previous_wrap)
nmap <silent> <C-j> <Plug>(ale_next_wrap)

" Nerdtree
map <C-n> :NERDTreeToggle<CR>

" Nerdcommenter
let g:NERDSpaceDelims=1
let g:NERDDefaultAlign='left'

" Vim-better-whitespace
let g:strip_whitespace_on_save=1
let g:show_spaces_that_precede_tabs=1

" Vim-airline
let g:airline_theme='powerlineish'
let g:airline#extensions#tabline#enabled=1

" vim-sublime-monokai theme
colorscheme molokai
set termguicolors

" Vim-go
let g:go_highlight_format_strings=1
let g:go_highlight_function_arguments=1
let g:go_highlight_function_calls=1
let g:go_highlight_functions=1
let g:go_highlight_operators=1
let g:go_highlight_types=1
let g:go_highlight_extra_types=1
let g:go_highlight_fields=1
let g:go_highlight_generate_tags=1
let g:go_highlight_variable_assignments=1
let g:go_highlight_variable_declarations=1
let g:go_fmt_command="goimports"
let g:go_auto_type_info=1
let g:go_auto_sameids=1

au Filetype go nnoremap <leader>r :GoRun %<CR>
au FileType go nmap <Leader>i <Plug>(go-info)

set updatetime=100
set hidden
set backspace=indent,eol,start
set nowrap
set tabstop=4
set shiftwidth=0
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
set clipboard=unnamedplus
set splitbelow
set splitright

if !has('nvim')
	set ttymouse=xterm2
endif

" Auto completion
set omnifunc=syntaxcomplete#Complete
set completeopt=menuone,longest,preview
inoremap <expr> <CR> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
inoremap <expr> <C-n> pumvisible() ? '<C-n>' :
  \ '<C-n><C-r>=pumvisible() ? "\<lt>Down>" : ""<CR>'
inoremap <expr> <M-,> pumvisible() ? '<C-n>' :
  \ '<C-x><C-o><C-n><C-p><C-r>=pumvisible() ? "\<lt>Down>" : ""<CR>'

" Sudo writes
cmap w!! w !sudo tee % >/dev/null

" Remap leader key
let mapleader=","

" Remove search highlights
nnoremap <leader>l :nohlsearch<cr>:diffupdate<cr>:syntax sync fromstart<cr><c-l>

" Tab
nnoremap <C-Left> :tabprevious<CR>
nnoremap <C-Right> :tabnext<CR>
nnoremap <silent> <A-Left> :execute 'silent! tabmove ' . (tabpagenr()-2)<CR>
nnoremap <silent> <A-Right> :execute 'silent! tabmove ' . (tabpagenr()+1)<CR>
