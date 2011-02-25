
syn match makeVPathLine	"^ *vpath.*" contains=makeStatement,makeColon
syn match makeColon ":"	contained

syn match makeIdent	"^\s*[^ \t:+?!*]\+\s*[:+?!*]="me=e-2
syn match makeIdent	"^\s*[^ \t:+?!*]\+\s*="me=e-1

" special variables in our makefiles
syn match makeSpace     /\$\( \|( )\)/              containedin=ALL
syn match makeSpecial   /\$,/                       containedin=ALL
syn match makeSpecial   /\$(\(\\[nt0]\|\\nt\|,\))/  containedin=ALL

syn match makeFunc /(call [^,]\+/hs=s+6 containedin=ALLBUT,makeComment

hi link makeColon Special
hi link makeSpace DiffAdd
hi link makeSpecial Question
hi link makeFunc Type

