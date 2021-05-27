" -----------------------------------------------------------------------------

if ! filereadable(expand('~/.config/nvim/autoload/plug.vim'))
	echo "Downloading junegunn/vim-plug to manage plugins..."
	silent !mkdir -p ~/.config/nvim/autoload/
	silent !curl "https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim" > ~/.config/nvim/autoload/plug.vim
	autocmd VimEnter * PlugInstall
endif

" -- PLUGINS/SETTINGS ---------------------------------------------------------

call plug#begin('~/.config/nvim/plugged')

" better statusline
    Plug 'vim-airline/vim-airline'
    Plug 'vim-airline/vim-airline-themes'

" allows use of vifm as a file picker
    Plug 'vifm/vifm.vim'

" a code-completion engine for Vim
    Plug 'valloric/youcompleteme'

" automatic keyboard layout switching in insert mode
    Plug 'lyokha/vim-xkbswitch'

" makes text more readable
    Plug 'junegunn/goyo.vim'

" simple tool to paste images into markdown files
    Plug 'ferrine/md-img-paste.vim'

call plug#end()

" Airline theme
    let g:airline_theme='base16_bright'
    let g:airline_powerline_fonts = 1
    let g:Powerline_symbols='unicode'
    let g:airline#extensions#tabline#enabled = 1

" Activate xkbswitch
    let g:XkbSwitchEnabled = 1

" Toggle Goyo (F8 key)
    map <silent> <F8> :Goyo<CR>

" Markdown image paste
    autocmd FileType markdown nmap <silent> <F4> :call mdip#MarkdownClipboardImage()<CR>
    " there are some defaults for image directory and image name, you can change them
    let g:mdip_imgdir = 'img'
    let g:mdip_imgname = 'image'

" -- GENERAL ------------------------------------------------------------------

" Basic
    set autoread                    " detect when a file has been modified externally
    set ignorecase                  " ignoring case in a pattern
	set laststatus=2                " displaying status line always
	set encoding=utf-8              " default character encoding
    set updatetime=400              " time of idleness is milliseconds before saving swapfile
    set undolevels=10000            " how many undo levels to keep in memory
    set nostartofline               " keep cursor in the same column when moving between lines
    set errorbells                  " ring the bell for errors
    set visualbell                  " then use a flash instead of a beep sound
    set smartcase                   " ignore case if the search contains majuscules
    set hlsearch                    " highlight all matches of last search
    set incsearch                   " enable incremental searching (get feedback as you type)
    set backspace=indent,eol,start  " backspace key should delete indentation, line ends, characters
    set textwidth=0                 " hard wrap at this column
    set joinspaces                  " insert two spaces after punctuation marks when joining multiple lines into one
	set mouse=a                     " enable mouse support
	set colorcolumn=80              " setup a ruler
	set wrap                        " automatic word wrapping
	set number relativenumber       " relative line number
    set history=10000               " number of lines that are remembered
	set clipboard+=unnamedplus      " clipboard integration
    "set formatoptions+=t

    colorscheme torte
	let mapleader=","
	syntax on

" Spaces & Tabs
	set tabstop=4       " tab character width
    set shiftwidth=4    " needs to be the same as tabstop
	set softtabstop=4   " number of spaces in tab when editing
	set shiftwidth=4    " needs to be the same as tabstop
    set list            " displaying tabs as characters
	set expandtab       " tabs are space
    set autoindent      " indent automatically (useful for formatoptions)
    set copyindent      " copy indent from the previous line

" GUI
    set guifont=Hack:h14

" Persistent Undo
    set undofile                    " save undoes after file closes
    set undodir=~/.vim-undo-dir     " where to store the undo files
    set undolevels=10000            " max number of changes that can be undone

" Cursor
    let &t_SI.="\e[5 q" "SI = INPUT mode
    let &t_SR.="\e[3 q" "SR = REPLACE mode
    let &t_EI.="\e[1 q" "EI = NORMAL mode

" -- OTHERS -------------------------------------------------------------------

" Vertical Split & Explore
    map <silent> <F10> :Vexplore<CR>

" Automatic word wrapping textwidth
    map <F5> :set textwidth=72<CR>
    map <S-F5> : set textwidth=0<CR>

" Toggle word wrap. Change how text is displayed.
    map  <F6> :set nowrap!<CR>

" Toggle spell-check (F7 key)
    map  <F7> :setlocal spell! spelllang=en,ru<CR>

" Disables automatic commenting on newline:
	autocmd FileType * setlocal formatoptions-=c formatoptions-=r formatoptions-=o

" Copy selected text to system clipboard (requires gvim/nvim/vim-x11 installed):
	vnoremap <C-c> "+y
	map <C-p> "+P

" Automatically deletes all trailing whitespace on save.
	autocmd BufWritePre * %s/\s\+$//e

" Compile dwm when changed
    autocmd BufWritePost config.h !sudo make clean install
