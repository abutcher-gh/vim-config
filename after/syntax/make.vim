
syn match makeVPathLine	"^ *vpath.*" contains=makeStatement,makeColon
syn match makeColon ":"	contained

syn match makeIdent	"^ *\a[a-zA-Z_.-]*\s*[:+?!*]="me=e-2
syn match makeIdent	"^ *\a[a-zA-Z_.-]*\s*="me=e-1

hi def link makeColon makeIdent

