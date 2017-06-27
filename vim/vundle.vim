"------------------------------------------------------------------------------
"config
"------------------------------------------------------------------------------

"buftabline
let g:buftabline_show = 1
let g:buftabline_indicators = 1

"ctrlp
let g:ctrlp_user_command = ['.git', 'cd %s && git ls-files']

"fugitive
nnoremap <C-g>b :Gblame<CR>

"bufexplorer
let g:bufExplorerDisableDefaultKeyMapping = 1
noremap <silent> <F12> :silent BufExplorer<CR>

"syntastic
let g:syntastic_check_on_wq = 0
let g:syntastic_python_checkers = ['pylint']
if filereadable('extras/pylint/pylintrc')
	let g:syntastic_python_pylint_args = '--rcfile=extras/pylint/pylintrc'
endif

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
Plugin 'godlygeek/tabular'
Plugin 'jlanzarotta/bufexplorer'
Plugin 'tpope/vim-fugitive'
Plugin 'kchmck/vim-coffee-script'
Plugin 'digitaltoad/vim-pug'

call vundle#end()

filetype plugin indent on
