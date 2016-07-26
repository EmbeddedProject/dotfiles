if exists("b:current_syntax")
	finish
endif

" Pull in the jinja syntax.
runtime syntax/jinja.vim
unlet b:current_syntax

syn match docfilesComment "#.*$"

hi def link docfilesComment Comment

let b:current_syntax = "docfiles"
