" auto-install vim-plug
if empty(glob('~/.config/nvim/autoload/plug.vim'))
  silent !curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall
  "autocmd VimEnter * PlugInstall | source $MYVIMRC
endif

call plug#begin()

" statusline
Plug 'itchyny/lightline.vim'

" explorer
Plug 'preservim/nerdtree'

" search
Plug 'junegunn/fzf.vim'

" comment in/out
Plug 'tpope/vim-commentary'

" surround
Plug 'tpope/vim-surround'

" autocomplete + navigation
Plug 'neoclide/coc.nvim', {'branch': 'release'}

" debug
Plug 'vim-vdebug/vdebug'

" php syntax
Plug 'StanAngeloff/php.vim'

call plug#end()

" Automatically install missing plugins on startup
autocmd VimEnter *
  \  if len(filter(values(g:plugs), '!isdirectory(v:val.dir)'))
  \|   PlugInstall --sync | q
  \| endif

