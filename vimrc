if has("gui_running")
	set guioptions-=T
	set columns=110
	set lines=40
	set gtl=%t gtt=%F
else
	set t_Co=256
end

set selectmode=
set nocompatible
set modeline
set modelines=5
set mouse=vn
" yank-into/paste-from X selection clipboard (paste with middle mouse)
" *yy *p
" yank-into/paste-from X window clipboard (ctrl+c, ctrl+v)
" +yy +p
" yank-into/paste-from X selection clipboard (paste with middle mouse) by default
set clipboard=unnamed
" yank-into/paste-from X window clipboard (ctrl+c, ctrl+v) by default
" set clipboard=unnamedplus

" Tabs settings
" <F5> Only tabs (8 spaces per level)
map <F5> :set shiftwidth=8<CR>:set tabstop=8<CR>:set noexpandtab<CR>:set softtabstop=8<CR>
" <F6> Only spaces (4 spaces by level)
map <F6> :set shiftwidth=4<CR>:set tabstop=4<CR>:set expandtab<CR>:set softtabstop=4<CR>
" <F7> Only spaces (2 spaces by level)
map <F7> :set shiftwidth=2<CR>:set tabstop=2<CR>:set expandtab<CR>:set softtabstop=2<CR>

"Indenting
set autoindent
set smartindent
" cintent options:
"    :0 --> Align "case" statements with "switch" (instead of intented)
"    j1 --> Indent Java anonymous classes correctly
"    J1 --> Indent JavaScript object declarations correctly
set cinoptions=:0,j1,J1
filetype plugin indent on

"Scrollbars
set sidescrolloff=2
set numberwidth=4

"Cursor highlights
set cursorline

"Searching
set hlsearch
set incsearch
set ignorecase
set smartcase

" Syntax stuff/options
syntax on

"Colors
colorscheme tir_black

set colorcolumn=81

let c_char_is_integer=1
let c_space_errors=1
let c_gnu=1
let c_syntax_for_h=1
let c_C94=1
let c_C99=1
let c_conditional_is_operator=1
let c_no_octal=1
let c_ansi_typedefs=1
let c_ansi_constants=1
let c_posix=1
let c_math=1

let python_highlight_all=1
let python_highlight_space_errors=0

"Status Line
set showcmd
set ruler

"Line Wrapping
set wrap
set linebreak

"Mappings
"delete line with <ctrl-d>
inoremap <C-d> <Esc>ddi
vnoremap <C-d> d
nnoremap <C-d> dd
"move lines up and down with <Alt-j> & <Alt-k> keys
nnoremap <A-j> :m+<CR>==
nnoremap <A-k> :m-2<CR>==
inoremap <A-j> <Esc>:m+<CR>==gi
inoremap <A-k> <Esc>:m-2<CR>==gi
vnoremap <A-j> :m'>+<CR>gv=gv
vnoremap <A-k> :m-2<CR>gv=gv
"move lines up and down with <Alt-up> & <Alt-down> keys
nnoremap <A-down> :m+<CR>==
nnoremap <A-up> :m-2<CR>==
inoremap <A-down> <Esc>:m+<CR>==gi
inoremap <A-up> <Esc>:m-2<CR>==gi
vnoremap <A-down> :m'>+<CR>gv=gv
vnoremap <A-up> :m-2<CR>gv=gv

"indent selection with <tab> key
vnoremap <tab> >gv
"unindent seletction with <Shift-tab> command
vnoremap <S-tab> <gv

" pipe selection to hastebin and print URL in statusbar
vnoremap Y <esc>:'<,'>:w !haste<CR>

" reflow current paragraph with F
set formatoptions=tcq
nnoremap F gqap

"Inser New Line
map <S-Enter> O<ESC>
map <Enter> o<ESC>

"Sessions
"Sets what is saved when you save a session
set sessionoptions=blank,buffers,curdir,folds,help,resize,tabpages,winsize

"Misc
set backspace=indent,eol,start
set matchpairs+=<:>
set novb
set t_vb= " Turn off bell, this could be more annoying, but I'm not sure how

"Cursor Movement
"Make cursor move by visual lines instead of file lines (when wrapping)
map <up> gk
map k gk
imap <up> <C-o>gk
map <down> gj
map j gj
imap <down> <C-o>gj
map E ge
"wrap cursor to next line when reaching end of line
set whichwrap+=<,>,h,l,[,]

" When editing a file, always jump to the last cursor position
if has("autocmd")
  autocmd BufReadPost *
  \ if line("'\"") > 0 && line ("'\"") <= line("$") |
  \   exe "normal g'\"" |
  \ endif
endif

" CTags support
map ù <C-]>
"map <F3> <C-]>
"map ! :tnext<CR>
"set tags=./tags;../tags;../../tags;../../../tags;../../../../tags;/
"set tags=./tags

" CScope support
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

" Basic keymaps
nmap <C-_>s :cs find s <C-R>=expand("<cword>")<CR><CR>   " symbol
nmap <F3> :cs find g <C-R>=expand("<cword>")<CR><CR>   " global definition
nmap <C-H> :cs find c <C-R>=expand("<cword>")<CR><CR>   " functions calling
nmap <C-_>t :cs find t <C-R>=expand("<cword>")<CR><CR>   " text string
nmap <C-_>e :cs find e <C-R>=expand("<cword>")<CR><CR>   " egrep pattern
nmap <C-_>f :cs find f <C-R>=expand("<cfile>")<CR><CR>   " file
nmap <C-_>i :cs find i ^<C-R>=expand("<cfile>")<CR>$<CR> " files #including this file
nmap <C-_>d :cs find d <C-R>=expand("<cword>")<CR><CR>   " functions called by this function

" Using 'CTRL-spacebar' then a search type makes the vim window
" split horizontally, with search result displayed in
" the new window.
nmap <C-Space>s :scs find s <C-R>=expand("<cword>")<CR><CR>
nmap <C-Space>g :scs find g <C-R>=expand("<cword>")<CR><CR>
nmap <C-Space>c :scs find c <C-R>=expand("<cword>")<CR><CR>
nmap <C-Space>t :scs find t <C-R>=expand("<cword>")<CR><CR>
nmap <C-Space>e :scs find e <C-R>=expand("<cword>")<CR><CR>
nmap <C-Space>f :scs find f <C-R>=expand("<cfile>")<CR><CR>
nmap <C-Space>i :scs find i ^<C-R>=expand("<cfile>")<CR>$<CR>
nmap <C-Space>d :scs find d <C-R>=expand("<cword>")<CR><CR>

" Hitting CTRL-space *twice* before the search type does a vertical
" split instead of a horizontal one
nmap <C-Space><C-Space>s
	\:vert scs find s <C-R>=expand("<cword>")<CR><CR>
nmap <C-Space><C-Space>g
	\:vert scs find g <C-R>=expand("<cword>")<CR><CR>
nmap <C-Space><C-Space>c
	\:vert scs find c <C-R>=expand("<cword>")<CR><CR>
nmap <C-Space><C-Space>t
	\:vert scs find t <C-R>=expand("<cword>")<CR><CR>
nmap <C-Space><C-Space>e
	\:vert scs find e <C-R>=expand("<cword>")<CR><CR>
nmap <C-Space><C-Space>i
	\:vert scs find i ^<C-R>=expand("<cfile>")<CR>$<CR>
nmap <C-Space><C-Space>d
	\:vert scs find d <C-R>=expand("<cword>")<CR><CR>

" Display <tab>s etc...
set list
nnoremap <C-l> :set list!<CR>
nnoremap <C-p> :set paste!<CR>
inoremap <C-p> :set paste!<CR>
nnoremap <C-n> :set number!<CR>

set lcs=tab:\ \ ,trail:\ ,extends:>,precedes:<,nbsp:&

"define 3 custom highlight groups
hi User1 ctermfg=red   guifg=red
hi User2 ctermfg=blue  guifg=blue
hi User3 ctermfg=green guifg=green

set statusline=

set statusline+=%f    "tail of the filename
set statusline+=%1*   "switch to User1 highlight
set statusline+=%h    "help file flag
set statusline+=%m    "modified flag
set statusline+=%r    "read only flag
set statusline+=%*\   "switch back to statusline highlight

set statusline+=%2*   "switch to User2 highlight
set statusline+=[%{strlen(&fenc)?&fenc:'none'}, "file encoding
set statusline+=%{&ff}]   "file format
set statusline+=%*\   "switch back to statusline highlight

set statusline+=%3*   "switch to User3 highlight
set statusline+=%y    "filetype
set statusline+=%*    "switch back to statusline highlight

set statusline+=%=    "left/right separator
set statusline+=c%c\  "cursor column
set statusline+=%l/%L "cursor line/total lines
set statusline+=\ %P  "percent through file

set laststatus=2      "always show statusline

" vim fugitive bindings
nnoremap <C-g>b :Gblame<CR>

let generate_tags = 1
let g:ctags_statusline = 1

function InsertAckedBy()
	let expr = input('Acked-by: ')
	let cmd = '~/bin/acked-by.py ' . expr
	put =system(cmd)
endfunction

nnoremap <F4> :call InsertAckedBy()<CR>

" Buffer Explorer plugin
let g:bufExplorerDisableDefaultKeyMapping=1
noremap <silent> <F12> :BufExplorer<CR>
noremap <silent> <C-F12> :BufExplorerVerticalSplit<CR>
noremap <silent> <A-F12> :BufExplorerHorizontalSplit<CR>

" vim-pandoc
let g:pandoc#modules#enabled=["formatting"]
let g:pandoc#filetypes#handled=["markdown"]
let g:pandoc#formatting#mode='h'
