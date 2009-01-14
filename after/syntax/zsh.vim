" Fix bug (with vim 7.2? -- didn't notice in <= 7.1) where
" a stray apostrophe or quote in a comment higher up in the
" file can cause the rest of the file (up to the matching
" delimiter) to be considered a string.
"
" This just removes the "display" specifier; it is not appropriate
" since a single ' appearing in a comment will be considered as a
" start (or end) of a literal string range if the comment line is
" outside the visible area.
" 
syn clear   zshComment
syn region  zshComment          oneline start='\%(^\|\s\)#' end='$'
                                \ contains=zshTodo,@Spell

