"------------------------------------------------------------------------------
"config
"------------------------------------------------------------------------------

"buftabline
let g:buftabline_show = 1
let g:buftabline_indicators = 1

function GitRoot()
	let l:d = expand('%:p:h:S')
	let l:root = system('git -C ' . l:d . ' rev-parse --show-toplevel 2>/dev/null')
	let l:root = trim(l:root)
	if l:root == ''
		let l:root = getcwd()
	endif
	return fnamemodify(l:root, ':~:.')
endfunction

"fzf
function GitGrep()
	let l:expr = input('grep: ')
	if l:expr == ''
		return
	endif
	call fzf#vim#grep("git grep --untracked --color " . l:expr, 1, fzf#vim#with_preview(), 0)
endfunction

function GitGrepSymbol()
	let l:expr = expand('<cword>')
	if l:expr == ''
		return
	endif
	call fzf#vim#grep("git grep --untracked --color " . l:expr, 1, fzf#vim#with_preview(), 0)
endfunction
"Tell FZF to use RG - so we can skip .gitignore files even if not using git
"grep
let $FZF_DEFAULT_COMMAND = '/usr/bin/rg --files'
function FindDir(path)
	if a:path == ''
		return
	endif
	exec 'Files ' . a:path
endfunction
nnoremap <C-f> :call FindDir(input('find in dir: '))<Cr>
nnoremap <C-p> :call FindDir(GitRoot())<Cr>
nnoremap <C-g> :call GitGrep()<CR>
nnoremap <C-*> :call GitGrepSymbol()<CR>

"fugitive
nnoremap <C-b> :Git blame<CR>

"jedi
"let g:jedi#popup_on_dot = 0
let g:jedi#show_call_signatures = 2
let g:jedi#goto_command = "<F3>"

"ale
"let g:ale_virtualenv_dir_names = ['.venv']
let g:ale_linters_explicit = 1
let g:ale_linters = { 'python': ['flake8', 'pylint'], 'rust': ['analyzer'], 'javascript': ['eslint'] }
"let g:ale_python_pylint_executable = 'pylint3'
let g:ale_set_signs = 0
let g:ale_cache_executable_check_failures = 1
let g:ale_use_global_executables = 0
let g:ale_completion_enabled = 1
set completeopt=menu,menuone,noselect,noinsert
nnoremap <F3> :ALEGoToDefinition<CR>

"------------------------------------------------------------------------------
"initialization
"------------------------------------------------------------------------------
filetype off

call plug#begin()

"Plugins
Plug 'ap/vim-buftabline'
Plug 'junegunn/fzf'
Plug 'junegunn/fzf.vim'
Plug 'editorconfig/editorconfig-vim'
Plug 'tpope/vim-fugitive'
Plug 'davidhalter/jedi-vim'
Plug 'dense-analysis/ale'
Plug 'cespare/vim-toml'
Plug 'rust-lang/rust.vim'
Plug 'pangloss/vim-javascript'
Plug 'evanleck/vim-svelte'
Plug 'fatih/vim-go'

call plug#end()

filetype plugin indent on
