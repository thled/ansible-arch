set noshowmode
let g:lightline = {
    \ 'colorscheme': 'wombat',
    \ 'active': {
    \     'left': [ [ 'mode', 'paste' ],
    \             [ 'cocstatus', 'readonly', 'absolutepath', 'modified' ] ]
    \ },
    \ 'component_function': {
    \     'cocstatus': 'coc#status'
    \ },
    \ }

