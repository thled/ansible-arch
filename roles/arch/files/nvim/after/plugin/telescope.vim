if !exists('g:loaded_telescope')
    finish
endif

" Config
lua << EOF
require('telescope').load_extension('fzf')
EOF


" Mappings
nnoremap <C-p> <cmd>lua require('telescope.builtin').find_files()<cr>
nnoremap <C-f> <cmd>lua require('telescope.builtin').live_grep()<cr>
nnoremap <C-e> <cmd>lua require('telescope.builtin').buffers()<cr>
nnoremap <C-_> <cmd>lua require('telescope.builtin').current_buffer_fuzzy_find()<cr>
