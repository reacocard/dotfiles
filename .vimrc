
set nocompatible

" allow backspacing over everything in insert mode
set backspace=indent,eol,start

set backup		" keep a backup file
set history=50		" keep 50 lines of command line history
set ruler		" show the cursor position all the time
set showcmd		" display incomplete commands
set incsearch		" do incremental searching

" Switch syntax highlighting on, when the terminal has colors
" Also switch on highlighting the last used search pattern.
if &t_Co > 2 || has("gui_running")
    syntax on
    set hlsearch
endif

" Only do this part when compiled with support for autocommands.
if has("autocmd")
    " load python awesome
    if !exists("autocommands_loaded")
        let autocommands_loaded = 1
        autocmd BufRead,BufNewFile,FileReadPost *.py source ~/.vim/perlangconfs/python
    endif


    " Enable file type detection.
    " Use the default filetype settings, so that mail gets 'tw' set 
    " to 72, 'cindent' is on in C files, etc.
    " Also load indent files, to automatically do language-dependent 
    " indenting.
    filetype plugin indent on

    " Put these in an autocmd group, so that we can delete them easily.
    augroup vimrcEx
    au!

    " For all text files set 'textwidth' to 78 characters.
    autocmd FileType text setlocal textwidth=78

    augroup END
else
    set autoindent		" always set autoindenting on
endif



set et sts=4 sw=4 "set tab defaults
color relaxedgreen "set colorscheme
set hidden "allow switching buffers without saving
let &guicursor = &guicursor . ",a:blinkon0"
set backupdir=~/.vimswaps//
set directory=~/.vimswaps//

set undofile "allow undo accross close/open
