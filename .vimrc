" Pathogen
call pathogen#runtime_append_all_bundles()
call pathogen#helptags()

" Don't bother being compatible with Vi. It sucks.
set nocompatible

" Allow backspacing over everything in insert mode
set backspace=indent,eol,start

" Don't format middle-click pastes
map <MouseMiddle> <Esc>"*p

" disable all state files, so that data doesn't hang around after the original
" files are gone.
set nobackup
set noundofile
set noswapfile

" pretty colors!
syntax on
colorscheme relaxedgreen

" The PC is fast enough, do syntax highlight syncing from start
syntax sync fromstart

" Allow buffers to go into the background
set hidden

" Enable filetype plugins and indention
filetype on
filetype plugin on
filetype indent on

" show position always
set ruler

" hilight current line/column
set cursorline
hi CursorLine term=NONE cterm=NONE ctermbg=236 guibg=Grey20
set cursorcolumn
hi CursorColumn term=NONE cterm=NONE ctermbg=236 guibg=Grey20

" improve drawing speed
set ttyfast

" try to be smart about indenting
set autoindent smartindent

" use multiple of shiftwidth when indenting with '<' and '>'
set shiftround

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

" Enable mouse
set mouse=a

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
cmap w!! %!sudo tee % >/dev/null

" do w!! automatically (suda.vim)
let g:suda_smart_edit = 1

" Recognize included ssh configs
autocmd BufReadPost,BufNewFile .ssh/config.d/* set filetype=sshconfig

" Python file options
autocmd FileType python setlocal expandtab shiftwidth=4 tabstop=8 softtabstop=4 smartindent cinwords=if,elif,else,for,while,try,except,finally,def,class,with formatoptions+=croq textwidth=0
let python_highlight_all=1
let python_highlight_exceptions=0
let python_highlight_builtins=0

" vim file options
autocmd FileType vim setlocal expandtab shiftwidth=4 tabstop=8 softtabstop=4


let file = expand("~/.vimrc.local")
if filereadable(file)
    source ~/.vimrc.local
endif
