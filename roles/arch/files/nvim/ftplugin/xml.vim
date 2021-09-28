" indentation
set tabstop=2 softtabstop=2 shiftwidth=2 expandtab smartindent

" folding
set foldmethod=indent
set foldcolumn=auto
set foldminlines=1
set foldlevel=1
set foldtext=MyFoldText()
set fillchars=fold:\ 

function! MyFoldText()
    let line = getline(v:foldstart)
    let folded_line_num = v:foldend - v:foldstart
    let line_text = substitute(line, '^"{\+', '', 'g')
    let fillcharcount = 8 - len(folded_line_num)
    return ' (' . folded_line_num . ')' . repeat(' ', fillcharcount) . trim(getline(v:foldstart)).'...'.trim(getline(v:foldend))
endfunction
