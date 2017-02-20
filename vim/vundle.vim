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

call vundle#end()

filetype plugin indent on

"buftabline
let g:buftabline_show=1
let g:buftabline_indicators=1

"ctrlp
let g:ctrlp_user_command = ['.git', 'cd %s && git ls-files']

"fugitive
nnoremap <C-g>b :Gblame<CR>

"BufExplorer
let g:bufExplorerDisableDefaultKeyMapping=1
noremap <silent> <F12> :BufExplorer<CR>
noremap <silent> <C-F12> :BufExplorerVerticalSplit<CR>
noremap <silent> <A-F12> :BufExplorerHorizontalSplit<CR>
