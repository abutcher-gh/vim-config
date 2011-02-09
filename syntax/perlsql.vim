
runtime syntax/perl.vim


" embedded sql in here documents
let b:old_syntax = b:current_syntax
unlet b:current_syntax
syn include @perlsqlHere syntax/sql.vim
let b:current_syntax = b:old_syntax
syn region perlsqlEmbeddedCpp matchgroup=perlsqlTags start=/<<'\?ENDSQL'\?/ end=/^ENDSQL$/ contains=@perlsqlHere
hi link perlsqlTags WarningMsg

