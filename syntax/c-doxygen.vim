"
" FILE: c-doxygen.vim
"
" ABSTRACT:
"
" AUTHOR: Ralf Schandl <schandl@de.ibm.com>
"   
" $Id: c-doxygen.vim,v 1.1 2000/12/27 12:01:25 rks Exp $
"   
" =============================================================================
"

syn match cDoxygen    contained /[^\\]\\[ "A-Za-z]*/hs=s+1 contains=cTodo,cdoxyCommentSpecial
syn match cdoxyCommentSpecial display contained /"([^"]|\\")*"/
syn match cCommentTitle contained /\([A-Za-z0-9_:][A-Za-z0-9_\-\+=<>!:]*([^)]*)\)/
syn match cGhost contained /\(`\)/
syn match cCommentTitle contained /`\([^ 	()]*\)/ contains=cGhost
syn match cTodo		contained /\(TODO\)\|\(FIXME\)\|\(XXX\)\|\(\\todo\)/
highlight link cDoxygen  PreProc
highlight link cGhost  Ignore
highlight link cCommentTitle  PreProc
highlight link cdoxyCommentSpecial LineNr

syn cluster	cCommentGroup	contains=cTodo,cDoxygen,cCommentTitle

try
    source $HOME/.vim/doxyvim/doxygen.vim
catch /.*/
    try
        source $HOME/vimfiles/doxyvim/doxygen.vim
    catch /.*/
        source $VIM/vimfiles/doxyvim/doxygen.vim
    endtry
endtry

"    vim:tw=75 et ts=4 sw=4 sr ai comments=\:\" formatoptions=croq 
"
"---------[ END OF FILE c-doxygen.vim ]----------------------------------------
