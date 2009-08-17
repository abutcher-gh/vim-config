
runtime syntax/perl.vim


" embedded c++ in here documents
let b:old_syntax = b:current_syntax
unlet b:current_syntax
syn include @perlcppHere syntax/cpp.vim
let b:current_syntax = b:old_syntax
syn clear perlHereDoc
syn region perlcppEmbeddedCpp matchgroup=perlcppTags start=/<<\z([0-9A-Za-z_]*\)/ end=/^\z1$/ contains=@perlcppHere,perlcppRecurse
syn region perlcppRecurse matchgroup=perlcppTags start=+@{\[eval{+ end=+}]}+ nextgroup=perlcppEmbeddedCpp contained contains=TOP
syn region perlcppRecurse matchgroup=perlcppTags start=+\[\[+ end=+\]\]+ nextgroup=perlcppEmbeddedCpp contained contains=TOP
hi link perlcppTags WarningMsg

if version >= 701
  syntax spell default
endif    

