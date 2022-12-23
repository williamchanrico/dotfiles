set nocompatible

syntax on

filetype off
filetype plugin indent on

" Remap leader key
let mapleader=","

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
Plugin 'junegunn/fzf.vim'
Plugin 'davidhalter/jedi-vim'
Plugin 'dense-analysis/ale'
Plugin 'inside/vim-search-pulse'
Plugin 'godlygeek/tabular'
Plugin 'terryma/vim-multiple-cursors'
Plugin 'chr4/nginx.vim'
Plugin 'lepture/vim-jinja'
Plugin 'ryanoasis/vim-devicons'
Plugin 'nvim-plugins/nvim-syntax-go'
Plugin 'buoto/gotests-vim'

call vundle#end()

" buoto/Gotests-vim
" let g:gotests_template_dir = '/home/user/templates/'
" let g:gotests_bin = '/home/user/go/bin/gotests'

" davidhalter/jedi-vim
let g:jedi#goto_definitions_command = "<leader>d"
let g:jedi#documentation_command = "gi"
let g:jedi#goto_command = "gd"
let g:jedi#usages_command = "<leader>s"
let g:jedi#rename_command = "<leader>r"

let g:jedi#goto_assignments_command = "<leader>g"
let g:jedi#goto_stubs_command = "<leader>s"
let g:jedi#completions_command = "<C-Space>"

" Vim gitgutter
nmap <Leader>ga <Plug>GitGutterStageHunk
nmap <Leader>gu <Plug>GitGutterUndoHunk
nmap <Leader>gv <Plug>GitGutterPreviewHunk
nmap <Leader>gh :GitGutterLineHighlightsToggle<CR>

" Vim multiple cursors
let g:multi_cursor_use_default_mapping=0

" Default mapping
let g:multi_cursor_start_word_key      = '<C-c>'
let g:multi_cursor_select_all_word_key = '<A-c>'
let g:multi_cursor_start_key           = 'g<C-c>'
let g:multi_cursor_select_all_key      = 'g<A-c>'
let g:multi_cursor_next_key            = '<C-c>'
let g:multi_cursor_prev_key            = '<C-p>'
let g:multi_cursor_skip_key            = '<C-x>'
let g:multi_cursor_quit_key            = '<Esc>'

" Vimwiki
let g:vimwiki_list = [{'path': '~/vimwiki/',
                       \ 'syntax': 'markdown', 'ext': '.md'}]

" Vim search pulse
let g:vim_search_pulse_mode = 'pattern'

augroup Pulse
	autocmd! User PrePulse
	autocmd! User PostPulse
	autocmd  User PrePulse  set cursorcolumn
	autocmd  User PostPulse set nocursorcolumn
augroup END

autocmd FileType hcl setlocal shiftwidth=2 tabstop=2 expandtab
autocmd FileType yaml setlocal shiftwidth=2 tabstop=2 expandtab
autocmd BufRead,BufNewFile *.tf* set shiftwidth=2 tabstop=2 expandtab ft=tf
autocmd BufRead,BufNewFile *.hcl* set shiftwidth=2 tabstop=2 expandtab ft=tf
autocmd BufRead,BufNewFile *.j2* set ft=jinja
autocmd BufRead,BufNewFile *nginx.conf* set ft=nginx
autocmd BufRead,BufNewFile /dev/shm/pass\.* set ft=yaml

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
let g:ale_linters_explicit=1
let g:ale_lint_on_save=1
let g:ale_linters={
\	'sh': ['shellcheck'],
\   'go': ['gopls', 'golint'],
\   'python': ['pylint'],
\   'html': ['prettier'],
\   'yaml': ['prettier'],
\}
let g:ale_lint_on_text_changed='never'
" Set this variable to 1 to fix files when you save them.
let g:ale_fix_on_save=1
let g:ale_fixers={
\	'python': ['black'],
\	'javascript': ['prettier'],
\	'cpp': ['clang-format'],
\	'sh': ['shfmt'],
\	'yaml': ['prettier'],
\	'css': ['prettier'],
\	'html': ['prettier'],
\	'markdown': ['prettier'],
\	'sql': ['sqlfmt'],
\	'tf': ['terraform'],
\}

let g:ale_c_clangformat_options='-style=webkit'
let g:ale_python_black_options='--fast --line-length 120'
let g:ale_python_black_executable = 'python3'
let g:ale_prettier_use_local_config = 1

nmap <silent> <C-k> <Plug>(ale_previous_wrap)
nmap <silent> <C-j> <Plug>(ale_next_wrap)

" Tabular
nmap <Leader>a= :Tabularize /=<CR>
vmap <Leader>a= :Tabularize /=<CR>
nmap <Leader>a: :Tabularize /:<CR>
vmap <Leader>a: :Tabularize /:<CR>
nmap <Leader>a\| :Tabularize /\|<CR>
vmap <Leader>a\| :Tabularize /\|<CR>

" Nerdtree
map <C-n> :NERDTreeToggle<CR>

" Nerdcommenter
let g:NERDSpaceDelims=1
let g:NERDDefaultAlign='left'

" Vim-better-whitespace
let g:strip_whitespace_on_save=1
let g:show_spaces_that_precede_tabs=1

" Vim-airline
let g:airline_theme='minimalist'
let g:airline#extensions#tabline#enabled=1
let g:airline_powerline_fonts = 1

if !exists('g:airline_symbols')
    let g:airline_symbols = {}
endif
let g:airline_left_sep = ''
let g:airline_left_sep = ''
let g:airline_right_sep = ''
let g:airline_right_sep = ''
let g:airline_symbols.linenr = '␊'
let g:airline_symbols.linenr = '␤'
let g:airline_symbols.linenr = '¶'
let g:airline_symbols.branch = '⎇'
let g:airline_symbols.paste = 'ρ'
let g:airline_symbols.paste = 'Þ'
let g:airline_symbols.paste = '∥'
let g:airline_symbols.whitespace = 'Ξ'

set t_Co=256
colorscheme molokai
set cursorline
hi LineNr term=bold cterm=NONE ctermfg=DarkGrey ctermbg=NONE
			\ gui=NONE guifg=DarkGrey guibg=NONE

" Vim-go
let g:go_highlight_format_strings=1
let g:go_highlight_function_parameters=1
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
let g:go_gopls_gofumpt=0
let g:go_def_mode="gopls"
let g:go_info_mode="gopls"
let g:go_template_autocreate=0
let g:go_rename_command="gopls"

au Filetype go nnoremap <Leader>e :GoIfErr<CR>
au Filetype go nnoremap <Leader>s :GoReferrers<CR>
au Filetype go nnoremap <Leader>d :GoDescribe<CR>
au Filetype go nnoremap <Leader>r :GoRename<Space>
au Filetype go nnoremap <Leader>f :GoDecls<CR>
au Filetype go nnoremap <Leader>c :GoCallees<CR>
au FileType go nmap <Leader>i <Plug>(go-info)

set modeline
set updatetime=100
set hidden
set backspace=indent,eol,start
set nowrap
set tabstop=4
set shiftwidth=0
set number
set showmatch
set matchpairs+=<:>
hi clear MatchParen
hi MatchParen gui=underline cterm=underline
set ignorecase
set smartcase
set hlsearch
set incsearch
set smartindent
set history=1000
set undolevels=1000
set undofile
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
set completeopt=menu,menuone,preview,noselect,noinsert
inoremap <expr> <CR> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
inoremap <expr> <C-n> pumvisible() ? '<C-n>' :
  \ '<C-n><C-r>=pumvisible() ? "\<lt>Down>" : ""<CR>'
inoremap <expr> <M-,> pumvisible() ? '<C-n>' :
  \ '<C-x><C-o><C-n><C-p><C-r>=pumvisible() ? "\<lt>Down>" : ""<CR>'

" Sudo writes
cmap w!! w !sudo tee % >/dev/null

" Remove search highlights
nnoremap <Leader>l :nohlsearch<CR>:diffupdate<CR>:syntax sync fromstart<CR><c-l>

" Toggle showing list chars
set listchars=tab:\>-,trail:.,extends:#,nbsp:.
nnoremap <Leader><tab> :set list!<CR>

" Remove all trailing whitespace by pressing F5
nnoremap <F5> :let _s=@/<Bar>:%s/\s\+$//e<Bar>:let @/=_s<Bar><CR>

" For toggling underline on cursorline and set cursorcolumn
let s:cursorCoordinateState=1
function! ToggleCursorCoordinate()
	if s:cursorCoordinateState
		hi CursorLine gui=underline cterm=underline
		set cursorcolumn
	else
		hi CursorLine gui=none cterm=none
		set nocursorcolumn
	endif
	let s:cursorCoordinateState =  !s:cursorCoordinateState
endfunction

" Bind toggle key underlining cursorline and set cursorcolumn
nnoremap <Leader>v :call ToggleCursorCoordinate()<CR>

" Tab
nnoremap <C-Left> :tabprevious<CR>
nnoremap <C-Right> :tabnext<CR>
nnoremap <silent> <A-Left> :execute 'silent! tabmove ' . (tabpagenr()-2)<CR>
nnoremap <silent> <A-Right> :execute 'silent! tabmove ' . (tabpagenr()+1)<CR>

" URL encode/decode selection
" vnoremap <leader>en :!python2 -c 'import sys,urllib;print urllib.quote(sys.stdin.read().strip())'<cr>
" vnoremap <leader>de :!python2 -c 'import sys,urllib;print urllib.unquote(sys.stdin.read().strip())'<cr>
vnoremap <Leader>enn :<C-u>silent '<,'>!perl -CIO -MHTML::Entities -pe '$_=encode_entities $_'<CR>
vnoremap <Leader>dee :<C-u>silent '<,'>!perl -CI  -MHTML::Entities -pe '$_=decode_entities $_'<CR>
