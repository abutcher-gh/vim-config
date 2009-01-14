unlet b:current_syntax

syn include @CXX syntax/cpp.vim
"syn include @numXml syntax/xml.vim

syn region texCXXZone	matchgroup=texZone start="\\begin{lstlisting}"		end="\\end{lstlisting}\|%stopzone\>"	containedin=texZone contains=@CXX
syn region texCXXZone	matchgroup=texZone start="\\begincxx"		end="\\endcxx\|%stopzone\>"	containedin=texStatement contains=@CXX

syn region texInlineCXX matchgroup=texZone containedin=texStatement start="\\\(lstinline\|cxx\)\*\=\z([^\ta-zA-Z]\)"	end="\z1\|%stopzone\>" contains=@CXX

syn region texCXXLabel  containedin=@CXX,texCXXZone start="\~\~" end="\~\~"

hi link texCXXKW Preproc
hi link texCXXLabel Function
hi link texInlineCXX None
"hi link texCXXZone TexDelimiter

