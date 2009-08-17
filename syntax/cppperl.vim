
runtime syntax/cpp.vim


" embedded perl in [[]] and allow escape back to C++ in here documents
let b:old_syntax = b:current_syntax
unlet b:current_syntax
syn include @cppperlEmbeddedPerl syntax/perl.vim
let b:current_syntax = b:old_syntax
syn clear perlHereDoc
syn region cppperlRegion matchgroup=perlcppTags start=+\[\[+ end=+\]\]+ contains=@cppperlEmbeddedPerl,cppperlEscapeToCpp
syn region cppperlEscapeToCpp matchgroup=perlcppTags start=/<<\z([0-9A-Za-z_]*\)/ end=/^\z1$/ nextgroup=cppperlEmbeddedPerl contained contains=TOP
hi link perlcppTags WarningMsg

syn match perlVarPlain /[\$%@]\+[A-Za-z_][0-9A-Za-z_]*/ containedin=ALL

if version >= 701
  syntax spell default
endif    

