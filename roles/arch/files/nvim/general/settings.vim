" theme
set background=dark
let g:gruvbox_material_background = 'hard'
autocmd VimEnter * colorscheme gruvbox-material

" leader key
let mapleader = "\<Space>"

" line numbers
set number relativenumber

" search
set ignorecase smartcase

" indentation
set tabstop=4 softtabstop=4 shiftwidth=4 expandtab smartindent

" ruler
set colorcolumn=120
highlight ColorColumn ctermbg=238 guibg=lightgrey

" incremental substitute
set inccommand=nosplit

" allow unsaved buffer switch
set hidden

" do not automatically insert comment
autocmd BufNewFile,BufRead * setlocal formatoptions-=ro

" terminal esc
tnoremap <Esc> <C-\><C-n>

" keymap for no highlighting
nnoremap <nowait><silent> <C-C> :noh<CR>

