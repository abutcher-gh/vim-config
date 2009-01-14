runtime syntax/mail.vim

unlet b:current_syntax
runtime syntax/diff.vim

syn match gitDiffStatLineMixed   /^ .\{-}|.\{-} [+-]\+$/ contains=gitDiffStatAdd,gitDiffStatDelete,gitDiffStatColumn
syn match gitDiffStatLineMixed   /^ .\{-}|.\{-} Bin.*/ contains=gitDiffStatAdd,gitDiffStatDelete,gitDiffStatColumn
syn match gitDiffStatLineAdded   /^ .\{-}|.\{-} [+]\+$/ contains=gitDiffStatAdd,gitDiffStatColumn
syn match gitDiffStatLineAdded   /^ .\{-}|.\{-} Bin 0 .*/ contains=gitDiffStatAdd,gitDiffStatColumn
syn match gitDiffStatLineRemoved /^ .\{-}|.\{-} [-]\+$/ contains=gitDiffStatDelete,gitDiffStatColumn
syn match gitDiffStatLineRemoved /^ .\{-}|.\{-} Bin .\{-}-> 0.*/ contains=gitDiffStatDelete,gitDiffStatColumn
syn match gitDiffStatAdd    /+/ contained
syn match gitDiffStatDelete /-/ contained
syn match gitDiffStatColumn / |.\{-} \([+-]\|Bin \)/me=e-1 contained

hi link gitDiffStatAdd         diffAdded
hi link gitDiffStatDelete      diffRemoved
hi link gitDiffStatLineMixed   diffChanged
hi link gitDiffStatLineAdded   diffAdded
hi link gitDiffStatLineRemoved diffRemoved

set foldexpr=getline(v:lnum)=~'^From'?0:getline(v:lnum)=~'^diff'?'>1':getline(v:lnum+1)=~'^diff'?'<1':'='
set foldtext=v:folddashes.substitute(getline(v:foldstart),'diff\ --git\ a/\\(.\\{-}\\)\ b/.*',repeat('-',5-strlen(string(v:foldend-v:foldstart))).'\ '.(v:foldend-v:foldstart).'\ lines\ ---\ \\1\ ','')
set foldmethod=expr
set foldcolumn=1

let b:current_syntax = "git-diff"
