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

call vundle#end()

filetype plugin indent on
