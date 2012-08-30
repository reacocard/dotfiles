

" Pathogen
call pathogen#runtime_append_all_bundles()
call pathogen#helptags()

" Don't bother being compatible with Vi. It sucks.
set nocompatible

" Allow backspacing over everything in insert mode
set backspace=indent,eol,start

" Don't format middle-click pastes
map <MouseMiddle> <Esc>"*p

" Make sure some directories we need later exist
function! EnsureDirExists (dir)
  if !isdirectory(a:dir)
    if exists("*mkdir")
      call mkdir(a:dir,'p')
      echo "Created directory: " . a:dir
    else
      echo "Please create directory: " . a:dir
    endif
  endif
endfunction

call EnsureDirExists($HOME . '/.vim/sessions')
call EnsureDirExists($HOME . '/.vim/undos')

" Move backup files elsewhere - good for slow media and avoiding clutter
set backupdir=~/.vim/sessions/
set dir=~/.vim/sessions/

" swapper no swapping!
set noswapfile

" persistent undo
if has('persistent_undo')
    set undofile
    set undodir=~/.vim/undos/
endif

" pretty colors!
syntax on
colorscheme relaxedgreen

" The PC is fast enough, do syntax highlight syncing from start
syntax sync fromstart

set hidden

" Enable filetype plugins and indention
filetype on
filetype plugin on
filetype indent on

" show position always
set ruler

" improve drawing speed
set ttyfast

" try to be smart about indenting
set autoindent  smartindent

" Better Search
set hlsearch
set incsearch
set showmatch

" show incomplete commands
set showcmd

" utf-8 default encoding
set enc=utf-8

" Prefer unix over windows over os9 formats
set fileformats=unix,dos,mac

" Don't bell or blink(Courtesy: Cream Editor).
if has('autocmd')
  autocmd GUIEnter * set vb t_vb=
endif

" hide some files and remove stupid help
let g:netrw_list_hide='^\.,.\(pyc\|pyo\|o\)$'

" make command-mode completion more useful
set wildmenu
set wildmode=list:longest

" scroll before hitting the edge of the window - moar context!
set scrolloff=3

" UI-specific options
if has("gui_running")
    " disable blinking cursor
    set gcr=a:blinkon0 
    
    " make it big enough
    set columns=80
    set lines=40

    " nicer font
    set guifont=Deja\ Vu\ Sans\ Mono\ 10

    " remove toolbar, menubar, scrollbar
    set guioptions-=T
    set guioptions-=m
    set guioptions-=L
    set guioptions-=l
    set guioptions-=r
    set guioptions-=b

    " Hide pointer while typing
    set mousehide
    set mousemodel=popup
else
    " Set the terminal's title
    set title
endif

" Use w!! to write as root
cmap w!! %!sudo tee > /dev/null %

" Python file options
autocmd FileType python setlocal expandtab shiftwidth=4 tabstop=8 softtabstop=4 smartindent cinwords=if,elif,else,for,while,try,except,finally,def,class,with colorcolumn=79 formatoptions+=croq 
let python_highlight_all=1
let python_highlight_exceptions=0
let python_highlight_builtins=0
autocmd FileType pyrex setlocal expandtab shiftwidth=4 tabstop=8 softtabstop=4 smartindent cinwords=if,elif,else,for,while,try,except,finally,def,class,with



" vim file options
autocmd FileType vim setlocal expandtab shiftwidth=4 tabstop=8 softtabstop=4


source ~/.vimrc.local
