
syn match qfQuoted "[`'][^']*'" contains=TOP
syn match qfQuoted "‘[^’]*’"  contains=TOP

syn match qfErrorQuoted contained containedin=qfError "[`'][^']*'" contains=qfSymbol,qfNumber,qfType
syn match qfErrorQuoted contained containedin=qfError "‘[^’]*’" contains=qfSymbol,qfNumber,qfType

syn match qfWarningQuoted contained containedin=qfWarning "[`'][^']*'" contains=qfSymbol,qfNumber,qfType
syn match qfWarningQuoted contained containedin=qfWarning "‘[^’]*’" contains=qfSymbol,qfNumber,qfType

syn match qfType "\<\(namespace\|struct\|class\)\>"

syn match qfSymbol  "[:()<>,]"
syn match qfNumber  "\<[0-9]\+\>"

syn match qfError   "[Ee]rror:.*"   contains=qfErrorQuoted,qfSymbol,qfNumber,qfType
syn match qfWarning "[Ww]arning:.*" contains=qfWarningQuoted,qfSymbol,qfNumber,qfType

hi link qfError          WarningMsg
hi link qfWarning        Type
hi link qfQuoted         Statement
hi link qfErrorQuoted    Statement
hi link qfWarningQuoted  Statement
hi link qfType           Type
hi link qfSymbol         Directory
hi link qfNumber         Comment

