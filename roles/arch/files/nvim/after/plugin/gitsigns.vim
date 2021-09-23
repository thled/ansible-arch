if !filereadable(expand("~/.config/nvim/plugged/gitsigns.nvim/lua/gitsigns.lua"))
    finish
endif

lua <<EOF
require'gitsigns'.setup()
EOF
