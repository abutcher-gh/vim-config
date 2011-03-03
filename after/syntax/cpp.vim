
" allow {} in parens; only disallow ].  note that there is a nice bug
" here; it will allow stray } within parens... which is crap but I
" haven't time to mend it at the mo.

syn clear cErrInParen
syn match cErrInParen  /\]/  display contained

syn match cdoxyRef contained containedin=cdoxyBound,cdoxySentanceOne /#\S\+/hs=s+1
hi def link cdoxyRef Function

" prevent matching cdoxyRef in #define
" (it is defined using the globby ALLBUT ref)
"
syn region cDefine start="^\s*\(%:\|#\)\s*\(define\|undef\)\>" skip="\\$" end="$" end="//"me=s-1 keepend contains=ALLBUT,@cPreProcGroup,@Spell,cdoxyRef

