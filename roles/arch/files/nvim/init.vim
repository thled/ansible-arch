""" Thled's Neovim config

""" Vim-Plug

call plug#begin()

" statusline
Plug 'itchyny/lightline.vim'

" explorer
Plug 'preservim/nerdtree'

" search
Plug 'junegunn/fzf.vim'

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

" nerdtree
let NERDTreeShowHidden=1

" fzf
nnoremap <C-p> :Files<CR>
nnoremap <C-o> :Buffers<CR>
nnoremap <C-g> :GFiles<CR>
nnoremap <C-f> :Rg 

