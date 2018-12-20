"------------------------------------------------------------------------------
"config
"------------------------------------------------------------------------------

"buftabline
let g:buftabline_show = 1
let g:buftabline_indicators = 1

"ctrlp
let g:ctrlp_user_command = ['.git', 'cd %s; { git ls-files -com --exclude-standard; git submodule --quiet foreach --recursive "git ls-files -com --exclude-standard | sed s,^,\$path/,"; } | sort -u']

"fugitive
nnoremap <C-g>b :Gblame<CR>

"jedi
"let g:jedi#popup_on_dot = 0
let g:jedi#show_call_signatures = 2
let g:jedi#goto_command = "<F3>"
autocmd FileType python setlocal completeopt-=preview

"ale
let g:ale_virtualenv_dir_names = ['.venv']
let g:ale_linters_explicit = 1
let g:ale_linters = { 'python': ['flake8', 'pylint'] }
let g:ale_set_signs = 0
let g:ale_cache_executable_check_failures = 1
let g:ale_use_global_executables = 0

"------------------------------------------------------------------------------
"initialization
"------------------------------------------------------------------------------
filetype off

set runtimepath+=~/.vim/bundle/Vundle.vim

call vundle#begin()

"let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'

"Plugins
Plugin 'ap/vim-buftabline'
Plugin 'ctrlpvim/ctrlp.vim'
Plugin 'editorconfig/editorconfig-vim'
Plugin 'tpope/vim-fugitive'
Plugin 'neomutt/neomutt.vim'
Plugin 'davidhalter/jedi-vim'
Plugin 'w0rp/ale'


call vundle#end()

filetype plugin indent on
