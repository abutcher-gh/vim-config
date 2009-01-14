if exists("b:current_syntax")
  finish
endif

syn match numBullet "^[ 	]\+\([\.o][ \t]\|\(\([0-9]\+\|[A-Za-z]\)\.\)*\([0-9]\+\|[A-Za-z]\)[.)]\)"

" titles
syn match numTitle0 contains=numComment "^ \{,2\}\([0-9]\+\.\)\{0\}[0-9]\+\.\?[ 	].* *$"     
syn match numTitle1 contains=numComment "^\([0-9]\+\.\)\{1\}[0-9]\+\.\?[ 	].*$"
syn match numTitle2 contains=numComment "^\([0-9]\+\.\)\{2\}[0-9]\+\.\?[ 	].*$"
syn match numTitle3 contains=numComment "^\([0-9]\+\.\)\{3\}[0-9]\+\.\?[ 	].*$"
syn match numTitle4 contains=numComment "^\([0-9]\+\.\)\{4\}[0-9]\+\.\?[ 	].*$"

syn match numComment contained "//.*$"
syn match numComment contained "#.*$"

syn match numScope "^[ 	]*\([A-Za-z0-9-._]\+[ 	]*\)\{,3\}[^ ]:\([^/]\|$\)"
syn region numScope start="`" end="'" skip="\\'"
syn match numScope "<[A-Za-z0-9._/-]\+>"

syn match numUrlScheme "\<[a-z0-9-]*://[^ 	]*"

syn match numVimGhost "^vim:.*$"

syn include @numXml syntax/xml.vim
syn region numXmlBlock start="\\xml" end="\\xml" contains=@numXml

syn match numPreDelim "\((((\|)))\)" containedin=@numPreBlock
syn region numPreBlock start="(((" end=")))" keepend contains=numPreDelim

" after including xml.vim, spelling is disabled for all blocks except
" xml comments; i think this is a bug since it should only have an
" effect within a @numXml cluster.  Anyways, this works around it:
"
syn match numAll ".*" contains=ALLBUT,@numXml

syn match numScore "=\{4,\}"

" Default highlighting
command -nargs=+ HiLink hi link <args>

" This syntax doesn't support numbering in 2html output.
let html_number_lines=0

HiLink numTitle0 StatusLine
HiLink numTitle1 NonText
HiLink numTitle2 Question
HiLink numTitle3 Statement
HiLink numTitle4 Underlined

HiLink numUrlScheme Underlined

HiLink numBulletLine NONE
HiLink numBullet Title

HiLink numPreBlock PreProc
HiLink numPreDelim SpecialKey

HiLink numComment Special

HiLink numVimGhost SpecialKey
HiLink numScore Statement

HiLink numScope Special

"HiLink PreProc
"HiLink 	Statement
"HiLink 	Special
"HiLink Constant
"HiLink 	PreProc
"HiLink 	PreProc
"HiLink 	Function

delcommand HiLink

" vim: ts=8
