if !filereadable(expand("~/.config/nvim/plugged/nvim-comment/lua/nvim_comment.lua"))
    finish
endif

lua <<EOF
require'nvim_comment'.setup()
EOF
