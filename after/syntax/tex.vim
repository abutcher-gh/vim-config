unlet b:current_syntax

syn include @CXX syntax/cpp.vim
"syn include @numXml syntax/xml.vim

syn region texCXXZone	matchgroup=texZone start="\\begin{lstlisting}" end="\\end{lstlisting}" containedin=ALL contains=@CXX

" change _cxx to cxx when found, fixed or reimplemented!
syn region texInlineCXX matchgroup=texZone containedin=texStatement start="\\\(lstinline\|_cxx\)\*\=\z([^\ta-zA-Z]\)"	end="\z1\|%stopzone\>" contains=@CXX

syn region texCXXLabel  containedin=@CXX,texCXXZone start="\~\~" end="\~\~"

hi link texCXXKW Preproc
hi link texCXXLabel Function
hi link texInlineCXX None
"hi link texCXXZone TexDelimiter

