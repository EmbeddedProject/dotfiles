" tir_black color scheme
" Based on ir_black from: http://blog.infinitered.com/entries/show/8
" adds 256 color console support
" changed WildMenu color to be the same as PMenuSel

set background=dark
hi clear

if exists("syntax_on")
	syntax reset
endif

let colors_name = "tir_black"

" General colors
hi Normal           ctermfg=none                                                      gui=none
hi NonText          ctermfg=232                           guifg=#080808

hi Cursor           ctermfg=0   ctermbg=10                guifg=#000000 guibg=#00ff00
hi LineNr           ctermfg=239                           guifg=#4e4e4e
hi CursorLineNr     ctermfg=227 cterm=none                guifg=#ffff5f               gui=none

hi VertSplit        ctermfg=235 ctermbg=235               guifg=#262626 guibg=#262626
hi StatusLine       ctermfg=235 ctermbg=254               guifg=#262626 guibg=#e4e4e4
hi StatusLineNC     ctermfg=0   ctermbg=235               guifg=#000000 guibg=#262626

hi Folded           ctermfg=103 ctermbg=60                guifg=#8787af guibg=#5f5f87
hi Title            ctermfg=187             cterm=bold    guifg=#d7d7af               gui=bold
hi Visual                                   cterm=reverse                             gui=reverse

if has('nvim')
	hi link NormalFloat Normal
	hi SpecialKey ctermfg=15  ctermbg=9               guifg=#ffffff guibg=#ff0000
else
	hi SpecialKey ctermfg=236 ctermbg=233             guifg=#303030 guibg=#121212
endif

hi ExtraWhitespace  ctermfg=15   ctermbg=9                guifg=#ffffff guibg=#ff0000
hi Whitespace       ctermfg=236  ctermbg=233              guifg=#303030 guibg=#121212

hi Error            ctermfg=15  ctermbg=203              guifg=#ffffff guibg=#ff5f5f
hi ErrorMsg         ctermfg=15  ctermbg=203 cterm=bold   guifg=#ffffff guibg=#ff5f5f gui=bold
hi WarningMsg       ctermfg=15  ctermbg=203 cterm=bold   guifg=#ffffff guibg=#ff5f5f gui=bold
hi LongLineWarning                           cterm=underline                          gui=underline

hi ModeMsg          ctermfg=0    ctermbg=189 cterm=bold   guifg=#000000 guibg=#d7d7ff gui=bold

hi CursorLine       ctermbg=233  cterm=none               guibg=#121212               gui=none
hi ColorColumn      ctermbg=234  cterm=none               guibg=#1c1c1c               gui=none
hi CursorColumn     ctermbg=233  cterm=none               guibg=#121212               gui=none
hi MatchParen       ctermfg=none ctermbg=236              guifg=none    guibg=#303030

hi TabLine          ctermfg=102  ctermbg=233 cterm=none   guifg=#878787 guibg=#121212 gui=none
hi TabLineSel       ctermfg=15   ctermbg=59  cterm=none   guifg=#ffffff guibg=#5f5f5f gui=none
hi TabLineFill      ctermfg=233  ctermbg=233 cterm=none   guifg=#121212 guibg=#121212 gui=none

hi Pmenu            ctermfg=15   ctermbg=23  cterm=none   guifg=#ffffff guibg=#005f5f gui=none
hi PmenuSet         ctermfg=81   ctermbg=233 cterm=none   guifg=#5fd7ff guibg=#121212 gui=none
hi PmenuSBar        ctermfg=81   ctermbg=59  cterm=none   guifg=#5fd7ff guibg=#5f5f5f gui=none
hi PmenuSel         ctermfg=81   ctermbg=59  cterm=none   guifg=#5fd7ff guibg=#5f5f5f gui=none
hi PmenuThumb       ctermfg=103  ctermbg=103 cterm=none   guifg=#8787af guibg=#8787af gui=none

hi Search           ctermfg=15   ctermbg=21               guifg=#ffffff guibg=#0000ff

" Syntax highlighting
hi Comment          ctermfg=203              cterm=italic guifg=#ff5f5f               gui=italic
hi String           ctermfg=155                           guifg=#afff5f
hi Number           ctermfg=207                           guifg=#ff5fff

hi Keyword          ctermfg=117                           guifg=#87d7ff
hi PreProc          ctermfg=117                           guifg=#87d7ff
hi Conditional      ctermfg=110                           guifg=#87afd7

hi Todo             ctermfg=207  ctermbg=0   cterm=bold   guifg=#ff5fff guibg=#000000 gui=bold
hi Constant         ctermfg=151                           guifg=#afd7af

hi Identifier       ctermfg=189                           guifg=#d7d7ff
hi Function         ctermfg=223                           guifg=#ffd7af
hi Type             ctermfg=229                           guifg=#ffffaf
hi Statement        ctermfg=110                           guifg=#87afd7

hi Special          ctermfg=173                           guifg=#d7875f
hi Delimiter        ctermfg=37                            guifg=#00afaf
hi Operator         ctermfg=110                           guifg=#87afd7

hi DiffAdd          ctermfg=10  ctermbg=22  cterm=NONE    guifg=#00ff00  guibg=#005f00  gui=NONE
hi DiffChange       ctermfg=11  ctermbg=52  cterm=NONE    guifg=#ffff00  guibg=#5f0000  gui=NONE
hi DiffDelete       ctermfg=9   ctermbg=52  cterm=NONE    guifg=#ff0000  guibg=#5f0000  gui=NONE
hi DiffText         ctermfg=11  ctermbg=22  cterm=NONE    guifg=#ffff00  guibg=#005f00  gui=NONE

hi SpellBad         ctermfg=none ctermbg=52               guifg=none     guibg=#5f0000
hi clear SpellCap
hi clear SpellRare
hi clear SpellLocal

hi link Character Constant
hi link Boolean Constant
hi link Float Number
hi link Repeat Statement
hi link Label Statement
hi link Exception Statement
hi link Include PreProc
hi link Define PreProc
hi link Macro PreProc
hi link PreCondit PreProc
hi link StorageClass Type
hi link Structure Type
hi link Typedef Type
hi link Tag Special
hi link SpecialChar Special
hi link SpecialComment Special
hi link Debug Special

" Special for Ruby
hi rubyRegexp ctermfg=brown
hi rubyRegexpDelimiter ctermfg=brown
hi rubyEscape ctermfg=cyan
hi rubyInterpolationDelimiter ctermfg=blue
hi rubyControl ctermfg=blue
hi rubyStringDelimiter ctermfg=lightgreen
hi link rubyClass Keyword
hi link rubyModule Keyword
hi link rubyKeyword Keyword
hi link rubyOperator Operator
hi link rubyIdentifier Identifier
hi link rubyInstanceVariable Identifier
hi link rubyGlobalVariable Identifier
hi link rubyClassVariable Identifier
hi link rubyConstant Type

" Special for Java
hi link javaScopeDecl Identifier
hi link javaCommentTitle javaDocSeeTag
hi link javaDocTags javaDocSeeTag
hi link javaDocParam javaDocSeeTag
hi link javaDocSeeTagParam javaDocSeeTag

hi javaDocSeeTag ctermfg=darkgray
hi javaDocSeeTag ctermfg=darkgray

" Special for XML
hi link xmlTag Keyword
hi link xmlTagName Conditional
hi link xmlEndTag Identifier

" Special for HTML
hi link htmlTag Keyword
hi link htmlTagName Conditional
hi link htmlEndTag Identifier

" Special for Javascript
hi link javaScriptNumber Number

" Special for CSharp
hi link csXmlTag Keyword

" Special for emails
hi mailQuoted1  ctermfg=75   ctermbg=none  guifg=#5fafff  guibg=none
hi mailQuoted2  ctermfg=208  ctermbg=none  guifg=#ff8700  guibg=none
hi mailQuoted3  ctermfg=141  ctermbg=none  guifg=#af87ff  guibg=none
hi mailQuoted4  ctermfg=171  ctermbg=none  guifg=#d75fff  guibg=none
hi mailQuoted5  ctermfg=244  ctermbg=none  guifg=#808080  guibg=none
hi mailQuoted6  ctermfg=244  ctermbg=none  guifg=#808080  guibg=none
hi mailURL      ctermfg=229  ctermbg=none  guifg=#ffffaf  guibg=none
hi mailEmail    ctermfg=229  ctermbg=none  guifg=#ffffaf  guibg=none

" email patch reply
hi mailQuoteDiffMeta     ctermfg=15 ctermbg=none cterm=bold  guifg=#ffffff guibg=none gui=bold
hi mailQuoteDiffChunk    ctermfg=6  ctermbg=none             guifg=#00cdcd guibg=none
hi mailQuoteDiffAdded    ctermfg=10 ctermbg=none             guifg=#00ff00 guibg=none
hi mailQuoteDiffRemoved  ctermfg=9  ctermbg=none             guifg=#ff0000 guibg=none

hi diffAdded             ctermfg=10 ctermbg=none             guifg=#00ff00 guibg=none
hi diffRemoved           ctermfg=9  ctermbg=none             guifg=#ff0000 guibg=none

" Show trailing whitespace and spaces before a tab:
match ExtraWhitespace /\s\+$\| \+\ze\t/
