
" execute main distribution script before adding specializations
" (but allow for spaces in filenames)
let s:isfname = &isfname
let &isfname .= ",32"
source $VIMRUNTIME/scripts.vim
let &isfname = s:isfname

if did_filetype()
  finish
endif

if expand('%:t') =~? 'rfc\d\+'
  setfiletype rfc
  set nospell
  finish
endif

let s:line1 = getline(1)

if s:line1 =~ '^From [0-9a-f]\{40\}'
  setfiletype git-diff
  finish
endif

if s:line1 =~ '^#!/bin/ash'
   set ft=sh
endif
