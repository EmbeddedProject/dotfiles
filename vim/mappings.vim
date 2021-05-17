"-----------------------------------------------------------------------------
"Key mappings
"-----------------------------------------------------------------------------

if &term =~ '\v^(tmux|screen)'
	" tmux will send xterm-style keys when its xterm-keys option is on
	execute "set <F13>=\e[5;5~"
	execute "map <F13> <C-PageUp>"
	execute "map! <F13> <C-PageUp>"

	execute "set <F14>=\e[6;5~"
	execute "map <F14> <C-PageDown>"
	execute "map! <F14> <C-PageDown>"

	execute "set <F15>=\e[1;7A"
	execute "map <F15> <C-A-up>"
	execute "map! <F15> <C-A-up>"

	execute "set <F16>=\e[1;7B"
	execute "map <F16> <C-A-down>"
	execute "map! <F16> <C-A-down>"

	execute "set <F17>=\e[1;5C"
	execute "map <F17> <C-right>"
	execute "map! <F17> <C-right>"

	execute "set <F18>=\e[1;5D"
	execute "map <F18> <C-left>"
	execute "map! <F18> <C-left>"
endif

let mapleader = ','

"Cursor Movement
"Make cursor move by visual lines instead of file lines (when wrapping)
map <up> gk
map k gk
imap <up> <C-o>gk
map <down> gj
map j gj
imap <down> <C-o>gj

"Navigate through errors (location list)
function NextError()
	try
		execute "lnext"
	catch /^Vim\%((\a\+)\)\=:E553/
		execute "lfirst"
	catch /^Vim\%((\a\+)\)\=:E\%(776\|42\):/
		echohl ErrorMsg
		echomsg "No errors"
		echohl None
	endtry
endfunction

function PrevError()
	try
		execute "lprev"
	catch /^Vim\%((\a\+)\)\=:E553/
		execute "llast"
	catch /^Vim\%((\a\+)\)\=:E\%(776\|42\):/
		echohl ErrorMsg
		echomsg "No errors"
		echohl None
	endtry
endfunction

nnoremap e :call NextError()<CR>
nnoremap E :call PrevError()<CR>

"Delete line with <ctrl-d>
inoremap <C-d> <Esc>ddi
vnoremap <C-d> d
nnoremap <C-d> dd

"Move lines up and down with <Ctrl-Alt-up> & <Ctrl-Alt-down> keys
nnoremap <C-A-down> :m+<CR>==
nnoremap <C-A-up> :m-2<CR>==
inoremap <C-A-down> <Esc>:m+<CR>==gi
inoremap <C-A-up> <Esc>:m-2<CR>==gi
vnoremap <C-A-down> :m'>+<CR>gv=gv
vnoremap <C-A-up> :m-2<CR>gv=gv

"Indent selection with <tab> key
vnoremap <tab> >gv
"Unindent seletction with <Shift-tab> command
vnoremap <S-tab> <gv

"Reflow current paragraph with F
nnoremap F gqap
vnoremap F gq

"Insert New Line
map <S-Enter> O<Esc>
map <Enter> o<Esc>

"Disable cursor blink (t_RC) and cursor style (t_RS) term responses to allow
"esc-based mappings with recent vim versions
set t_RC= t_RS=
nnoremap <Esc>P :set paste!<CR>
nnoremap <Esc>N :set number!<CR>

"Only tabs (8 spaces per level)
map <F5> :set shiftwidth=8<CR>:set tabstop=8<CR>:set noexpandtab<CR>:set softtabstop=8<CR>
"Only spaces (4 spaces by level)
map <F6> :set shiftwidth=4<CR>:set tabstop=4<CR>:set expandtab<CR>:set softtabstop=4<CR>
"Only spaces (2 spaces by level)
map <F7> :set shiftwidth=2<CR>:set tabstop=2<CR>:set expandtab<CR>:set softtabstop=2<CR>

"Allow switching buffers without saving
set hidden
"Switch buffers bindings
nnoremap <C-PageUp> :bprev<CR>
nnoremap <C-PageDown> :bnext<CR>

nnoremap <F9> :set spell!<CR>

nnoremap bb :bd<CR>

" copy to attached terminal using the yank(1) script:
" https://github.com/sunaku/home/blob/master/bin/yank
function! Yank(text) abort
	let escape = system('~/bin/yank', a:text)
	if v:shell_error
		echoerr escape
	else
		call writefile([escape], '/dev/tty', 'b')
	endif
endfunction

" automatically run yank(1) whenever yanking in Vim
" (this snippet was contributed by Larry Sanderson)
function! CopyYank() abort
	call Yank(join(v:event.regcontents, "\n"))
endfunction
autocmd TextYankPost * call CopyYank()

nnoremap <silent> P :let @t=system('tmux show-buffer')<CR>"tp

"-----------------------------------------------------------------------------
"6WIND
"-----------------------------------------------------------------------------

function InsertAckedBy()
	let expr = input('Acked-by: ')
	if expr == ''
		return
	endif
	let cmd = '/mnt/sources/clones/infrastructure/admin-tools/acked-by.py ' . expr
	put =system(cmd)
endfunction

nnoremap <F4> :call InsertAckedBy()<CR>

function InsertFixes()
	let commitid = input('Fixes: ')
	if commitid == ''
		return
	endif
	let cmd = 'git lfixes -n1 ' . commitid
	put =system(cmd)
endfunction

nnoremap <F2> :call InsertFixes()<CR>

"Pipe selection to hastebin and print URL in statusbar
vnoremap Y <esc>:'<,'>:w !haste<CR>

function InsertLicense()
	let license = 'Copyright ' . strftime('%Y') . ' 6WIND S.A.'

	if b:current_syntax == 'rst'
		let copyright = '.. ' . license
	elseif b:current_syntax == 'c' || b:current_syntax == 'c+ifdef'
		let copyright = '/* ' . license . ' */'
	elseif b:current_syntax == 'vim'
		let copyright = '"' . license
	else "shell, python, Makefile, etc.
		let copyright = '# ' . license
	endif

	put =copyright
endfunction

nnoremap <C-l> :call InsertLicense()<CR>

"-----------------------------------------------------------------------------
"tags
"-----------------------------------------------------------------------------

nnoremap <silent> ù <C-]>
nnoremap <silent> ! :silent tnext<CR>

"-----------------------------------------------------------------------------
"Cscope
"-----------------------------------------------------------------------------

set cscopetag " use cscope with ctags shortcuts
set cspc=9 " display full path names
set cscoperelative

if filereadable("./cscope.out")
	cscope add ./cscope.out
elseif filereadable("../cscope.out")
	cscope add ../cscope.out
elseif filereadable("../../cscope.out")
	cscope add ../../cscope.out
elseif filereadable("../../../cscope.out")
	cscope add ../../../cscope.out
elseif filereadable("../../../../cscope.out")
	cscope add ../../../../cscope.out
elseif $CSCOPE_DB != ""
	cscope add $CSCOPE_DB
endif

"Basic keymaps
nnoremap <F3> :cs find g <C-R>=expand("<cword>")<CR><CR>   " global definition
nnoremap <F8> :cs find c <C-R>=expand("<cword>")<CR><CR>   " functions calling
