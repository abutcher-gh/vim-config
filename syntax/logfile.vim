if version < 600
  syntax clear
elseif exists("b:current_syntax")
  finish
endif

syn match Include "[:./;,+]" containedin=ALL

syn match Number "[0-9]\+"
syn match String "\"[^\"]*\""

syn match Time "[0-9]\{2\}:[0-9]\{2\}:[0-9]\{2\}\([.][0-9]\+\)\?" contains=TimeFraction
syn match TimeFraction "\([.][0-9]\+\)" contained
syn match HexNumber "0x[0-9a-fA-F]\+"
syn match Bracketed "\[[^\]]*\]"
syn match Assign "[^\t (){}\[\]]\+\s*="he=e-1 containedin=TOP

set nospell

hi link Bracketed Statement
hi link HexNumber Type
hi link Time Identifier
hi link TimeFraction Directory
hi link Assign Structure

