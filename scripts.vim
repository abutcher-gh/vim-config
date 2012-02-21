
" execute main distribution script before adding specializations
source $VIMRUNTIME/scripts.vim

if expand('%:t') =~? 'rfc\d\+' 
  setfiletype rfc 
  set nospell
endif 

