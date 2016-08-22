"-----------------------------------------------------------------------------
"Key mappings
"-----------------------------------------------------------------------------

"Cursor Movement
"Make cursor move by visual lines instead of file lines (when wrapping)
map <up> gk
map k gk
imap <up> <C-o>gk
map <down> gj
map j gj
imap <down> <C-o>gj
map E ge

"Delete line with <ctrl-d>
inoremap <C-d> <Esc>ddi
vnoremap <C-d> d
nnoremap <C-d> dd

"Move lines up and down with <Alt-up> & <Alt-down> keys
nnoremap <A-down> :m+<CR>==
nnoremap <A-up> :m-2<CR>==
inoremap <A-down> <Esc>:m+<CR>==gi
inoremap <A-up> <Esc>:m-2<CR>==gi
vnoremap <A-down> :m'>+<CR>gv=gv
vnoremap <A-up> :m-2<CR>gv=gv

nnoremap <A-left> [m
nnoremap <A-right> ]m

"Indent selection with <tab> key
vnoremap <tab> >gv
"Unindent seletction with <Shift-tab> command
vnoremap <S-tab> <gv

"Reflow current paragraph with F
nnoremap F gqap

"Insert New Line
map <S-Enter> O<ESC>
nnoremap <Enter> o<ESC>

"Display <tab>s etc...
nnoremap <C-p> :set paste!<CR>
nnoremap <C-n> :set number!<CR>

"Only tabs (8 spaces per level)
map <F5> :set shiftwidth=8<CR>:set tabstop=8<CR>:set noexpandtab<CR>:set softtabstop=8<CR>
"Only spaces (4 spaces by level)
map <F6> :set shiftwidth=4<CR>:set tabstop=4<CR>:set expandtab<CR>:set softtabstop=4<CR>
"Only spaces (2 spaces by level)
map <F7> :set shiftwidth=2<CR>:set tabstop=2<CR>:set expandtab<CR>:set softtabstop=2<CR>

"Vim fugitive bindings
nnoremap <C-g>b :Gblame<CR>

"Buffer Explorer plugin
let g:bufExplorerDisableDefaultKeyMapping=1
noremap <silent> <F12> :BufExplorer<CR>
noremap <silent> <C-F12> :BufExplorerVerticalSplit<CR>
noremap <silent> <A-F12> :BufExplorerHorizontalSplit<CR>

"-----------------------------------------------------------------------------
"6WIND
"-----------------------------------------------------------------------------

function InsertAckedBy()
	let expr = input('Acked-by: ')
	let cmd = '~/bin/acked-by.py ' . expr
	put =system(cmd)
endfunction

nnoremap <F4> :call InsertAckedBy()<CR>

"Pipe selection to hastebin and print URL in statusbar
vnoremap Y <esc>:'<,'>:w !haste<CR>

function InsertLicense()
	let license = 'Copyright ' . strftime('%Y') . ' 6WIND S.A.'

	if b:current_syntax == 'rst'
		let copyright = '.. ' . license
	elseif b:current_syntax == 'c'
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
"CTags
"-----------------------------------------------------------------------------

nnoremap ù <C-]>
"map <F3> <C-]>
nnoremap ! :tnext<CR>
"set tags=./tags;../tags;../../tags;../../../tags;../../../../tags;/
"set tags=./tags

let generate_tags = 1
let g:ctags_statusline = 1

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
nnoremap <C-_>s :cs find s <C-R>=expand("<cword>")<CR><CR>   " symbol
nnoremap <F3> :cs find g <C-R>=expand("<cword>")<CR><CR>   " global definition
nnoremap <C-H> :cs find c <C-R>=expand("<cword>")<CR><CR>   " functions calling
nnoremap <C-_>t :cs find t <C-R>=expand("<cword>")<CR><CR>   " text string
nnoremap <C-_>e :cs find e <C-R>=expand("<cword>")<CR><CR>   " egrep pattern
nnoremap <C-_>f :cs find f <C-R>=expand("<cfile>")<CR><CR>   " file
nnoremap <C-_>i :cs find i ^<C-R>=expand("<cfile>")<CR>$<CR> " files #including this file
nnoremap <C-_>d :cs find d <C-R>=expand("<cword>")<CR><CR>   " functions called by this function

"Using 'CTRL-spacebar' then a search type makes the vim window
"split horizontally, with search result displayed in
"the new window.
nnoremap <C-Space>s :scs find s <C-R>=expand("<cword>")<CR><CR>
nnoremap <C-Space>g :scs find g <C-R>=expand("<cword>")<CR><CR>
nnoremap <C-Space>c :scs find c <C-R>=expand("<cword>")<CR><CR>
nnoremap <C-Space>t :scs find t <C-R>=expand("<cword>")<CR><CR>
nnoremap <C-Space>e :scs find e <C-R>=expand("<cword>")<CR><CR>
nnoremap <C-Space>f :scs find f <C-R>=expand("<cfile>")<CR><CR>
nnoremap <C-Space>i :scs find i ^<C-R>=expand("<cfile>")<CR>$<CR>
nnoremap <C-Space>d :scs find d <C-R>=expand("<cword>")<CR><CR>
