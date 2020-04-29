""" Thled's Neovim config

""" Vim-Plug

call plug#begin()

" statusline
Plug 'itchyny/lightline.vim'

" explorer
Plug 'preservim/nerdtree'

" comment in/out
Plug 'tpope/vim-commentary'

call plug#end()

""" Vim Config

" line numbers
set number relativenumber

" search
set ignorecase smartcase

" indentation
set tabstop=4 softtabstop=4 shiftwidth=4 expandtab smartindent

""" Plugin Config

" lightline
set noshowmode
let g:lightline = {
    \ 'colorscheme': 'wombat',
    \ }
