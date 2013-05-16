
if has("gui_running")
  set guioptions-=T
  set guifont=Terminus
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

" Tabs settings
" <F5> Only tabs (8 spaces per level)
map <F5> :set shiftwidth=8<CR>:set tabstop=8<CR>:set noexpandtab<CR>:set softtabstop=8<CR>
" <F6> Only spaces (4 spaces by level)
map <F6> :set shiftwidth=4<CR>:set tabstop=4<CR>:set expandtab<CR>:set softtabstop=4<CR>

"Indenting
set autoindent
set smartindent

"Scrollbars
set sidescrolloff=2
set numberwidth=4

"Windows
set equalalways
set splitbelow splitright
" Fast window resizing with +/- keys (horizontal); / and * keys (vertical)
if bufwinnr(1)
  map <kPlus> <C-W>+
  map <kMinus> <C-W>-
  map <kDivide> <c-w><
  map <kMultiply> <c-w>>
endif

"Vertical split then hop to new buffer
noremap ,v :vsp^M^W^W<cr>
noremap ,h :split^M^W^W<cr>


"Cursor highlights
set cursorline


"Searching
set hlsearch
set incsearch
set ignorecase
set smartcase


"Colors
syntax on
colorscheme tir_diab

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

"Inser New Line
map <S-Enter> O<ESC>
map <Enter> o<ESC>

"Sessions
"Sets what is saved when you save a session
set sessionoptions=blank,buffers,curdir,folds,help,resize,tabpages,winsize

"Misc
set backspace=indent,eol,start
set number " Show line numbers
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
map <F3> <C-]>
map ! :tnext<CR>
set tags=./tags;../tags;../../tags;../../../tags;../../../../tags;/

" Display <tab>s etc...
set list
" Some cool display variants for tabs (which will almost certainly break if
" your gvim/terminal is not unicode-aware).
" If you want to make your own I recommend look up the unicode table 2500 on
" the web (or any other that includes your desired characters).
" Inserting the unicode character 2500 is done by pressing: Ctrl-V Ctrl-U 2500

" Depending on your encoding the following lines might be broken for you, in
" that case try to view this in utf-8 encoding or just make your own lcs
" string as described above.

"set lcs=tab:│\ ,trail:·,extends:>,precedes:<,nbsp:&
"set lcs=tab:└─,trail:·,extends:>,precedes:<,nbsp:&
set lcs=tab:│┈,trail:·,extends:>,precedes:<,nbsp:&

" Syntax stuff/options
let python_highlight_all=1
let python_highlight_space_errors=0

let c_char_is_integer = 1
let c_c_vim_compatible = 0
let c_space_errors = 1
let c_gnu = 1
let c_syntax_for_h = 1
let c_C94 = 1
let c_C99_warn = 1
let c_conditional_is_operator = 1
let c_cpp_warn = 1
let c_warn_8bitchars = 1
let c_warn_multichar = 1
let c_warn_digraph = 1
let c_warn_trigraph = 1
let c_no_octal = 1


