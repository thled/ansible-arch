" auto-install vim-plug
if empty(glob('~/.config/nvim/autoload/plug.vim'))
  silent !curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall
endif

call plug#begin()

" theme
Plug 'morhetz/gruvbox'

" statusline
Plug 'itchyny/lightline.vim'

" search
Plug 'junegunn/fzf.vim'

" autocomplete + navigation
Plug 'neoclide/coc.nvim', {'branch': 'release'}

" git
Plug 'mhinz/vim-signify'

" comment in/out
Plug 'tpope/vim-commentary'

" surround
Plug 'tpope/vim-surround'

" additional text objects
Plug 'wellle/targets.vim'

" switch true/false
Plug 'zef/vim-cycle'

call plug#end()

" Automatically install missing plugins on startup
autocmd VimEnter *
  \  if len(filter(values(g:plugs), '!isdirectory(v:val.dir)'))
  \|   PlugInstall --sync | q
  \| endif

