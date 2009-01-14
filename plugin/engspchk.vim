" engspchk.vim: Vim syntax file
" Language:    English
" Author:      Dr. Charles E. Campbell, Jr. <Charles.Campbell.1@gsfc.nasa.gov>
" Last Change: Nov 26, 2002
" Version:     28
"
" Environment Variables:
"
"  $CVIMSYN         : points to a directory holding the engspchk dictionaries
"                     ie., <engspchk.dict>, <engspchk.usr>, <engspchk.wb>
"                   
"  g:cvimsyn        : Vim variable, settable in your <.vimrc>, that points to
"                     a directory holding the user word database.
"                   
"  g:spchklang      : override name-of-file prefix with desired language
"                     prefix/filename (ie. gerspchk.vim ger frspchk.vim fr etc)
"                   
"  g:spchkpunc =0   : default, no new behavior
"              =1   : check for some simple English punctuation problems
"                     non-capitalized word after ellipse (... a)
"                     non-capitalized word after sentence ending character
"                     ([.?!])
"  g:spchk_autonext : if this variable exists, then \es and \et will also
"                     automatically jump to the next spelling error (\en)
"                     \ea, if a word is selected, will also do a \en.
"
" Finding Dictionaries:
"      If        g:cvimsyn exists, it is tried
"      Otherwise $CVIMSYN is tried
"      Otherwise each path on the runtimepath is tried
"      Otherwise quit with an error message
"
"      "Trying" involves checking if the spelling dictionary is 
"      filereadable(); if not, then if filereadable(expand())
"      works.  If a combination works, that path is set into
"      g:cvimsyn.
"
"      Note that the "eng" prefix can be changed via setting
"      g:spchklang or renaming <engspchk.vim>.  Then engspchk
"      will load:  (elide the [])
"
"         [eng]spchk.dict  Main word dictionary
"         [eng]spchk.usr   User's personal word dictionary
"         [eng]spchk.wb    English only -- Webster's 1913 dictionary extra words
"
"      The Webster's 1913 dictionary has had all words appearing
"      in the <engspchk.dict> file elided from it; hence it is
"      pretty much composed of uncommon English words.  Feel free
"      to remove the <enspchk.wb> dictionary if you'd rather these
"      unusual words not be loaded.
"
" Included Maps:  maps use <mapleader>, which by default is \
"  \ec : load engspchk
"  \et : add  word under cursor into database (temporarily - ie. just this file)
"  \es : save word under cursor into database (permanently)  (requires $CVIMSYN)
"  \en : move cursor to the next     spelling error
"  \ep : move cursor to the previous spelling error
"  \ea : look for alternative spellings of word under cursor
"  \eT : make word under cursor a BadWord (temporarily)
"        (opposite of \et)
"  \eS : make word under cursor a BadWord (permanently)  (requires $CVIMSYN)
"        (opposite of \es)
"        --removes words from user dictionary, not <*.dict>--
"
" Maps for Alternatives Window Only:
"  <cr> : on alternatives line, will put word under cursor in
"         searchword's stead
"  :q   : will quit the alternate-word window
"
" Usage:
"  Simply source the file in.  It does *not* do a "syntax clear", so that means
"  that you can usually just source it in on top of other highlighting.
"  NOTE: not all alphas of 6.0 support plugins, <silent>, etc.
"        engspchk can't check for them; all their versions are 600.
"        Besides, 6.1 is out nowadays.

" NON ENGLISH LANGUAGES:
"  There are versions of this script for languages other than English.
"  I've tried to make this script work for non-English languages by
"
"    (a) allowing one to rename the script with a different prefix
"    (b) using that prefix to load the non-English language dictionary
"
"  If you come up with a version for another language, please let me
"  know where on the web it is so that I can help make it known.
"
"    Dutch     : http://www.thomer.com/thomer/vi/nlspchk.vim.gz
"    German    : http://jeanluc-picard.de/vim/gerspchk/gerspchk.vim.gz
"    Hungarian : http://vim.sourceforge.net/scripts/script.php?script_id=22
"    Polish    : http://strony.wp.pl/wp/kostoo/download.htm#vim
"    Yiddish   : http://www.cs.uky.edu/~raphael/yiddish/vim.tar.gz

" Internal Functions: for vim versions 5.4 or later
"  SpchkSave(newword) : saves the word into <$CVIMSYN/engspchk.usr>
"  SpchkPrv()         : enables \ep map
"  SpchkNxt()         : enables \en map
"
" History:
" 28    : Nov 26, 2002: dropped support for Vim versions 5.x
" 27    : Nov 21, 2002: \eT map to make a word a BadWord 
"                       \eS map to make a word a permanent BadWord
"                       g:spchk_autonext implemented
" 26    : Nov 07, 2002: \en and \ep were skipping over folds.
"                       They now will delve into folds, opening
"                       them only if there's a spelling error within
"                       Bug-fix: Alternative spellings now works for
"                       two-letter words.
" 25    : Oct 03, 2002: Fixed bad bug (incomment code)
" 23    : Sep 11, 2002: BadWord for English now same as non-English
"                       Improvement made to loading procedure:
"                       one can let g:spchklang="..." then \ec
"                       and get the desired dictionary loaded.
" 22    : Sep 10, 2002: non-English languages' BadWord needed to be
"                       extended to more characters than \a
" 21    : Aug 28, 2002: removed spurious syn-case-ignore/match pair
" 20    : Aug 21, 2002: removed a superfluous <unique>
"                       fixed \ea bug (invoking twice caused problem)
" 19    : Aug 16, 2002: agrep-initialization bug fix
" 18    : Aug 05, 2002: g:spchkpunc added (tnx to Steve Hall)
" 17    : Aug 02, 2002: more documentation, small fix to menus for
"                       non-English language support.
" 16    : Aug 02, 2002: For vim6.0 or later, uses filereadable() to check
"                       if <engspck.vim> is readable (and issues an
"                       error message if so)
" 15    : May 28, 2002: Included has("menu") with menu tests
"                       <engspchk.dict> broken out to a separate file
"                       most norm changed to norm!
"                       Mats Bentsen : agrep's path now enclosed in ".."s.
"                                      Helps with Windows' directory names
"                                      with embedded spaces
"                       Renamed : usr_engspchk.vim    -> engspchk.usr
"                       Renamed : wb1913_engspchk.vim -> engspchk.wb
" v2.13 : Feb 27 2002 : One line alternates window now disappears after
"                       selection
" v2.12 : Feb 26 2002 : Building the one-word dictionary for \ea will now
"                       include user dictionary words.  The building process has been
"                       speeded up by temporarily turning syntax highlighting
"                       off and undo levels to -1.  Loading the Webster's 1913
"                       dictionary words has been commented out because the
"                       words therein are, in my humble opinion, typically arcane
"                       and hence clutter up the alternatives window.
" v2.11 : Feb 25 2002 : included note that 6.0 alphas may not work right
"                       (ie. 6.0z doesn't have <silent>) and engspchk
"                       has no way to test for them.
" v2.10 : Feb 20 2002 : Included allowing g:cvimsyn to supercede $CVIMSYN
"                       Engspchk now made into a quick-loading plugin
"                       Alternatives supports first-letter case retention
" v2.07 : Jul 17 2001 : fix to missing CVIMSYN environment variable message
" v2.06 : Jul 16 2001 : contains note about TK's "create" script
" v2.04 : Mar 19 2001 : \%# is back with 6.0y
" v2.03 : Feb 26 2001 : included automatic language detection/loading
" v2.02 : Feb 13 2001 : commented out \%#-using rule until CT gets it working!
"                       Fixed some contractions whose root word got into the main dictionary
"                       Fixed "extend", a new Vim syntax-related keyword
" v2.01 : Feb  9 2001 : includes <bib.vim> spell-checking
" v2.00 : Feb  5 2001 : For 6.0v or later: words will no longer flash in Error
"                       as they're being typed.  Thank you Chase Tingley for \%# !
" v1.28 : Jan 29 2001 : shortened SpchkNxt and SpchkPrv (thanks, Benji Fisher!)
" v1.27 : Jan 29 2001 : includes using agrep and \ea for alternative spelling
" v1.26 : Jan 25 2001 : removed a number of two-letter abbreviations & "ain"
" v1.25 : Jan 22 2001 : included 12000 more words from various online dictionaries
"                       I've also culled out a few misspellings that crept in from
"                       the original ispell dictionary that was used.
" v1.24 : Nov  1 2000 : included optional <engspchk2.vim> sourcing
" v1.22 : Oct  3 2000 : added "transparent" keyword to all GoodWords
" v1.20 : Sep 18 2000 : engspchk now saves using vim functions, avoiding
"                       any external program entanglements for versions 5.2
"                       or later
" v1.19 : Apr  7 2000 : more contractions and words: couldnt've, etc.
" v1.18 : Mar 28 2000 : included words from spelling bee and other dictionaries
"                       included "didn't" contraction, removed "didn didnt"
" v1.17 : Aug 12 1999 : the epoch
"------------------------------------------------------------------------------

" what language am I -- based on name of this file
"                    -or- if it previously exists
"   ie. engspchk gerspchk nlspchk hngspchk yidspchk etc
"       eng      ger      nl      hng      yid
"
"  b:spchklang: dictionary language prefix
"  b:spchkfile: prefix based on name of this file
if exists("g:spchklang")
 let b:spchklang= substitute(g:spchklang,'spchk\.vim',"","e")
 let b:spchkfile= substitute(expand("<sfile>:t"),'spchk\.vim',"","e")
else
 let b:spchklang= substitute(expand("<sfile>:t"),'spchk\.vim',"","e")
 let b:spchkfile= b:spchklang
endif
let s:spchkfile= b:spchkfile
let b:Spchklang=substitute(b:spchklang,'\(.\)\(.*\)$','\u\1\2','')

" Quick load:
if !exists("s:loaded_".s:spchkfile."spchk")
 let s:loaded_{b:spchkfile}spchk= 1

" ---------------------------------------------------------------------
" Pre-Loading Interface:
"       \ec invokes <Plug>LoadSpchk which invokes <SID>LoadSpchk()
 if !hasmapto('<Plug>LoadSpchk')
  nmap <unique> <Leader>ec <Plug>LoadSpchk
 endif

 " Global Maps
 nmap <script> <Plug>LoadSpchk :call <SID>LoadSpchk()<CR>

 " LoadSpchk: set up and actually load <engspchk.vim>
 silent! fu! <SID>LoadSpchk()
   let b:ch = &ch
   if exists("g:spchklang")
    let b:spchklang= substitute(g:spchklang,'spchk\.vim',"","e")
    let b:spchkfile= s:spchkfile
   else
    let b:spchklang= s:spchkfile
    let b:spchkfile= s:spchkfile
   endif
   let b:Spchklang=substitute(b:spchklang,'\(.\)\(.*\)$','\u\1\2','')
   let &ch  = 6
   exe 'runtime plugin/'.b:spchkfile.'spchk.vim'
   let &ch  = b:ch
   unlet b:ch
 endfunction

" ---------------------------------------------------------------------

 " Pre-Loading DrChip menu support:
 if has("gui_running") && has("menu")
  if !exists("g:DrChipTopLvlMenu")
   let g:DrChipTopLvlMenu= "DrChip."
  endif
  exe 'menu '.g:DrChipTopLvlMenu.'Load\ Spelling\ Checker<tab>\\ec	<Leader>ec'
 endif

 finish  " end pre-load
endif

" ================================
" Begin Actual Loading of Engspchk
" ================================

echomsg "Sourcing <".b:spchklang."spchk.vim>"

if has("gui_running") && has("menu")
 " remove \ec from DrChip menu
 silent! exe 'unmenu '.g:DrChipTopLvlMenu.'Load\ Spelling\ Checker'
endif

" Maps to facilitate entering new words
"  use  temporarily (\et)   remove temporarily (\eT)
"  save permanently (\es)   remove permanently (\eS)
nmap <silent> <Leader>et :syn case ignore<CR>:exe "syn keyword GoodWord transparent	" . expand("<cword>")<CR>:syn case match<CR>:if exists("g:spchk_autonext")<BAR>call SpchkNxt()<BAR>endif<CR>
nmap <silent> <Leader>eT :syn case ignore<CR>:exe "syn keyword BadWord "	  . expand("<cword>")<CR>:syn case match<CR>

" \es: saves a new word to a user dictionary (g:cvimsyn/engspchk.usr).
"      Uses vim-only functions to do save, thereby avoiding external programs
nmap <silent> <Leader>es	:call <SID>SpchkSave(expand("<cword>"))<CR>
nmap <silent> <Leader>eS    :call <SID>SpchkRemove(expand("<cword>"))<CR>

fu! <SID>SpchkSave(newword)
  silent 1sp
  exe "silent e ".g:cvimsyn."/".b:spchklang."spchk.usr"
  $put='syn keyword GoodWord transparent	'.a:newword
  silent wq
  syn case ignore
  exe "syn keyword GoodWord transparent ".a:newword
  syn case match
  if exists("g:spchk_autonext")
   call SpchkNxt()
  endif
endfunction

" SpchkRemove: implements \eS : depends on SpchkSave's putting one
"              user word per line in <*spchk.usr>.  This function
"              actually will delete the entire line containing the
"              new BadWord.
fu! <SID>SpchkRemove(killword)
  silent 1sp
  exe "silent e ".g:cvimsyn."/".b:spchklang."spchk.usr"
  exe "silent g/".a:killword."/d"
  silent wq
  syn case ignore
  exe "syn keyword BadWord ".a:killword
  syn case match
endfunction

" DrChip Menu
if has("gui_running") && has("menu")
 exe 'menu '.g:DrChipTopLvlMenu.b:Spchklang.'spchk.Add\ \ word\ to\ user\ dictionary\ (temporarily)<tab>\\et	\et'
 exe 'menu '.g:DrChipTopLvlMenu.b:Spchklang.'spchk.Remove\ \ word\ from\ user\ dictionary\ (temporarily)<tab>\\eT	\eT'
 exe 'menu '.g:DrChipTopLvlMenu.b:Spchklang.'spchk.Save\ word\ to\ user\ dictionary\ (permanently)<tab>\\es	\es'
 exe 'menu '.g:DrChipTopLvlMenu.b:Spchklang.'spchk.Remove\ word\ from\ user\ dictionary\ (permanently)<tab>\\eS	\eS'
 exe 'menu '.g:DrChipTopLvlMenu.b:Spchklang.'spchk.Move\ to\ next\ spelling\ error<tab>\\en	\en'
 exe 'menu '.g:DrChipTopLvlMenu.b:Spchklang.'spchk.Move\ to\ previous\ spelling\ error<tab>\\ep	\ep'
 exe 'menu '.g:DrChipTopLvlMenu.b:Spchklang.'spchk.Alternative\ spellings<tab>\\ea		\ea'
 exe 'menu '.g:DrChipTopLvlMenu.b:Spchklang.'spchk.Reload\ '.b:Spchklang.'spchk<tab>\\ec		\ec'
endif

" IGNORE CASE
syn case ignore

" Language Specials
" Ignore upper/lower case
" For non-English, allow accented (8-bit) characters as keywords
if b:spchklang !=? "eng"
 setlocal isk+=-,',`,128-255

elseif exists("g:spchkpunc") && g:spchkpunc != 0
 " These patterns are thanks to Steve Hall
 " Flag as error a non-capitalized word after ellipses
 syn match GoodWord	"\.\.\. \{0,2}\l\@="
 " but not non-capitalized word after ellipses plus period
 syn match BadWord "\.\.\.\. \{0,2}\l"

 " non-lowercased end-of-word problems
 " required: period/question-mark/exclamation-mark
 " optional: double/single quote
 " required: return/return-linefeed/space/two spaces
 " required: lowercase letter
 syn match BadWord "[\.?!][\"'][\=[\r\n\t ]\+\l"
endif

" ---------------------------------------------------------------------
" Find Dictionary Path:

" Set up g:cvimsyn (a vim variable) to the path to the <...spchk.dict>
if !exists("g:cvimsyn")
 let g:cvimsyn= $CVIMSYN
endif
"call Decho("trying g:cvimsyn<".g:cvimsyn.">")
if !filereadable(g:cvimsyn."/".b:spchklang."spchk.dict")
 let g:cvimsyn= expand(g:cvimsyn)
" call Decho("trying g:cvimsyn<".g:cvimsyn.">")
 if !filereadable(g:cvimsyn."/".b:spchklang."spchk.dict")
  let rtp= &rtp

  " search runtimepath
  while rtp != ""
   " get leftmost path from rtp
   let g:cvimsyn= substitute(rtp,',.*$','','')."/CVIMSYN"
"   call Decho("trying g:cvimsyn<".g:cvimsyn.">")

   " remove leftmost path from rtp
   if stridx(rtp,',') == -1
    let rtp= ""
   else
    let rtp      = substitute(rtp,'.\{-},','','e')
   endif

   " see if dictionary is readable
   if filereadable(g:cvimsyn."/".b:spchklang."spchk.dict")
    break
   else
    " attempt to expand and see if dictionary is readable then
    let g:cvimsyn= expand(g:cvimsyn)
"    call Decho("trying g:cvimsyn<".g:cvimsyn.">")
    if filereadable(g:cvimsyn."/".b:spchklang."spchk.dict")
     break
    endif
   endif
  endwhile
 endif
endif

" The Dictionary
" ==============
if !filereadable(g:cvimsyn."/".b:spchklang."spchk.dict")
 echomsg b:Spchklang."spchk is unable to find <".b:spchklang."spchk.dict>!"
 finish
endif
echomsg "Loading  <".g:cvimsyn."/".b:spchklang."spchk.dict".">"
exe "so ".g:cvimsyn."/".b:spchklang."spchk.dict"

" BadWord (misspelling) highlighting done here.  Plus
" comment support -- do spell-checking inside comments.
"                 This can be done only for those syntax
"                 files' comment blocks that contains=@cluster.
"                 The code below adds GoodWord and BadWord to
"                 various clusters.  If your favorite syntax
"                 comments are not included, send a note
"                 to your syntax file's maintainer about it!
let incomment=0
if     &ft == "amiga"
  syn cluster amiCommentGroup		add=GoodWord,BadWord
  let incomment=1
elseif &ft == "bib"
  syn cluster bibVarContents     	contains=GoodWord,BadWord
  syn cluster bibCommentContents 	contains=GoodWord,BadWord
  let incomment=1
elseif &ft == "c" || &ft == "cpp"
  syn cluster cCommentGroup		add=GoodWord,BadWord
  let incomment=1
elseif &ft == "csh"
  syn cluster cshCommentGroup		add=GoodWord,BadWord
  let incomment=1
elseif &ft == "dcl"
  syn cluster dclCommentGroup		add=GoodWord,BadWord
  let incomment=1
elseif &ft == "fortran"
  syn cluster fortranCommentGroup	add=GoodWord,BadWord
  syn match   fortranGoodWord contained	"^[Cc]\>"
  syn cluster fortranCommentGroup	add=fortranGoodWord
  hi link fortranGoodWord fortranComment
  let incomment=1
elseif &ft == "sh" || &ft == "ksh" || &ft == "bash"
  syn cluster shCommentGroup		add=GoodWord,BadWord
  let incomment=1
elseif &ft == "tex"
  syn cluster texCommentGroup		add=GoodWord,BadWord
  syn cluster texMatchGroup		add=GoodWord,BadWord
  let incomment=2
elseif &ft == "vim"
  syn cluster vimCommentGroup		add=GoodWord,BadWord
  let incomment=1
endif

" The Raison D'Etre! Highlight the BadWords
" I've allowed '`- in non-English words
if incomment == 0 || incomment == 2
 if b:spchklang == "eng"
  syn match   BadWord		"\<[^[:punct:][:space:][:digit:]]\+\>"
 else
  syn match   BadWord		"\<[^[!@#$%^&*()_+=[\]{};:",<>./?\\|[:space:][:digit:]]\+\>"
 endif
endif
if incomment == 1 || incomment == 2
 if b:spchklang == "eng"
  syn match   BadWord contained	"\<[^[:punct:][:space:][:digit:]]\+\>"
 else
  syn match   BadWord contained	"\<[^[!@#$%^&*()_+=[\]{};:",<>./?\\|[:space:][:digit:]]\+\>"
 endif
endif

" Contractions and other language special handling
if b:spchklang ==? "eng"
 " Note: *matches* need to follow the BadWord so that they take priority!
 " Abbreviations, Possessives, Etc.  For these to be recognized properly,
 " these contractions' word prior to the "'" has been removed from the
 " keyword dictionaries above and moved here.
 syn match GoodWord	"\<\(shouldn't've\|couldn't've\|mightn't've\|wouldn't've\|mustn't've\|needn't've\|hadn't've\|mayn't've\|shan't've\|she'll've\|should've\|shouldn't\|they'd've\|can't've\|could've\|couldn't\|he'll've\|might've\|mightn't\|ought've\|oughtn't\|shall've\|she'd've\|there'll\|there've\|where'er\|won't've\|would've\|wouldn't\|you'd've\|daren't\|doesn't\|haven't\|he'd've\|howe'er\|it'd've\|must've\|mustn't\|needn't\|there'd\|they'll\|they're\|they've\|we'd've\|weren't\|what'll\|what've\|aren't\|ch'ing\|didn't\|hadn't\|hasn't\|i'd've\|may've\|mayn't\|shan't\|she'll\|should\|they'd\|wasn't\|who've\|you'll\|you're\|you've\|ain't\|can't\|cap'n\|could\|don't\|haven\|he'll\|isn't\|might\|ne'er\|ought\|shall\|she'd\|there\|we'll\|we're\|we've\|where\|won't\|would\|you'd\|e'er\|he'd\|howe\|i'll\|i've\|must\|need\|o'er\|shan\|they\|we'd\|what\|are\|can\|cap\|don\|i'd\|i'm\|may\|she\|who\|won\|you\|he\|it\|ne\|we\|a\|i\|o\)\>"
 syn match GoodWord	"\(et al\|ph\.d\|e\.g\|i\.e\|mrs\|dr\|ex\|jr\|mr\|ms\|mba\|pm\)\."
 syn match GoodWord	"ex-"
 syn match GoodWord	"'s\>"

 " these are words but have special meaning in vim files, so they can't be keywords :o
 syn match GoodWord	"\<\(transparent\|contained\|contains\|display\|extend\|fold\|skip\)\>"
endif

" allows <engspchk.vim> to work better with LaTeX
if &ft == "tex"
  syn match GoodWord	"{[a-zA-Z|@]\+}"lc=1,me=e-1
  syn match GoodWord	"\[[a-zA-Z]\+]"lc=1,me=e-1
  syn match texGoodWord	"\\[a-zA-Z]\+"lc=1,me=e-1	contained
  hi link texGoodWord texComment
  syn cluster texCommentGroup	add=texGoodWord
endif

" ignore web addresses and \n for newlines
syn match GoodWord	"\<http://www\.\S\+"
syn match GoodWord	"\\n"

" load user's personal dictionary
if filereadable(g:cvimsyn."/".b:spchklang."spchk.usr") > 0
 echomsg "Loading  <".b:spchklang."spchk.usr>"
 exe "so ".g:cvimsyn."/".b:spchklang."spchk.usr"
endif
if b:spchklang ==? "eng" && filereadable(g:cvimsyn."/engspchk.wb") > 0
 echomsg "Loading  <engspchk.wb>"
 exe "so ".g:cvimsyn."/engspchk.wb"
endif

" RESUME CASE SENSITIVITY
syn case match

" BadWords are highlighted with Error highlighting (by default)
hi link BadWord	Error

" ---------------------------------------------------------------------
" Functions:  must have vim 5.04 or later
" Support for moving to next/previous spelling error
nmap <silent> <Leader>en	:call SpchkNxt()<CR>
nmap <silent> <Leader>ep	:call SpchkPrv()<CR>

" ignores people's middle-name initials
syn match   GoodWord	"\<[A-Z]\."

" -------------------------------------------------------------------
" \en : calls this function to search for next spelling error
function! SpchkNxt()
  let errid   = synIDtrans(hlID("Error"))
  let lastline= line("$")
  let curcol  = 0
  let fenkeep= &fen
  set nofen

  norm! w

  " skip words until we find next error
  while synIDtrans(synID(line("."),col("."),1)) != errid
    norm! w
    if line(".") == lastline
      let prvcol=curcol
      let curcol=col(".")
      if curcol == prvcol
        break
      endif
    endif
  endwhile

  " cleanup
  let &fen= fenkeep
  if foldlevel(".") > 0
   norm! zO
  endif
  unlet curcol
  unlet errid
  unlet lastline
  if exists("prvcol")
    unlet prvcol
  endif
endfunction

" -------------------------------------------------------------------
" \ep : calls this function to search for previous spelling error
function! SpchkPrv()
  let errid = synIDtrans(hlID("Error"))
  let curcol= 0
  let fenkeep= &fen
  set nofen

  norm! b

  " skip words until we find previous error
  while synIDtrans(synID(line("."),col("."),1)) != errid
    norm! b
    if line(".") == 1
      let prvcol=curcol
      let curcol=col(".")
      if curcol == prvcol
        break
      endif
    endif
  endwhile

  " cleanup
  let &fen= fenkeep
  if foldlevel(".") > 0
   norm! zO
  endif
  unlet curcol
  unlet errid
  if exists("prvcol")
    unlet prvcol
  endif
endfunction

map <silent> <Leader>ea :call <SID>SpchkAlternate(expand("<cword>"))<CR>

" Use Chase Tingley patch: prevents Error highlighting
" of words while one is typing them.  \%* is a new magic
" atom that matches zero-length if that is where the cursor
" currently is.
syn match GoodWord "\<\k\+\%#\>"
syn match GoodWord "\<\k\+'\%#"

" -----------------------------------------------------------------
" SpchkAlternate: extract words that are close in spelling
function! <SID>SpchkAlternate(wrd)
  let spchklang= b:spchklang

  if exists("g:esc_alternate")
    " re-use wordlist in bottom window
    exe "norm! \<c-w>bG0DAAlternate<".a:wrd.">: \<Esc>"

  elseif filereadable(g:cvimsyn."/".spchklang."spchk.wordlist")
    " utilize previously generated <engspchk.wordlist>
    let g:esc_alternate= 1

    " Create a one line window to hold dictionaries during conversion
    bo 1new
    setlocal lz
    setlocal winheight=1
    setlocal bt=nofile
    setlocal noswapfile
    setlocal nobl
    silent exe "norm! GoAlternate<".a:wrd.">: \<Esc>"

  else
    " generate <engspchk.wordlist> from <engspchk.vim>
    let g:esc_alternate= 1
    echo "Building <".spchklang."spchk.wordlist>"
    echo "This may take awhile, but it is a one-time only operation."
    echo "Please be patient..."

    " Create a one line window to hold dictionaries during conversion
    bo 1new
    setlocal lz
    setlocal winheight=1
    setlocal bt=nofile
    setlocal noswapfile
    setlocal nobl

    " for quicker operation
    "   turn off undo
    "   turn on lazy-update
    "   make a temporary one-line window
    let ulkeep= &ul
    set ul=-1

    " Read in main <[eng]spchk.dict> dictionary
    if filereadable(g:cvimsyn."/".spchklang."spchk.dict") > 0
     exe "silent 0r ".g:cvimsyn."/".spchklang."spchk.dict"
    else
     echoerr "cannot seem to read <".g:cvimsyn."/".spchklang."spchk.dict>!"
     return
    endif

    " Read in user's <[eng]spchk.usr> dictionary
    if filereadable(g:cvimsyn."/".spchklang."spchk.usr") > 0
     exe "silent 0r ".g:cvimsyn."/".spchklang."spchk.usr"
    endif

    " Read in Webster's 1913-additional-word <[eng]spchk.usr> dictionary
    if spchklang ==? "eng" && filereadable(g:cvimsyn."/engspchk.wb")
     exe "silent 0r ".g:cvimsyn."/engspchk.wb"
    endif

    " Remove non-dictionary lines and make it one word per line
    echo "Doing conversion..."
    silent %v/^syn keyword GoodWord transparent/d
    %s/^syn keyword GoodWord transparent\t//
    silent! exe "%s/\\s\\+/\<CR>/g"
    echo "Writing ".g:cvimsyn."/".spchklang."spchk.wordlist"
    exe "w! ".g:cvimsyn."/".spchklang."spchk.wordlist"
    silent %d
    silent exe "norm! $oAlternate<".a:wrd.">: \<Esc>"
    let &ul= ulkeep
  endif

  nnoremap <buffer> <silent> <CR> :call <SID>SpchkChgWord()<CR>
  function! <SID>SpchkChgWord()
    exe "norm! \<C-W>k"
    if col(".") == 1
     exe "norm! ea#\<Esc>b"
    else
     exe "norm! hea#\<Esc>b"
    endif
    norm! yl
    if match(@@,'\u') == -1
     " first letter not capitalized
     exe "norm! de\<C-W>blbye\<C-W>kPlxb\<C-W>b:q!\<CR>"
    else
     " first letter *is* capitalized
     exe "norm! de\<C-W>blbye\<C-W>kPlxb~h\<C-W>b:q!\<CR>"
    endif
    unlet g:esc_alternate
    if exists("g:spchk_autonext")
     call SpchkNxt()
    endif
  endfunction

  cnoremap <silent> <buffer> q :unlet g:esc_alternate<CR>:q!<CR>
  setlocal nomod nowrap ic nolz

  " let's add a wee bit of color...
  set lz
  syn match altLeader	"^Alternate"
  syn match altAngle	"[<>]"
  hi def link altLeader	Statement
  hi def link altAngle	Delimiter

  " Build patterns based on permutations of up to 3 letters
  exe "silent norm! \<c-w>b"
  if strlen(a:wrd) > 2
   " agrep options:  -2  max qty of errors permitted in finding approx match
   "                 -i  case insensitive search enabled
   "                 -w  search for pattern as a word (surrounded by non-alpha)
   "                 -S2 set cost of a substitution to 2
   exe "silent r! agrep -2 -i -w -S2 ".a:wrd." \"".g:cvimsyn."/".spchklang."spchk.wordlist\""
  else
   " handle two-letter words
   exe "silent r! agrep -1 -i -w ".a:wrd." \"".g:cvimsyn."/".spchklang."spchk.wordlist\""
  endif
  silent %j
  silent norm! 04w
  setlocal nomod
  set nolz
endfunction

echo "Done Loading <".b:spchklang."spchk.vim>"

" vim: ts=30
