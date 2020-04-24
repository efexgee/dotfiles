"syntax highlight Salt's .sls files like YAML files
autocmd BufNewFile,BufRead *.sls set filetype=yaml

"don't use tabs
set tabstop=4
set expandtab		"type tabs as spaces
set shiftwidth=4	"what an indent is
set softtabstop=4

"disable macro recording
map q <Nop>

"Syntastic configuration
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

"let g:syntastic_always_populate_loc_list = 1
"let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0
