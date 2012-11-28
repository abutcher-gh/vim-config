
" execute main distribution script before adding specializations
" (but allow for spaces in filenames)
let s:isfname = &isfname
let &isfname .= ",32"
source $VIMRUNTIME/scripts.vim
let &isfname = s:isfname

if expand('%:t') =~? 'rfc\d\+' 
  setfiletype rfc 
  set nospell
endif 

