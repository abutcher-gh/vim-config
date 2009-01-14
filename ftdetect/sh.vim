
" double check (inspect file) for non-sh files that are named *.sh

au! BufNewFile,BufRead *.sh runtime! scripts.vim | if &ft !~ "sh$" | set ft=sh | endif
