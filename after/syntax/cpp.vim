
" allow {} in parens; only disallow ].  note that there is a nice bug
" here; it will allow stray } within parens... which is crap but I
" haven't time to mend it at the mo.

syn clear cErrInParen
syn match cErrInParen  /\]/  display contained

