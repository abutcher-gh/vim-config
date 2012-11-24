
let g:initial = " "
let g:lead = " "

let g:intellisense_vimfiles = $VIM . '/vimfiles'

set sessionoptions=blank,buffers,curdir,folds,help,options,tabpages,winsize,winpos,resize

filetype plugin on

" attributes used by the file-to-html converter
"
let use_xhtml=1
let html_use_css=1
let html_js=1
let html_number_lines=1

let c_c_vim_compatible = 1
let c_C99 = 1

" zsh is great but running external commands through it via
"   execvp( { "zsh", "-c", ... } )
" as vim does lands you in the wrong directory (pwd is simply '.')
" in the case where one of the directories in the cwd is examinable
" but not readable (--x).  Since my system has /home setup this way
" most of my external commands end up starting in the wrong dir after
" a cd.  It seems that this only happens after a :cd or :lcd in vim
" though.  It all works fine if I run commands without changing
" directory.
" Workaround for the moment until I figure out whats what is to use
" bash to shell out from vim.
if &shell =~ "zsh"
   set shell=bash
endif

" some simple printer setting commands
"
if $OS =~ "Windows"
   let s:printfont="DejaVu_Sans_Mono"
else
   let s:printfont=""
endif
function! PrintFont(...)
   let &printfont = s:printfont . a:1
endfunc
command! -nargs=1 PrintFont :call PrintFont(<f-args>)
command! CodePrintLandscape set printoptions=paper:A4,number:y,left:5mm,right:5mm,top:12mm,bottom:12mm,portrait:n
command! CodePrintPortrait  set printoptions=paper:A4,number:y,left:5mm,right:5mm,top:12mm,bottom:12mm,portrait:y
command! TextPrintLandscape set printoptions=paper:A4,number:n,left:5mm,right:5mm,top:12mm,bottom:12mm,portrait:n
command! TextPrintPortrait  set printoptions=paper:A4,number:n,left:5mm,right:5mm,top:12mm,bottom:12mm,portrait:y
command! ColorPrinter set printdevice=xcpx5
command! BlackPrinter set printdevice=xcpm1
PrintFont :h7

function! Repath()
 
   let &path = ""

   " stick the C++ include path into Vim's file navigation search path
   if $OS =~ "Windows"
      if $USE_GCC == "1"
         let &path = ".," . substitute($CPATH.';'.$CPLUS_INCLUDE_PATH, ';', ',', 'g') . &path
      else
         let &path = ".," . substitute($INCLUDE, ';', ',', 'g') . &path
      endif
   else
      let &path = ".," . substitute($CPATH.':'.$CPLUS_INCLUDE_PATH, ':', ',', 'g') . &path
   endif

endfunction

function! PrependPath( p )
   let &path = a:p . "," . &path
endfunc

function! AppendPath( p )
   let &path = &path . "," . a:p
endfunc

function! RemovePath( p )
   exe "set path-=" . a:p
endfunc

command! -nargs=1 PrependPath :call PrependPath(<f-args>)
command! -nargs=1 AppendPath  :call AppendPath(<f-args>)
command! -nargs=1 RemovePath  :call RemovePath(<f-args>)

function! AddGccSysPaths()
   
                           let l:stdopt = '-std=c++11' | let l:dummy = system('echo | '.$CROSS_PREFIX.'g++ -xc++ -E - '.l:stdopt) |
   if v:shell_error != 0 | let l:stdopt = '-std=c++0x' | let l:dummy = system('echo | '.$CROSS_PREFIX.'g++ -xc++ -E - '.l:stdopt) | endif
   if v:shell_error != 0 | let l:stdopt = '' | endif

   try

      if $OS =~ "Windows"
         let &path = &path . "," . system(
                \'set CPLUS_INCLUDE_PATH= & set C_INCLUDE_PATH= & set CPATH= | '.$CROSS_PREFIX.'g++ '.l:stdopt.' -Wp,-v -x c++ -E - 2>&1
                \| sed -n "/^ /{s/^ //;s/$/,/;H}; /^End/{x;s/\n//g;p}"
                \')
      else
         let &path = &path . "," . system(
                \'echo | CPLUS_INCLUDE_PATH= C_INCLUDE_PATH= CPATH= ${CROSS_PREFIX}g++ '.l:stdopt.' -Wp,-v -x c++ -E - 2>&1
                \| sed -n "/^ /s/^ //p"
                \| tr "\n" ","
                \| sed "s/,$//"
                \')
      endif

   catch
      echo "Failed to query gcc."
   endtry

endfunction

command! ClearPaths let &path = ""
command! Repath call Repath()
command! AddGccSysPaths call AddGccSysPaths()

Repath

" fonts:
"
" DejaVu Sans Mono       -- http://dejavu.sourceforge.net/wiki/index.php/Main_Page 
" Anonymous              -- http://www.ms-studio.com/FontSales/anonymous.html
" ProFont                -- http://www.tobias-jung.de/seekingprofont/
" MonteCarlo             -- http://www.bok.net/MonteCarlo/
"
" Proggy{Square,Tiny}SZ  -- http://www.proggyfonts.com/index.php?menu=download
" Opti                   -- http://www.proggyfonts.com/index.php?menu=download

" font names are subtly different in Windows than in X
if $OS =~ "Windows"
   let s:font="DejaVu_Sans_Mono:h"
   let s:anonfont="Anonymous:h"
   let s:profont="ProFontWindows:h"
   let s:montefont="MonteCarlo:h"
else
   let s:font="DejaVu\ Sans\ Mono\ "
   let s:anonfont="Anonymous\ "
   let s:profont="ProFont\ "
   let s:montefont="MonteCarlo\ "
endif
let s:deffontsize=9
let s:deffontsizeanon=8
let s:deffontsizepro=8
let s:deffontsizemonte=8

" command to switch font/size easily
"
function! Font(...)
   if a:0 == 0
      let &guifont = s:font . '9'
   else
      if a:1 == "default"
         set guifont=
      else
         let l:size = a:1
         if a:0 > 1 | let l:name = a:2 | else | let l:name = '' | endif
         if l:size == "-"
            exe ":let l:size = s:deffontsize" . l:name
         endif
         exe ":let \&guifont = s:" . l:name . "font . '" . l:size . "'"
      endif
   endif
   let g:last_guifont = &guifont
endfunc
command! -nargs=* Font :call Font(<f-args>)

" enable thesaurus and spell checker.
"
" NOTE: completion X:  during insert mode:
"     ctrl-x ctrl-t == thesaurus
"     ctrl-x ctrl-k == complete from dictionary
"     ctrl-x ctrl-s == spelling suggestion
"     ctrl-x ctrl-o == omni-completion!
"
set thesaurus=~/.wordlists/mthes/mobythes.aur
set spell

" fix up vim's test diff on some systems by using stdin rather than a
" temporary file for the first input.
function! PortableDiff()
   let opt = ""
   if &diffopt =~ "icase" | let opt = opt . "-i " | endif
   if &diffopt =~ "iwhite" | let opt = opt . "-b " | endif
   silent execute "!diff -a " . opt . " - < " . v:fname_in . " " . v:fname_new .  " > " . v:fname_out
endfunction
set diffexpr=PortableDiff()

" if diffing, open the biggest window possible.. AJB: This seems to me
" like the best way to open a full screen diff window.  But it
" probably isn't!
if &diff
   set lines=1000 columns=1000
   " turn off spelling in terminal (it can't do underlining and
   " background highlighting confuses the diff)
   if &term !~ "gui" 
      set nospell
   endif
endif
" add some shortcuts
" next and prev change
nmap <Bar><Down> ]c
nmap <Bar><Up> [c
" pull and push change
nmap \g :diffget<CR>
nmap \p :diffput<CR>
nmap \n ]c
nmap <Bar>N [c
nmap \z :diffupdate<CR>

" remove some unnecessary gui bits
set go-=m
set go-=t
set go-=T
set go-=r

function! ToggleGuiOption(option)
   if &go =~ a:option
      exe ":set go-=" . a:option
   else 
      exe ":set go+=" . a:option
   endif
endfunction

" some people like to add permanent scroll bars
" make it easy for them
map <silent> <A-Down>  :call ToggleGuiOption('b')<CR>
map <silent> <A-Right> :call ToggleGuiOption('r')<CR>
map <silent> <A-Left>  :call ToggleGuiOption('l')<CR>

" a scroll bar at the top is not common, set
" alt up to toggle the menu instead
map <silent> <A-Up>    :call ToggleGuiOption('m')<CR>

" set default font unless overridden by VIMFONT var
if expand("$VIMFONT") == "$VIMFONT" && !exists("g:last_guifont")
   Font 9
else
   exec $VIMFONT
endif

" tag search path
let &tags="./tags;/,tags;/," . substitute($TAG_PATHS, '##', ',', 'g') 

" typelist window configuration
set updatetime=1000
let Tlist_Use_SingleClick=1
let Tlist_Inc_Winwidth=0

" some macros to manage buffers
nmap - :bp<CR>
nmap = :bn<CR>
nmap _ :bd<CR>
nmap + :w<CR>:bn<CR>

" some macros to manage folds
"
"   open fold at cursor
"   close fold at cursor
"   open recursively at cursor
"   close recursively at cursor
"   open all folds at the current level
"   close all folds at the current level
"   open all folds at all levels
"   close all folds at all levels
"
nmap f<Left> zc
nmap f<Right> zo
nmap f<Up> zC
nmap f<Down> zO
nmap f<PageUp> zr
nmap f<PageDown> zm
nmap f<Ins> zR
nmap f<Del> zM

function! GetRelativePath( BasePath, TargetPath )

   let base   = split( resolve(expand(a:BasePath)),   '[\\/]')
   let target = split( resolve(expand(a:TargetPath)), '[\\/]')

   let bname = ""
   let tname = ""

   " determine matching stem
   while 1

      if bname != tname 
         break
      endif

      if len(base) == 0 || len(target) == 0
         let tname = ""
         let bname = ""
         break
      endif 

      let [ bname; base   ] = base
      let [ tname; target ] = target

   endwhile

   let rc = repeat("../",len(base))

   if !empty(bname) | let rc .= "../" | endif
   if !empty(tname) | let rc .= tname."/" | endif

   return  rc . join(target, "/")

endfunction

" functions to handle file navigation; step into/out-of include and
" toggle between associate files
"
if !exists("g:file_nav_stack")
   let g:file_nav_stack=[]
endif

function! PushInclude(split) range
   let l:arg = expand("<cfile>") 
   let l:fullpath = findfile( l:arg )

   " if file starts with a/ or b/ and is not readable, assume
   " this buffer is a git-diff and try the path without the
   " first two chars (in this and all parent directories)
   if match( l:arg, '[ab]/' ) == 0 && !filereadable( l:fullpath )
      " note: the relative path formation here may turn out to be more
      " annoying than useful.  only time will tell.
      " let l:fullpath = GetRelativePath(getcwd(),findfile( l:arg[2:], ".;" ))
      " GetRelativePath needs fixing as per Mark P's boost::fs change
      " to handle trailing dirs/files
      let l:fullpath = findfile( l:arg[2:], ".;" )
   endif

   if !filereadable( l:fullpath )
      if l:fullpath == ''
         echo "File '" . l:arg . "' not found in search path."
      else
         echo "File '" . l:fullpath . "' not readable."
      endif
      return
   endif
   let l:item = expand("%")
   if l:item == ""
      let l:item = '!:!' . winbufnr(0)
   endif
   call insert( g:file_nav_stack, getpos('.') )
   call insert( g:file_nav_stack, l:item )
   try
      if a:split
         sp `=l:fullpath`
      else
         e `=l:fullpath`
      endif
   catch
      echo "File '" . expand("<cfile>:t") . "' was readable but can't abandon current buffer. (target's full path is '" . l:fullpath . "')"
      call remove( g:file_nav_stack, 0, 0 )
   endtry
endfunction

function! PopInclude() range
   try
      let l:val=get( g:file_nav_stack, 0 )
      call remove( g:file_nav_stack, 0, 0 )

      let l:pos=get( g:file_nav_stack, 0 )
      call remove( g:file_nav_stack, 0, 0 )

      if !filereadable( l:val )
         if match( l:val, '!:!' ) == 0
            let l:val = l:val[3:]
         else
            echo "File '" . l:val . "' not readable, skipped."
            return
         endif
      endif
      " try existing buffer first
      try
         exe "b ".l:val
      catch
         e `=l:val`
      endtry
      " reposition cursor
      call setpos( '.', l:pos )
   catch
      echo "No file navigation stack."
   endtry
endfunction


function! EditParent() range

   try 
      e %:h
   catch 
      e %:p:h
   endtry
   e

endfunction

" these lists contain file pattern match, path mutation list, and
" target extension list.
"
let g:EATypeList =
\[
\   [ 'c\(pp\|xx\)\?',    ['', 's/\(.*\)src/\1include/'
\                            , 's:\(.*\)src:\1include/\*:'
\                         ],                              ['inl', 'impl', 'ixx', 'h', 'hpp', 'hxx'] ],
\   [ 'h\(pp\|xx\)\?',    ['', 's/\(.*\)include/\1src/'
\                            , 's:\(.*\)include/[^/]*:\1src:'
\                         ],                              ['cpp', 'cxx', 'c', 'inl', 'impl', 'ixx'] ],
\   [ 'i\(nl\|xx\|mpl\)', ['', 's/\(.*\)src/\1include/'
\                            , 's:\(.*\)src:\1include/\*:'
\                         ],                              ['h', 'hpp', 'hxx', 'cpp', 'cxx', 'c']    ],
\   [ 'l', ['', 's/l$/y/'], ['y'] ],
\   [ 'y', ['', 's/y$/l/'], ['l'] ],
\]

function! EditAssociate() range
   let realext=expand("%:e")

   for [pattern, pathlist, extlist] in g:EATypeList
      
      if realext =~ pattern
         for ext in extlist
         
            for path in pathlist

               let full=expand("%:p:r:".path)

               let name=expand(full.".".ext)
               
               if filereadable(name)
                  " windows frig, places cursor at top using :e
                  try
                     exe "b ".name
                     return
                  catch
                  endtry
                  try
                     e `=name`
                     return
                  catch
                     echo "File '" . name . "' was readable but can't abandon current buffer."
                     return
                  endtry
               endif
            endfor

         endfor
      endif
   endfor

   echo "No associate of '".expand("%:t")."' could be found with provided rules."

endfunction

function! MkdirAndEdit( file )

   let dir=fnamemodify(expand(a:file), ":h")
   let file=fnamemodify(expand(a:file), ":t")

   if !isdirectory(dir)
      if inputdialog("Create directory '".dir."' for file '".file."'? ", "y") == "y"
         :call mkdir(dir, "p")
      else
         echo "Ignored."
         return
      endif
   endif
   :exe ":e ".expand(a:file)

endfunction

function! ListAssociates( ArgLead, CmdLine, CursorPos )
   
   let rc=""

   let realext=expand("%:e")

   let pwd=getcwd()

   for [pattern, pathlist, extlist] in g:EATypeList
      
      if realext =~ pattern
         for path in pathlist
            for ext in extlist

               let full=expand("%:p:r:".path)
               let name=expand(full.".".ext)

               let rc .= GetRelativePath(pwd,name) . "\n"

            endfor
         endfor
      endif
   endfor
   
   return rc

endfunction
com! -bang -nargs=1 -complete=custom,ListAssociates EditAssociate :call MkdirAndEdit(<q-args>)

" Vertical split and edit the base filename (i.e. the filename without
" extension.)  This is useful, for example, for jumping from a patch
" reject such as file.xyz.rej to the file being patched (file.xyz).
function! SplitEditBase()

   if expand("%:e") == ""
      echo "File '".expand("%:t")."' does not have an extension."
      return
   endif

   let oldspr = &splitright
   let basefile=expand("%:p:r:")

   if !filereadable(basefile)
      echo "No such file '".basefile."' exists."
      return
   endif

   try
      set splitright
      vs `=basefile`
   catch
      echo "File '" . basefile . "' could not be opened."
   endtry
   let &splitright = oldspr

endfunction

" some keys for normal-mode file navigation
"
"  A-\  --  show current file's directory
"  A-.  --  navigate into the file below the cursor
"  A-,  --  return to the previous file on the navigation stack
"  A-/  --  switch to an associated file if it exists (h->cpp, cpp->h etc.)
"
nmap <silent> <A-\> :call EditParent()<CR>
nmap <silent> <A-.> :call PushInclude(0)<CR>
nmap <silent> <A-<Bar>> :call PushInclude(1)<CR>
nmap <silent> <A-,> :call PopInclude()<CR>
nmap <silent> <A-/> :call EditAssociate()<CR>
nmap <silent> <A-?> :call SplitEditBase()<CR>

"
" ALT/META <A-*>/<M-*> only works in an environment supporting
" keyboard modifiers (e.g. in X or Windows).  The two character
" <backslash><char> works fine for basic character terminals and, of
" course, also in X and Windows.
"
" although the push with split looks strange |> instead of \.
" all you need is to hold shift whilst using the normal goto
" sequence
"
nmap <silent> \\ :call EditParent()<CR>
nmap <silent> \. :call PushInclude(0)<CR>
nmap <silent> <Bar>> :call PushInclude(1)<CR>
nmap <silent> \, :call PopInclude()<CR>
nmap <silent> \/ :call EditAssociate()<CR>
nmap <silent> <Bar>? :call SplitEditBase()<CR>
nmap \<Tab> :EditAssociate<Space>

" focus previously focused window
nmap <silent> <Tab> 
nmap <silent> <C-Tab> 

" window resizing
if !exists('g:winresizestep')
   let g:winresizestep = 10
endif
function! ResizeWin(orient,op) range
   if a:lastline > a:firstline
     let g:winresizestep = a:lastline - a:firstline + 1
   endif
   exe ':'.a:orient.' resize '.a:op.g:winresizestep
endfunction
nmap <silent> \<Left> :call ResizeWin('vertical','-')<CR>
nmap <silent> \<Right> :call ResizeWin('vertical','+')<CR>
nmap <silent> \<Up> :call ResizeWin('','+')<CR>
nmap <silent> \<Down> :call ResizeWin('','-')<CR>

" re-source vimrc
com! Reinit :runtime! .vimrc

if !exists("g:center_view_on_jump")
   let g:center_view_on_jump = 1 " XXX: is enabled the best default?
endif
function! CondCenterView()
   if g:center_view_on_jump
      normal zz
   endif
endfunction
function! ToggleCenterViewOnJump()
   let g:center_view_on_jump = !g:center_view_on_jump
   if g:center_view_on_jump
      echo "Center view on jump is enabled."
   else
      echo "Center view on jump is disabled."
   endif
endfunction
com! ToggleCenterViewOnJump :call ToggleCenterViewOnJump()

nmap <silent> \; [{zz
nmap <silent> \' :call search('{')<CR>zz

" quickfix toggle
"
function! ToggleQuickfix()
  if exists("g:quickfix_bufnr")
    cclose
  else
    execute "copen"
  endif
endfunction
augroup TrackQuickfix
 autocmd!
 autocmd BufWinEnter quickfix let g:quickfix_bufnr = bufnr("$")
 autocmd BufWinLeave * if exists("g:quickfix_bufnr") && expand("<abuf>") == g:quickfix_bufnr | unlet! g:quickfix_bufnr | endif
augroup END


" some function key macros
"
" open/close error log and navigate log messages
"
nmap <silent> <S-F5> :call ToggleQuickfix()<CR>
nmap <silent> <Leader><F5> :call ToggleQuickfix()<CR>
nmap <silent> <F5>   :cclose<CR>:cw<CR><C-w>Jzz
nmap <silent> <S-F6> :cp<CR>:call CondCenterView()<CR>
nmap <silent> <F6>   :cn<CR>:call CondCenterView()<CR>
nmap <silent> <F7>   :cp<CR>:call CondCenterView()<CR>
map <silent> <F8>   :cnf<CR>:call CondCenterView()<CR>
map <silent> <F9>   :cpf<CR>:call CondCenterView()<CR>
" 
" typelist window
"
nmap <F10>  :TlistSync<CR>
nmap <F11>  :Tlist<CR>
"
" tag traversal -- forward, backward and list-matches
"
nmap \] <C-]>
nmap \[ <C-T>
nmap \# :ts<CR>
nmap \= :tn<CR>
nmap \- :tp<CR>
"
" holding shift when stepping in opens a new window
"
nmap <Bar>} <C-w><C-]>
"
" Launch viewtex on the current file (only makes sense in an
" environment which can show the resulting document graphically; e.g. 
" over an X11 connection or on windows).  Arguments given are
" persistent such that a subsequent launch without arguments will use
" those set previously.  Launching with only '--' resets the persisted
" arguments.
"
let g:viewtexargs = ''
function! ViewTeX(...)
   let a = join(a:000, ' ')
   if a == '--'
      let g:viewtexargs = ''
   elseif a != ''
      let g:viewtexargs = a
   endif
   call CexLive("viewtex --verbose ".g:viewtexargs." ".expand("%"))
endfunction
command! -nargs=* ViewTeX call ViewTeX(<f-args>)

nmap <F12> :ViewTeX<CR>

" virtual edit
function! ToggleVirtualEdit(option)
   if &ve =~ a:option
      exe ":set ve-=" . a:option
   else 
      exe ":set ve+=" . a:option
   endif
endfunction
nmap \v :call ToggleVirtualEdit('all')<CR>

function! ReexpandTab(from, to) range
   let oldet = &expandtab
   let oldts = &ts
   let &ts = a:from
   set noexpandtab
   exe ":".a:firstline.",".a:lastline." retab!"
   let &ts = a:to
   set expandtab
   exe ":".a:firstline.",".a:lastline." retab"
   let &ts = oldts
   let &expandtab = oldet
endfunction
command! -nargs=* -range=% ReexpandTab :<line1>,<line2> call ReexpandTab(<f-args>)

function! OpenNamedWindow(name)
   let winnum = bufwinnr(a:name)
   if winnum != -1
      " Jump to the existing window
      if winnr() != winnum
         exe winnum . 'wincmd w'
         return 0
      endif
   else
      " Create a new window.
      " If the named buffer already exists, then reuse it.
      " Otherwise create a new buffer
      let bufnum = bufnr(a:name)
      if bufnum == -1
         " Create a new buffer
         let wcmd = a:name
      else
         " Edit the existing buffer
         let wcmd = '+buffer' . bufnum
      endif

      " Create the named window vertically split
      exe 'silent! vs ' . wcmd
      return 1
   endif
endfunction

" Show the git commit-ish under the cursor in a git-show-output window
" set to filetype git-diff with all folds opened
"
" Use \s to show the commit and activate the window.
" Use shift-{\s} (i.e. |S or <Bar>S) to jump back to the source window.
"
" Use a count to open a distinct window to allow multiple views
" I.e. 2\s will use git-show-output-2
"      5\s will use git-show-output-5
"      \s, 0\s, 1\s will use git-show-output-1
"
command! -range -nargs=1 GitShow let winnum = winnr() | let commit = expand(<q-args>) | if OpenNamedWindow('git-show-output-'.(1 + <line2> - <line1>)) == 1 | set ft=git-diff | endif | silent! exe ':%!git log --patch-with-stat -C -n1 '.commit | set nomodified | exe ':normal zR' | nmap <silent> <buffer> <LT>Bar>S :exe winnum.'wincmd w'<CR>
nmap <silent> \s :GitShow <cword><CR>
nmap <silent> \h :GitShow HEAD<CR>
command! -range -nargs=* GitShowDiff let winnum = winnr() | if OpenNamedWindow('git-show-output-'.(1 + <line2> - <line1>)) == 1 | set ft=git-diff | endif | silent! exe ':%!git diff '.<q-args> | set nomodified | exe ':normal zR' | nmap <silent> <buffer> <LT>Bar>S :exe winnum.'wincmd w'<CR>
nmap <silent> <Bar>S :GitShowDiff -C --staged<CR>
nmap <silent> <Bar>H :GitShowDiff -C <CR>

" This contorted, but portable, perl pipe
" gives rapid feedback including any ansi
" color sequences but strips any such
" sequences from the resulting capture
" that ends up in the quickfix buffer.
if $OS !~ "Windows"
   let &shellpipe="2>&1| perl -e '$|=1; open OUT, \"> ${ARGV[0]}\"; use IO::Handle; OUT->autoflush(); STDOUT->autoflush(); while(!eof(STDIN)) { my $s; while(true) { $c=getc(); $s.=$c; last if ord($c) == 10; }; print $s; $s=~s/[^m]*m//g; print OUT $s; }; close OUT;' "
else
   for i in split(&rtp,',')
      let wintee = i.'/bin/wintee'
      if executable(wintee)
         let &shellpipe='2>&1| "'.wintee.'" '
         break
      endif
   endfor
endif

" This used to :cex tee'd through a system-specific pipe to show live
" output (hence the name).  Now it temporarily reassigns makeprg to
" the requested shell command, performs it with the perl filter above
" and resets it.
function! CexLive(cmdline)
   if $OS !~ "Windows"
      let l:makeprg="echo;echo Executing: ".a:cmdline."; ".a:cmdline
   else
      let l:makeprg=a:cmdline
   endif
   let l:makeprg=substitute(l:makeprg,'\\','\\\\','g')
   let l:makeprg=substitute(l:makeprg,'	','\\t','g')
   let l:makeprg=substitute(l:makeprg,'|','\\|','g')
   let l:oldmakeprg=&makeprg
   try
      let &makeprg=l:makeprg
      echo l:makeprg
      make
   catch
   endtry
   let &makeprg=l:oldmakeprg
endfun

com! -nargs=* -complete=file Shthis call CexLive("sh ".expand("%")." ".<q-args>)
com! -nargs=* -complete=file Bashthis call CexLive("bash ".expand("%")." ".<q-args>)
com! -nargs=* -complete=file Zshthis call CexLive("zsh ".expand("%")." ".<q-args>)
com! -nargs=* -complete=file Gxxthis call CexLive("g++ ".expand("%")." ".<q-args>)
com! -nargs=* -complete=file Exec call CexLive(<q-args>." ".expand("%"))
com! -nargs=* -complete=file NExec call CexLive(<q-args>)

com! CScopeReset cscope reset

" Cb kept for legacy reasons -- set nomodified is only required to be set when nohidden is set
com! -nargs=* Cb :cb
com! -nargs=* GrepParse let oef=&errorformat | let &errorformat='%f:%l:%m' | :cb | let &errorformat=oef

" allow modified buffers to be hidden
set hidden

" default tab of 3 and use spaces instead of literal tabs
set ts=3
set expandtab

" default backspace like normal
set bs=2

"""""""""""""""""""""""""""""""""""""""""""""""""

set ai            " auto-indent ALWAYS
set si            " smart-indent
set cin           " C-aware indent
set sw=3          " Indent width


set vb            " visible bell rather than beep

set linespace=1 "pixel


""""""""""""""""""""""""""""""""""""""""""""""""
" text and display wrapping

" display wrapping

set nowrap " off by default
set linebreak
set sidescroll=5
set sidescrolloff=1
set listchars+=precedes:�,extends:�
set encoding=utf-8
try
   set breakindent
   set breakindentshift=0
catch
endtry
scriptencoding latin1 " force single-byte guillemet 
set showbreak=\ �\ 
scriptencoding

" toggle wrapping modes (real and display)
" when display wrapping is on make cursor up/down move by
" display line rather than real line.

nmap <silent> <F2> :call ToggleDisplayWrap()<CR>
imap <silent> <F2> <C-O><F2><C-O>:sleep 300m<CR>
function! ToggleDisplayWrap()
  if &wrap
    echo "Display Wrap OFF"
    setlocal nowrap
    setlocal display-=lastline
    silent! nunmap <buffer> <Up>
    silent! nunmap <buffer> <Down>
    silent! nunmap <buffer> <Home>
    silent! nunmap <buffer> <End>
    silent! iunmap <buffer> <Up>
    silent! iunmap <buffer> <Down>
    silent! iunmap <buffer> <Home>
    silent! iunmap <buffer> <End>
  else
    echo "Display Wrap ON"
    setlocal wrap linebreak nolist
    setlocal display+=lastline
    noremap  <buffer> <silent> <Up>   gk
    noremap  <buffer> <silent> <Down> gj
    noremap  <buffer> <silent> <Home> g<Home>
    noremap  <buffer> <silent> <End>  g<End>
    inoremap <buffer> <silent> <Up>   <C-o>gk
    inoremap <buffer> <silent> <Down> <C-o>gj
    inoremap <buffer> <silent> <Home> <C-o>g<Home>
    inoremap <buffer> <silent> <End>  <C-o>g<End>
  endif
endfunction

" text wrapping - on by default

let g:default_textwidth = 70
let &textwidth = g:default_textwidth

nmap <silent> <F3> :call ToggleTextWrap()<CR>
imap <silent> <F3> <C-O><F3><C-O>:sleep 300m<CR>
function! ToggleTextWrap()
  if &textwidth == 0
    echo "Text Wrap ON"
    try
       let &l:textwidth = b:lasttextwidth
    catch
       let &l:textwidth = g:default_textwidth
    endtry
  else
    echo "Text Wrap OFF"
    let b:lasttextwidth=&textwidth
    setlocal textwidth=0
  endif
endfunction

""""""""""""""""""""""""""""""""""""""""""""""""

" don't save backups
set nobackup

" do highlighting of search pattern and enable incremental search
set hlsearch
set incsearch

" set cursor indications in gui mode
set guicursor=n-v-c:block-lCursor/Cursor,ve:ver35-Cursor,o:block-Cursor,i-ci:block-wCursor/Cursor-blinkwait60-blinkoff60-blinkon60,r-cr:block-oCursor/Cursor-blinkwait60-blinkoff60-blinkon60,sm:block-lCursor/Cursor-blinkwait175-blinkoff150-blinkon175

" show the position of the cursor
set ruler

" show matching parenthesise.
set showmatch

" Ignore superfluous character sequences in error lists to allow correct
" parsing of errors for the quick-fix window.  Superfluous character
" sequences include:
"   *  ansi color escape sequences
"   *  "[pid] " prefixes (including ones colored by ansi sequences)
" This accepts n color escape sequences before and after file, line and
" column refs as well as around directory names.
"
" This makes for huge processor-intensive match patterns; it would be
" nicer if vim provided another variable, say errorfilter, for
" preprocessing each line of error prior to matching with errorformat.
"
if !exists("g:set_error_format")
   let g:set_error_format = 1
   let &errorformat
     \ = '%*[^"]"%f"%*\D%l: %m'
     \ . ',%f"%*\D%l: %m'
     \ . ',%+G%m %f:%l:%c:'
     \ . ',%+G%m %f:%l:%c\,'
     \ . ',%+G%m %f:%l:'
     \ . ',%+G%m %f:%l\,'
     \ . ',%-G%f:%l: (Each undeclared identifier is reported only once'
     \ . ',%-G%f:%l: for each function it appears in.)'
     \ . ',%f:%l:%c:%m'
     \ . ',%f(%l):%m'
     \ . ',%[ ]%#%f(%l) :%m'
     \ . ',%f:%l:%m'
     \ . ',"%f"\, line %l'
     \ . ',%D%*\a: Entering directory %.%f%.'
     \ . ',%X%*\a: Leaving directory %.%f%.'
     \ . ',%D%*\a[%*\d]: Entering directory %.%f%.'
     \ . ',%X%*\a[%*\d]: Leaving directory %.%f%.'
     \ . ',%DMaking %*\a in %f'
     \ . ',%f|%l| %m'
   let &errorformat = substitute( &errorformat, '\(^\|,\(%\([DX]\|[-+]G\)\)\?\)', '\1%\\%%([ %#%*\\d]%\\)%\\? %#', 'g' )
   let &errorformat = substitute( &errorformat, '%[.flc]',   '%\\%%([%.%\\{-}m%\\)%#&%\\%%([%.%\\{-}m%\\)%#', 'g' )
   let &errorformat = substitute( &errorformat, '%\*\\[ad]', '%\\%%([%.%\\{-}m%\\)%#&%\\%%([%.%\\{-}m%\\)%#', 'g' )
endif

""""""""""""""""""""""""""""""""""""""""""""""""

" function to set highlighting options to look better on terminals
function! SetTerminalHighlighting()

   " disable underline on windows console
   let l:underline  = "underline"
   let l:cunderline = ",underline"
   if &term == 'win32'
      let l:underline = ""
      let l:cunderline = ""
   else

   " remove solid background from html highlighting
   let html_my_rendering = 1 
   exe ''
   \.'  hi htmlBold                term=bold cterm=bold gui=bold'                                                 
   \.'| hi htmlBoldUnderline       term=bold'.l:cunderline.' cterm=bold'.l:cunderline.' gui=bold'.l:cunderline    
   \.'| hi htmlBoldItalic          term=bold cterm=bold gui=bold'                                                 
   \.'| hi htmlBoldUnderlineItalic term=bold'.l:cunderline.' cterm=bold'.l:cunderline.' gui=bold'.l:cunderline    
   \.'| hi htmlUnderline           term='.l:underline.' cterm='.l:underline.' gui='.l:underline                   
   \.'| hi htmlUnderlineItalic     term='.l:underline.' cterm='.l:underline.' gui='.l:underline                   
   \.'| hi htmlItalic              term=bold cterm=bold gui=bold'                                                 

   endif

   " replace solid background of spell/grammar errors in cterm with bright underline
   exe ''
   \.'  hi SpellBad   term=bold cterm=bold'.l:cunderline.' ctermbg=none ctermfg=1 gui=undercurl guisp=Red'
   \.'| hi SpellCap   term=bold cterm=bold'.l:cunderline.' ctermbg=none ctermfg=4 gui=undercurl guisp=Blue'
   \.'| hi SpellLocal term=bold cterm=bold'.l:cunderline.' ctermbg=none ctermfg=6 gui=undercurl guisp=Cyan'
   \.'| hi SpellRare  term=bold cterm=bold'.l:cunderline.' ctermbg=none ctermfg=5 gui=undercurl guisp=Magenta'

   if exists(':Hreload')
      Hreload
   endif

endfunction 

" convenience for reloading cursor colors if changing color-scheme
" (now called from change event autocmd)
function! ResetCursor()

   hi clear CursorLine
   hi clear CursorColumn
   
   hi CursorLine   guibg=lightgray
   hi CursorColumn guibg=lightgray
   
   "hi Cursor		  guifg=bg	guibg=#305080
   hi wCursor		  guifg=bg	guibg=#FF1020
   hi oCursor		  guifg=bg	guibg=#CC20FF

endfunction

""""""""""""""""""""""""""""""""""""""""""""""""

if has("autocmd")

   " disable spell under some conditions
   autocmd FileType diff setlocal nospell comments=n:###,n:##,n:#,n:FIXME:,n:TODO:,n:XXX:,n:FIXME,n:TODO
   autocmd FileType git-diff setlocal nospell
   autocmd FileType patch setlocal nospell
   autocmd FileType qf setlocal nospell
   autocmd FileType messages setlocal nospell

   autocmd ColorScheme * call SetTerminalHighlighting() | call ResetCursor()

   " Set some sensible defaults for editing C-files
   augroup clikeprog
     " Remove all cprog autocommands
     au!
   
     " When starting to edit a file:
     "   For *.c and *.h files set formatting of comments and set C-indenting on.
     "   For other files switch it off.
     "   Don't change the order, it's important that the line with * comes first.
     autocmd BufNewFile,BufRead *       set formatoptions=tcql nocindent noautoindent comments&
     autocmd BufNewFile,BufRead *.gpp set filetype=cppcc cindent comments=sr:/*,mbl:*/,ex:*/,://
     autocmd BufNewFile,BufRead *.impl set filetype=cpp
     autocmd BufNewFile,BufRead *.c,*.h,*.cpp,*.cxx,*.cc,*.inl,*.impl,*.hpp,*.java set formatoptions=croql cindent comments=sr:/*,mb:\ *,ex:\ */,:///://,n:///,n://,n:FIXME:,n:TODO:,n:XXX:,n:FIXME,n:TODO,n:XXX,fb:-
     autocmd BufNewFile,BufRead *.s,*.asm,*.s11,*.i set filetype=asm tabstop=14 formatoptions=croql cindent comments=";"
     autocmd BufNewFile,BufRead *.fp,*.cg,*.vp set filetype=cg cindent comments=sr:/*,mbl:*/,ex:*/,://
     autocmd BufNewFile,BufRead mib2c.*.conf set filetype=mib2c
   augroup END

   autocmd BufNewFile,BufRead *.git-diff set ft=git-diff
   autocmd BufNewFile,BufRead *.diff set ft=diff

   " Also, support editing of gzip-compressed files. DO NOT REMOVE THIS!
   " This is also used when loading the compressed helpfiles.
   augroup gzip
     " Remove all gzip autocommands
     au!

     " Enable editing of gzipped files
     "     read:  set binary mode before reading the file
     "      uncompress text in buffer after reading
     "    write:  compress file after writing
     "   append:  uncompress file, append, compress file
     autocmd BufReadPre,FileReadPre *.gz set bin
     autocmd BufReadPre,FileReadPre *.gz let ch_save = &ch|set ch=2
     autocmd BufReadPost,FileReadPost  *.gz '[,']!gunzip
     autocmd BufReadPost,FileReadPost  *.gz set nobin
     autocmd BufReadPost,FileReadPost  *.gz let &ch = ch_save|unlet ch_save
     autocmd BufReadPost,FileReadPost  *.gz execute ":doautocmd BufReadPost %:r"
   
     autocmd BufWritePost,FileWritePost   *.gz !mv <afile> <afile>:r
     autocmd BufWritePost,FileWritePost   *.gz !gzip <afile>:r
   
     autocmd FileAppendPre       *.gz !gunzip <afile>
     autocmd FileAppendPre       *.gz !mv <afile>:r <afile>
     autocmd FileAppendPost      *.gz !mv <afile> <afile>:r
     autocmd FileAppendPost      *.gz !gzip <afile>:r
   augroup END

   augroup bzip2
     " Remove all bzip2 autocommands
     au!
   
     " Enable editing of bzipped files
     "       read: set binary mode before reading the file
     "             uncompress text in buffer after reading
     "      write: compress file after writing
     "     append: uncompress file, append, compress file
     autocmd BufReadPre,FileReadPre        *.bz2 set bin
     autocmd BufReadPre,FileReadPre        *.bz2 let ch_save = &ch|set ch=2
     autocmd BufReadPost,FileReadPost      *.bz2 set cmdheight=2|'[,']!bunzip2
     autocmd BufReadPost,FileReadPost      *.bz2 set cmdheight=1 nobin|execute ":doautocmd BufReadPost %:r"
     autocmd BufReadPost,FileReadPost      *.bz2 let &ch = ch_save|unlet ch_save
   
     autocmd BufWritePost,FileWritePost    *.bz2 !mv <afile> <afile>:r
     autocmd BufWritePost,FileWritePost    *.bz2 !bzip2 <afile>:r
   
     autocmd FileAppendPre                 *.bz2 !bunzip2 <afile>
     autocmd FileAppendPre                 *.bz2 !mv <afile>:r <afile>
     autocmd FileAppendPost                *.bz2 !mv <afile> <afile>:r
     autocmd FileAppendPost                *.bz2 !bzip2 -9 --repetitive-best <afile>:r
   augroup END

endif " has ("autocmd")


if $_ == "" || $_ =~ "gvim"
" show the gui now, if possible (i.e. if running a gui capable vim).
" some things below depend on overriding defaults provided by default
" when opening the gui window.
try
:gui
catch
endtry
endif

" vimwiki stuff
let g:vimwiki_home = $HOME . "/.vimwiki/"

if &term =~ 'rxvt'
   set t_Co=256
endif

" syntax highlighting on
syntax on

" always look at least 50 lines back
syntax sync minlines=50

" always use normal slashes for directory separators (rather than backslashes on Windows)
set shellslash

" best guess at user name
let g:user = $USERNAME | if g:user == '' | let g:user = $USER | endif

" preferred color scheme
let g:preferred_bg='dark' | if &term =~ 'gui' | let g:preferred_bg='light' | endif
let g:preferred_scheme='moria'
let g:fallback_bg='light'
let g:fallback_scheme='default'

let g:fullcolorterm = &term =~ 'gui' || ( &t_Co == '256' && &term != 'linux' )

runtime prefs

" set colorscheme based on user name and terminal type
"
if g:user == 'root'

   colorscheme darkblue
   set bg=dark

elseif g:fullcolorterm

   runtime plugin/guicolorscheme.vim
   let &bg=g:preferred_bg
   exec "GuiColorScheme ".g:preferred_scheme

else

   exec "colorscheme ".g:fallback_scheme
   let &bg=g:fallback_bg

endif


function! GNUStyle()
   set cinoptions=>4,n-2,{2,^-2,:2,=2,g0,h2,p5,t0,+2,(0,u0,w1,m1
   set shiftwidth=2
   set tabstop=8
   set noexpandtab
   set comments=s:/*,m:\ \ \ ,re:*/,:///://,n:///,n://,n:FIXME:,n:TODO:,n:XXX:,n:FIXME,n:TODO,n:XXX,fb:-
endfunction
command! GNUStyle call GNUStyle()


function! LogView()
   if g:fullcolorterm
      runtime plugin/guicolorscheme.vim
      let &bg=g:preferred_bg
      exec "GuiColorScheme ".g:preferred_scheme
   else
      exec "colorscheme ".g:fallback_scheme
      let &bg=g:fallback_bg
   endif
   set ft=asm
   set ts=10
   set nospell
   normal \m
endfunction
command! LogView call LogView()


" lighten up control characters
hi SpecialKey guifg=gray


" allow overriding without changing this, possibly, version controlled
" file; this file should be placed in ~/.vim/ on unix or personal or
" system-wide vimfiles on windows.
runtime vimrc-overrides

