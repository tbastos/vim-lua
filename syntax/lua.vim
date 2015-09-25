" Vim syntax file
" Language:      Lua
" Maintainer:    Thiago Bastos <https://github.com/tbastos>
" Last Modified: Fri 25 Sep 2015 17:45:15 CEST
" URL:           https://github.com/tbastos/vim-lua

if !exists("main_syntax")
  if version < 600
    syntax clear
  elseif exists("b:current_syntax")
    finish
  endif
  let main_syntax = 'lua'
endif

syntax sync fromstart

" Clusters
syntax cluster luaBase contains=luaComment,luaConstant,luaBuiltIn,luaNumber,luaString
syntax cluster luaExpr contains=@luaBase,luaTable,luaParen,luaBracket,luaSpecialTable,luaSpecialValue,luaOperator,luaEllipsis,luaComma,luaFunc,luaFuncCall
syntax cluster luaStat contains=@luaExpr,luaIfThen,luaBlock,luaRepeat,luaWhile,luaFor,luaGotoLabel,luaLocal,luaStatement,luaSemiCol

syntax match luaNoise /\%(\.\|,\|:\|\;\)/

" Shebang at the start
syntax match luaComment "\%^#!.*"

" Symbols
syntax region luaTable   transparent matchgroup=luaBraces   start="{" end="}" contains=@luaExpr fold
syntax region luaParen   transparent matchgroup=luaParens   start='(' end=')' contains=@luaExpr
syntax region luaBracket transparent matchgroup=luaBrackets start="\[" end="\]" contains=@luaExpr
syntax match  luaComma ","
syntax match  luaSemiCol ";"
syntax match  luaOperator "[#<>=~^&|*/%+-]\|\.\."

" Catch errors caused by unbalanced brackets and keywords
syntax match luaError ")"
syntax match luaError "}"
syntax match luaError "\]"
syntax match luaError "\<\%(end\|else\|elseif\|then\|until\)\>"

" Comments
syntax keyword luaTodo    contained TODO FIXME XXX TBD
syntax match   luaComment "--.*$" contains=luaTodo,@Spell
syntax region  luaComment matchgroup=luaComment start="--\[\z(=*\)\[" end="\]\z1\]" contains=luaTodo,@Spell fold

" Function calls
syntax match luaFuncCall /\k\+\%(\s*[{('"]\)\@=/

" Functions
syntax region luaFunc transparent matchgroup=luaFuncKeyword start="\<function\>" end="\<end\>" contains=@luaStat,luaFuncSig fold
syntax match luaFuncSig contained "\(\<function\>\)\@<=[^)]*)" contains=luaFuncId,luaFuncArgs
syntax match luaFuncId contained "[^(]*(\@=" contains=luaFuncTable,luaFuncName
syntax match luaFuncTable contained /\k\+\%(\s*[.:]\)\@=/
syntax match luaFuncName contained "[^(.:]*(\@="
syntax region luaFuncArgs contained transparent matchgroup=luaFuncParens start=/(/ end=/)/ contains=@luaBase,luaFuncComma,luaEllipsis,luaFuncArgName
syntax match luaFuncArgName contained /\k*/
syntax match  luaEllipsis "\.\.\."

" if ... then
syntax region luaIfThen transparent matchgroup=luaCond start="\<if\>" end="\<then\>"me=e-4 contains=@luaExpr nextgroup=luaThenEnd skipwhite skipempty

" then ... end
syntax region luaThenEnd contained transparent matchgroup=luaCond start="\<then\>" end="\<end\>" contains=@luaStat,luaElseifThen,luaElse fold

" elseif ... then
syntax region luaElseifThen contained transparent matchgroup=luaCond start="\<elseif\>" end="\<then\>" contains=@luaExpr

" else
syntax keyword luaElse contained else

" do ... end
syntax region luaBlock transparent matchgroup=luaRepeat start="\<do\>" end="\<end\>" contains=@luaStat fold

" repeat ... until
syntax region luaRepeat transparent matchgroup=luaRepeat start="\<repeat\>" end="\<until\>" contains=@luaStat fold

" while ... do
syntax region luaWhile transparent matchgroup=luaRepeat start="\<while\>" end="\<do\>"me=e-2 contains=@luaExpr nextgroup=luaBlock skipwhite skipempty fold

" for ... do and for ... in ... do
syntax region luaFor transparent matchgroup=luaRepeat start="\<for\>" end="\<do\>"me=e-2 contains=@luaExpr,luaIn nextgroup=luaBlock skipwhite skipempty
syntax keyword luaIn contained in

" goto and labels
syntax match luaGotoLabel "\(\<goto\>\s*\)\@<=\k*"
syntax match luaLabel "::\k*::"

" Other Keywords
syntax keyword luaConstant nil true false
syntax keyword luaBuiltIn _ENV self
syntax keyword luaLocal local
syntax keyword luaOperator and or not
syntax keyword luaStatement break goto return

" Strings
syntax match  luaStringSpecial contained #\\[\\abfnrtvz'"]\|\\x[[:xdigit:]]\{2}\|\\[[:digit:]]\{,3}#
syntax region luaString matchgroup=luaLongString start="\[\z(=*\)\[" end="\]\z1\]" contains=@Spell
syntax region luaString  start=+'+ end=+'+ skip=+\\\\\|\\'+ contains=luaStringSpecial,@Spell
syntax region luaString  start=+"+ end=+"+ skip=+\\\\\|\\"+ contains=luaStringSpecial,@Spell

" Decimal constant
syntax match luaNumber "\<\d\+\>"
" Hex constant
syntax match luaNumber "\<0[xX][[:xdigit:].]\+\%([pP][-+]\=\d\+\)\=\>"
" Floating point constant, with dot, optional exponent
syntax match luaFloat  "\<\d\+\.\d*\%([eE][-+]\=\d\+\)\=\>"
" Floating point constant, starting with a dot, optional exponent
syntax match luaFloat  "\.\d\+\%([eE][-+]\=\d\+\)\=\>"
" Floating point constant, without dot, with exponent
syntax match luaFloat  "\<\d\+[eE][-+]\=\d\+\>"

" Special names from the Standard Library
syntax keyword luaSpecialTable
\ bit32
\ coroutine
\ debug
\ io
\ math
\ os
\ package
\ string
\ table
\ utf8

syntax keyword luaSpecialValue
\ _G
\ _VERSION
\ assert
\ collectgarbage
\ dofile
\ error
\ getfenv
\ getmetatable
\ ipairs
\ load
\ loadfile
\ loadstring
\ module
\ next
\ pairs
\ pcall
\ print
\ rawequal
\ rawget
\ rawlen
\ rawset
\ require
\ select
\ setfenv
\ setmetatable
\ tonumber
\ tostring
\ type
\ unpack
\ xpcall

" Define the default highlighting.
" For version 5.7 and earlier: only when not done already
" For version 5.8 and later: only when an item doesn't have highlighting yet
if version >= 508 || !exists("did_javascript_syn_inits")
  if version < 508
    let did_javascript_syn_inits = 1
    command -nargs=+ HiLink hi link <args>
  else
    command -nargs=+ HiLink hi def link <args>
  endif
  " HiLink luaParens           Operator
  HiLink luaBraces           Structure
  " HiLink luaBrackets         Operator
  HiLink luaBuiltIn          Special
  HiLink luaComment          Comment
  HiLink luaCond             Conditional
  HiLink luaConstant         Boolean
  HiLink luaEllipsis         StorageClass
  HiLink luaElse             Conditional
  HiLink luaError            Error
  HiLink luaFloat            Float
  HiLink luaFor              Repeat
  HiLink luaFuncTable        Function
  " HiLink luaFuncArgName      Constant
  HiLink luaFuncCall         PreProc
  HiLink luaFuncId           Function
  HiLink luaFuncKeyword      Type
  HiLink luaFuncName         Function
  " HiLink luaFuncParens       Type
  HiLink luaGotoLabel        Underlined
  HiLink luaIn               Repeat
  HiLink luaLabel            Underlined
  HiLink luaLocal            Type
  HiLink luaLongString       String
  HiLink luaNumber           Number
  HiLink luaOperator         Operator
  HiLink luaRepeat           Repeat
  HiLink luaSemiCol          Delimiter
  HiLink luaSpecialTable     Special
  HiLink luaSpecialValue     PreProc
  HiLink luaStatement        Statement
  HiLink luaString           String
  HiLink luaStringSpecial    SpecialChar
  HiLink luaTodo             Todo

  delcommand HiLink
end

let b:current_syntax = "lua"
if main_syntax == 'lua'
  unlet main_syntax
endif
