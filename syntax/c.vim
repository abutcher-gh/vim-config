"
" FILE: c.vim
"
" ABSTRACT:
"
" AUTHOR: Ralf Schandl <schandl@de.ibm.com>
"   
" $Id: c.vim,v 1.1 2000/12/27 12:01:25 rks Exp $
"   
" =============================================================================
"

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
"---------[ END OF FILE c.vim ]------------------------------------------------
