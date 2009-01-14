
syn match makeVPathLine	"^ *vpath.*" contains=makeStatement,makeColon
syn match makeColon ":"	contained

hi def link makeColon makeIdent

