
runtime syntax/cpp.vim

syn match  mib2cComment /^\s*#\+\(\s\+.*\|$\)/
syn region mib2cCommand start="@" end="@"
syn match  mib2cVar     /\${\?[a-zA-Z_][a-zA-Z0-9_]*}\?\(\.[a-zA-Z0-9]\+\)*/ containedin=ALL

hi def link mib2cComment LineNr
hi def link mib2cCommand LineNr
hi def link mib2cVar     WarningMsg
