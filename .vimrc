let g:windows = $OS =~ "Windows"
let g:cygwin = g:windows && expand('~') =~ "^/"
if g:windows && !g:cygwin
   let g:msys = match(system('sh --version'), 'msys')
   if g:msys
      set shell=sh
   endif
endif

if $PROFILE_VIM_STARTUP == 1
   profile start vim-startup-profile.log
   profile func *
   profile file *
endif

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"                        Vundle                          "
set nocompatible              " be iMproved, required
filetype off                  " required

" set the runtime path to include Vundle and initialize
let g:bundle_dir = fnamemodify(resolve(expand('<sfile>')), ':h') . "/bundle"
exe "set rtp+=".escape(g:bundle_dir."/Vundle.vim", " \|,")
call vundle#begin(g:bundle_dir)

" let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'

" allow overriding plugins without changing this, possibly, version controlled
" file; this file should be placed in ~/.vim/ on unix or personal or
" system-wide vimfiles on windows.
runtime vimrc-vundle-plugins
" alternatively, place a dot-prefixed version in HOME.
if filereadable(expand("~/.vimrc-vundle-plugins")) | source ~/.vimrc-vundle-plugins | endif

" the above script may set g:no_default_plugins to completely
" override the plugin set.
if !exists('g:no_default_plugins') || !g:no_default_plugins
Plugin 'Valloric/YouCompleteMe'
Plugin 'terryma/vim-multiple-cursors'
Plugin 'ctrlpvim/ctrlp.vim'
Plugin 'abutcher-gh/vim-clang-format'
Plugin 'AndrewRadev/linediff.vim'
Plugin 'NLKNguyen/papercolor-theme'
Plugin 'jacoborus/tender.vim'
Plugin 'jonathanfilip/vim-lucius'
Plugin 'digitaltoad/vim-jade'
Plugin 'powerman/vim-plugin-ansiesc'
Plugin 'tpope/vim-fugitive'
Plugin 'mhinz/vim-signify'
Plugin 'wavded/vim-stylus'
Plugin 'mbbill/undotree'
Plugin 'skywind3000/asyncrun.vim'
Plugin 'pangloss/vim-javascript'
Plugin 'editorconfig/editorconfig-vim'
Plugin 'maxmellon/vim-jsx-pretty'
Plugin 'embear/vim-localvimrc'
Plugin 'lanza/vim-cmake-completion'
Plugin 'leafgarland/typescript-vim'
Bundle 'wellle/context.vim'
endif

if filereadable(expand("~/.vimrc-extra-vundle-plugins")) | source ~/.vimrc-extra-vundle-plugins | endif

" All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required

"                        Vundle                          "
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Local vimrc (.lvimrc) file loading:
" 0: Don't store and restore any decisions.
" 1: Store and restore decisions only if the answer was given in upper case (Y/N/A).
" 2: Store and restore all decisions.
let g:localvimrc_persistent = 1

let g:EditorConfig_exclude_patterns = ['fugitive://.*', 'scp://.*']

let $GCCFILT_NO_COLOR = 1
if g:cygwin
   let $GCCFILT_CYGWINIZE = 1
endif

let g:context_skip_regex = '^\s*\($\|#\|//\|/\*\|\*\($\|/s\|\/\)\|\(public\|private\|protected\):\)'

let g:undotree_DiffCommand = "diff"

let g:ycm_key_invoke_completion = '<C-@>'
let g:ycm_global_ycm_extra_conf = '~/.vim/ycm_extra_conf.py'
let g:ycm_always_populate_location_list = 1
let g:ycm_complete_in_comments = 1
" let g:ycm_warning_symbol = '⚠'
" let g:ycm_error_symbol = '‼‼'

" Let clangd fully control code completion
let g:ycm_clangd_uses_ycmd_caching = 0
" Use installed clangd, not YCM-bundled clangd which doesn't get updates.
" let g:ycm_clangd_binary_path = exepath("clangd")
let g:ycm_auto_hover = ''
let g:ycm_clangd_args=['--header-insertion=never', '--background-index']

nmap \q :YcmCompleter FixIt<C-M>
nmap \? :YcmShowDetailedDiagnostic<C-M>
nmap zq :YcmCompleter FixIt<C-M>
nmap z? :YcmShowDetailedDiagnostic<C-M>

" Use preferred rust-analyzer.
let s:rust_toolchain_dirs = [
   \ $HOME . '/.rustup/toolchains/nightly-x86_64-unknown-linux-gnu/',
   \ '/usr/lib/rustup/',
   \ g:bundle_dir . '/YouCompleteMe/third_party/ycmd/third_party/rust-analyzer/',
   \ ]
for g:ycm_rust_toolchain_root in s:rust_toolchain_dirs
   if executable(g:ycm_rust_toolchain_root . 'rust-analyzer') ||
    \ executable(g:ycm_rust_toolchain_root . 'bin/rust-analyzer')
      break
   endif
endfor
unlet s:rust_toolchain_dirs

" Allow for ESC to switch mode with multiple cursors active.
" Use backtick to exit multi-cursor mode quickly without ESC wait.
let g:multi_cursor_quit_key = '`'

" let s:ctrlp_fallback = 'find %s -type f'
let s:ctrlp_fallback = 'echo "Not a VCS directory"'
let g:ctrlp_user_command = {
   \ 'types': {
      \ 1: ['.git', 'git -C %s ls-files'],
      \ 2: ['.hg', 'hg --cwd %s locate -I .'],
      \ },
   \ 'fallback': s:ctrlp_fallback
   \ }
" let g:ctrlp_by_filename = 1

" List submodule files in CTRL-P and GitGrep output (or not).
command! ToggleSubmodules :call ToggleSubmodules()
nmap <silent> \` :ToggleSubmodules<CR>
nmap <silent> z` :ToggleSubmodules<CR>
function! ToggleSubmodules()
    " GitGrep
    if g:git_grep_submodule_opt == ''
        let g:git_grep_submodule_opt = ' --recurse-submodules'
    else
        let g:git_grep_submodule_opt = ''
    endif

    " CTRL-P command
    let l:cmd = g:ctrlp_user_command['types'][1][1]
    if l:cmd =~ 'submodules'
        let l:cmd = substitute(l:cmd, ' --recurse-submodules', '', '')
        echo 'Submodules will NOT be included in CtrlP or GitGrep search.'
    else
        let l:cmd = l:cmd . ' --recurse-submodules'
        echo 'Submodules will be included in CtrlP or GitGrep search.'
    endif
    let g:ctrlp_user_command['types'][1][1] = l:cmd
    CtrlPClearCache
endfun

hi link YcmWarningSign Delimiter
hi link YcmErrorSign WarningMsg

let g:clang_format#style_options = {
            \ "BasedOnStyle" : "WebKit",
            \ "Standard" : "C++11",
            \ "IndentWidth" : 3,
            \ "ColumnLimit" : 90,
            \ "TabWidth" : 3,
            \ "ContinuationIndentWidth" : 3,
            \ "ConstructorInitializerIndentWidth" : 1,
            \ "UseTab" : "Never",
            \ "AccessModifierOffset" : -3,
            \ "AlignAfterOpenBracket" : "true",
            \ "AlwaysBreakTemplateDeclarations" : "true",
            \ "AllowShortCaseLabelsOnASingleLine" : "true",
            \ "AllowShortFunctionsOnASingleLine" : "Inline",
            \ "AllowShortIfStatementsOnASingleLine" : "false",
            \ "AllowShortLoopsOnASingleLine" : "false",
            \ "BreakBeforeBraces" : "Allman",
            \ "BreakConstructorInitializersBeforeComma" : "true",
            \ "ExperimentalAutoDetectBinPacking" : "true",
            \ "DerivePointerAlignment" : "false",
            \ "PointerAlignment" : "Left",
            \ "MaxEmptyLinesToKeep" : 1,
            \ "NamespaceIndentation" : "None",
            \ "SpaceAfterCStyleCast" : "true",
            \ "SpaceBeforeParens" : "false",
            \ "SpacesInCStyleCastParentheses" : "false",
            \ "SpacesInParentheses" : "true",
            \ "SpacesInSquareBrackets" : "false",
            \ "SpaceInEmptyParentheses" : "false",
            \ }

let g:clang_format#auto_format_on_insert_leave = 0
nmap <Bar>X :call clang_format#toggle_format_on_insert()<CR>

autocmd FileType c,cpp,objc nnoremap <buffer><Leader>x :<C-u>.ClangFormat<CR>
autocmd FileType c,cpp,objc vnoremap <buffer><Leader>x :ClangFormat<CR>
autocmd FileType c,cpp,objc nnoremap <buffer>zx :<C-u>.ClangFormat<CR>
autocmd FileType c,cpp,objc vnoremap <buffer>zx :ClangFormat<CR>

let g:initial = " "
let g:lead = " "

let g:intellisense_vimfiles = $VIM . '/vimfiles'

set sessionoptions=blank,buffers,curdir,folds,help,options,tabpages,winsize,winpos,resize

" attributes used by the file-to-html converter
"
let use_xhtml=1
let html_use_css=1
let html_js=1
let html_number_lines=1

let c_c_vim_compatible = 1
let c_C99 = 1


" Latest vim swap file default location has moved from local directory
" of the file being edited to the ~/.vim/swap directory.  If sharing a
" vim config on a multi-user system, this is not generally writeable.
" Add the original default back in (but still use ~/.vim/swap if
" possible).
set directory+=.


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
if g:windows
   let s:printfont="DejaVu_Sans_Mono"
else
   let s:printfont=""
endif
let s:printfontsize=7
function! PrintFont(...)
   let l:n = len(a:000)
   if l:n == 1 && a:1 =~ '[0-9]\+'
      let s:printfontsize=a:1
   elseif l:n == 1
      let s:printfont=a:1
   elseif l:n >= 2
      let s:printfont=a:1
      let s:printfontsize=a:2
   endif
   let &printfont = s:printfont . ':h' . s:printfontsize
endfunc
command! -nargs=* PrintFont :call PrintFont(<f-args>)
command! CodePrintLandscape set printoptions=paper:A4,number:y,left:5mm,right:5mm,top:12mm,bottom:12mm,portrait:n
command! CodePrintPortrait  set printoptions=paper:A4,number:y,left:5mm,right:5mm,top:12mm,bottom:12mm,portrait:y
command! TextPrintLandscape set printoptions=paper:A4,number:n,left:5mm,right:5mm,top:12mm,bottom:12mm,portrait:n
command! TextPrintPortrait  set printoptions=paper:A4,number:n,left:5mm,right:5mm,top:12mm,bottom:12mm,portrait:y
command! TextPrintLandscapeA5 set printoptions=paper:A5,number:n,left:5mm,right:5mm,top:12mm,bottom:12mm,portrait:n
PrintFont

function! Repath()
 
   let &path = ""

   " stick the C++ include path into Vim's file navigation search path
   if g:windows
      if $USE_GCC == "1"
         let &path = ".," . substitute($CPATH.';'.$CPLUS_INCLUDE_PATH, ';', ',', 'g') . &path
      else
         let &path = ".," . substitute($INCLUDE, ';', ',', 'g') . &path
      endif
      if g:cygwin
         let &path = substitute(&path,'\(.\):/','/\1/','g')
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

      if g:windows
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
if g:windows
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
   set lines=64 columns=250
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

nmap zg :diffget<CR>
nmap zp :diffput<CR>
nmap zn ]c
nmap ZN [c
nmap Zz :diffupdate<CR>

" quick toggle of ANSI escape parsing
nmap @A :AnsiEsc<C-M>

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
if g:cygwin
   let &tags=substitute(&tags, '\(.\):', '/\1', 'g')
endif

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

function! PushCurrentLocation()
   let l:item = expand("%")
   if l:item == ""
      let l:item = '!:!' . winbufnr(0)
   endif
   call insert( g:file_nav_stack, [l:item, getpos('.')] )
endfunction

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
         try
            call PushCurrentLocation()
            call ProbeCscopeAndTags()
            cscope find f <cfile>
         catch
            " silent pop
            call remove( g:file_nav_stack, 0, 0 )
            echo "File '" . l:arg . "' not found in search path."
         endtry
      else
         echo "File '" . l:fullpath . "' not readable."
      endif
      return
   endif
   call PushCurrentLocation()
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
      if JumpToNav(0) < 2
         call remove( g:file_nav_stack, 0, 0 )
      endif
   endtry
endfunction

function! GetNavLocation(index)
   if empty(g:file_nav_stack)
      return ''
   endif
   let [l:file, l:pos] = get( g:file_nav_stack, a:index )
   return l:file . ':' . join(l:pos[1:-2],':')
endfunction

function! JumpToNav(index) range
   if empty(g:file_nav_stack)
      echo "No file navigation stack."
      return 2
   endif

   let [l:file, l:pos] = get( g:file_nav_stack, a:index )

   if !filereadable( l:file )
      if match( l:file, '!:!' ) == 0
         let l:file = l:file[3:]
      else
         echo "File '" . l:file . "' not readable, skipped."
         return 1
      endif
   endif
   " try existing buffer first
   try
      exe "b ".l:file
   catch
      e `=l:file`
   endtry
   " reposition cursor
   call setpos( '.', l:pos )
   echo 'Returned to '.l:file.':'.join(l:pos[1:-2],':')
endfunction

function! DumpNavList()
   if empty(g:file_nav_stack)
      echo "No file navigation stack."
      return 2
   endif
   for [l:file, l:pos] in g:file_nav_stack
      echo l:file . ':' . join(l:pos[1:-2],':')
   endfor
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

   " if not suffixed with '!' then stop at first matching extension
   let stop_at_first_match = a:CmdLine !~ '^\S\+!'

   let realext=expand("%:e")

   let pwd=getcwd()

   for [pattern, pathlist, extlist] in g:EATypeList
      
      if realext =~ '^'.pattern.'$'
         for path in pathlist
            for ext in extlist

               let full=expand("%:p:r:".path)
               let name=expand(full.".".ext)

               let rc .= GetRelativePath(pwd,name) . "\n"

            endfor
         endfor
      endif

      if stop_at_first_match && !empty(rc)
         return rc
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
nmap <silent> <A-z> :call EditParent()<CR>
nmap <silent> <A-.> :call PushInclude(0)<CR>
nmap <silent> <A-<Bar>> :call PushInclude(1)<CR>
nmap <silent> <A-Z> :call PushInclude(1)<CR>
nmap <silent> <A-,> :call PopInclude()<CR>
nmap <silent> <A-/> :call EditAssociate()<CR>

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
nmap <silent> \<CR> :call PushCurrentLocation()<CR>:echo 'Pushed '.GetNavLocation(0).':').' ('.len(g:file_nav_stack).' on stack).'<CR>
nmap <silent> \, :call PopInclude()<CR>
nmap <silent> \/ :call EditAssociate()<CR>
nmap <silent> \<Space> :call JumpToNav(0)<CR>
nmap \<Tab> :EditAssociate<Space>
nmap <Bar><Tab> :EditAssociate!<Space>

" Same again but using z instead of \ for US keyboards.  Note: first uses ZZ and not zz since the latter is already a useful sequence.
nmap <silent> ZZ :call EditParent()<CR>
nmap <silent> z. :call PushInclude(0)<CR>
nmap <silent> z> :call PushInclude(1)<CR>
nmap <silent> z<CR> :call PushCurrentLocation()<CR>:echo 'Pushed '.GetNavLocation(0).':').' ('.len(g:file_nav_stack).' on stack).'<CR>
nmap <silent> z, :call PopInclude()<CR>
nmap <silent> z/ :call EditAssociate()<CR>
nmap <silent> z<Space> :call JumpToNav(0)<CR>
nmap z<Tab> :EditAssociate<Space>
nmap Z<Tab> :EditAssociate!<Space>
nmap <silent> Z? <plug>(YCMHover)

" focus previously focused window
nmap <silent> <Tab> 
nmap <silent> <C-Tab> 
nmap <silent> <S-Tab> 

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

" Same again but using z instead of \ for US keyboards.
nmap <silent> z<Left> :call ResizeWin('vertical','-')<CR>
nmap <silent> z<Right> :call ResizeWin('vertical','+')<CR>
nmap <silent> z<Up> :call ResizeWin('','+')<CR>
nmap <silent> z<Down> :call ResizeWin('','-')<CR>

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
nmap <silent> z; [{zz
nmap <silent> z' :call search('{')<CR>zz

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
nmap <silent> \<F5> :call ToggleQuickfix()<CR>
nmap <silent> z<F5> :call ToggleQuickfix()<CR>
nmap <silent> <F5>   :cclose<CR>:cw<CR><C-w>Jzz
nmap <silent> <F6>   :cn<CR>:call CondCenterView()<CR>
nmap <silent> <F7>   :cp<CR>:call CondCenterView()<CR>
map <silent> <F8>   :cnf<CR>:call CondCenterView()<CR>
map <silent> <F9>   :cpf<CR>:call CondCenterView()<CR>
"
" navigate location list (without showing it); useful for ycm annotations
"
nmap <silent> <Leader><F6> :lnext<CR>
nmap <silent> <Leader><F7> :lprevious<CR>
nmap <silent> z<F6> :lnext<CR>
nmap <silent> z<F7> :lprevious<CR>
"
" quickfix history nav
"
nmap <silent> q<Left> :colder<CR>
nmap <silent> q<Right> :cnewer<CR>
nmap <silent> qe :cclose<CR>:cw<CR>:set modifiable<CR>:vg/\c\(entering\\|leaving\\|error\)/d<CR>:%s/^\|\| /<CR>:set nomodified<CR>:cb<CR>
"
" typelist window
"
nmap <F10>  :TlistSync<CR>
nmap <F11>  :Tlist<CR>
"
" tag traversal -- forward, backward and list-matches
" holding shift when stepping in opens a new window
"
nmap <silent> \] :call TagJump(expand('<cword>'))<CR>
nmap <silent> <Bar>} :call TagJump(expand('<cword>'), 'split')<CR>
nmap \[ <C-T>
nmap \# :ts<CR>
nmap \= :tn<CR>
nmap \- :tp<CR>

nmap <silent> z] :call TagJump(expand('<cword>'))<CR>
nmap <silent> Z} :call TagJump(expand('<cword>'), 'split')<CR>
nmap z[ <C-T>
nmap z# :ts<CR>
nmap z= :tn<CR>
nmap z- :tp<CR>
"
" Push current taglist into quickfix window.
"
nmap <silent> \l :call TagJump('')<CR>
nmap <silent> zl :call TagJump('')<CR>
"
" Traverse into tag and open multiple matches in quickfix window
"
function! TagJump(tag, ...)
   let split = a:0
   if split
      split
   endif
   try
   exec 'ltag '.a:tag
   catch
   endtry
   let c = len(getloclist(0))
   if c <= 1 && split
      q
   endif
   if c > 1
      call setqflist(getloclist(0))
      call OpenQuickfix()
      cfirst
   elseif split
      exec 'tag '.a:tag
   endif
endfunction
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
   call CexLive('', "viewtex --verbose ".g:viewtexargs." %")
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
nmap zv :call ToggleVirtualEdit('all')<CR>

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
nmap <silent> zs :GitShow <cword><CR>
nmap <silent> zh :GitShow HEAD<CR>
command! -range -nargs=* GitShowDiff let winnum = winnr() | if OpenNamedWindow('git-show-output-'.(1 + <line2> - <line1>)) == 1 | set ft=git-diff | endif | silent! exe ':%!git diff '.<q-args> | set nomodified | exe ':normal zR' | nmap <silent> <buffer> <LT>Bar>S :exe winnum.'wincmd w'<CR>
nmap <silent> <Bar>S :GitShowDiff -C --staged<CR>
nmap <silent> <Bar>H :GitShowDiff -C <CR>
nmap <silent> ZS :GitShowDiff -C --staged<CR>
nmap <silent> ZH :GitShowDiff -C <CR>
command! -bang -range -nargs=* GitGrep :call GitGrep('<bang>', <f-args>)
vmap <silent> <Bar>G :call GitGrep('p', GetVisual())<CR>
vmap <silent> <Bar>G :call GitGrep('p', GetVisual())<CR>
nmap <silent> ZG :call GitGrep('p', '\<'.expand('<cword>').'\>')<CR>
nmap <silent> ZG :call GitGrep('p', '\<'.expand('<cword>').'\>')<CR>

let g:git_grep_submodule_opt = ''
function! GitGrep(modifier, ...)
   let l:args = a:000
   if a:modifier == 'p'
      call PushCurrentLocation()
   endif
   if a:modifier != '!'
      let l:args = []
      if exists('+shellslash')
         let l:shellslash = &shellslash
         let &shellslash = 0
      endif
      for l:arg in a:000
         call add(l:args, shellescape(l:arg))
      endfor
      if exists('+shellslash')
         let &shellslash = l:shellslash
      endif
   endif
   let l:oef=&errorformat | let &errorformat='%f:%l:%m'
   call CexLiveNoExpand('', 'git grep --no-color -n '.g:git_grep_submodule_opt.' '.join(l:args))
   let &errorformat=l:oef
endfun

function! GetVisual()
   let reg_save = getreg('"')
   let regtype_save = getregtype('"')
   let cb_save = &clipboard
   set clipboard&
   normal! ""gvy
   let selection = getreg('"')
   call setreg('"', reg_save, regtype_save)
   let &clipboard = cb_save
   return selection
endfun

let g:asyncrun_bell = 1

function! CexLive(bang, cmdline)
   call CexLiveNoExpand(a:bang, expand(a:cmdline))
endfun

function! CexLiveNoExpand(bang, cmdline)
   let l:w = winnr()
   execute 'AsyncRun'.a:bang.' '.a:cmdline
   execute 'copen'
   silent exec ''.l:w.'wincmd w'
endfun

com! -bang -nargs=* -complete=file Shthis call CexLive('<bang>', 'sh % '.<q-args>)
com! -bang -nargs=* -complete=file Bashthis call CexLive('<bang>','bash % '.<q-args>)
com! -bang -nargs=* -complete=file Zshthis call CexLive('<bang>','zsh % '.<q-args>)
com! -bang -nargs=* -complete=file Gxxthis call CexLive('<bang>','g++ % '.<q-args>)
com! -bang -nargs=* -complete=file Exec call CexLive('<bang>',<q-args>.' %'))
com! -bang -nargs=* -complete=file NExec call CexLive('<bang>',<q-args>)

" cscope settings
com! CScopeReset cscope reset
set cscopequickfix=s-,g-,c-,d-,i-,t-,e-
" cscope mappings:
"  \d find declaration
"  \c find callers
"  \i find includers
"  \e find via egrep
"  \u find usage of the symbol
"  \r same as \u -- find any reference to the symbol
"  |R reset cscope
nmap <silent> \d :call ProbeCscopeAndTags(expand("%:h"))<CR>:call PushCurrentLocation()<CR>:cs find g <C-R>=expand("<cword>")<CR><CR>:normal zz<CR>:call OpenQuickfix()<CR>:cfirst<CR>
nmap <silent> \c :call ProbeCscopeAndTags(expand("%:h"))<CR>:call PushCurrentLocation()<CR>:cs find c <C-R>=expand("<cword>")<CR><CR>:normal zz<CR>:call OpenQuickfix()<CR>:cfirst<CR>
nmap <silent> \i :call ProbeCscopeAndTags(expand("%:h"))<CR>:call PushCurrentLocation()<CR>:cs find i <C-R>=substitute(expand("<cfile>"),'/','.','g')<CR><CR>:normal zz<CR>:call OpenQuickfix()<CR>:cfirst<CR>
nmap <silent> \e :call ProbeCscopeAndTags(expand("%:h"))<CR>:call PushCurrentLocation()<CR>:cs find e <C-R>=expand("<cword>")<CR><CR>:normal zz<CR>:call OpenQuickfix()<CR>:cfirst<CR>
nmap <silent> \u :call ProbeCscopeAndTags(expand("%:h"))<CR>:call PushCurrentLocation()<CR>:cs find s <C-R>=expand("<cword>")<CR><CR>:normal zz<CR>:call OpenQuickfix()<CR>:cfirst<CR>
nmap <silent> \r :call ProbeCscopeAndTags(expand("%:h"))<CR>:call PushCurrentLocation()<CR>:cs find s <C-R>=expand("<cword>")<CR><CR>:normal zz<CR>:call OpenQuickfix()<CR>:cfirst<CR>

nmap <silent> zd :call ProbeCscopeAndTags(expand("%:h"))<CR>:call PushCurrentLocation()<CR>:cs find g <C-R>=expand("<cword>")<CR><CR>:normal zz<CR>:call OpenQuickfix()<CR>:cfirst<CR>
nmap <silent> zc :call ProbeCscopeAndTags(expand("%:h"))<CR>:call PushCurrentLocation()<CR>:cs find c <C-R>=expand("<cword>")<CR><CR>:normal zz<CR>:call OpenQuickfix()<CR>:cfirst<CR>
nmap <silent> zi :call ProbeCscopeAndTags(expand("%:h"))<CR>:call PushCurrentLocation()<CR>:cs find i <C-R>=substitute(expand("<cfile>"),'/','.','g')<CR><CR>:normal zz<CR>:call OpenQuickfix()<CR>:cfirst<CR>
nmap <silent> ze :call ProbeCscopeAndTags(expand("%:h"))<CR>:call PushCurrentLocation()<CR>:cs find e <C-R>=expand("<cword>")<CR><CR>:normal zz<CR>:call OpenQuickfix()<CR>:cfirst<CR>
nmap <silent> zu :call ProbeCscopeAndTags(expand("%:h"))<CR>:call PushCurrentLocation()<CR>:cs find s <C-R>=expand("<cword>")<CR><CR>:normal zz<CR>:call OpenQuickfix()<CR>:cfirst<CR>
nmap <silent> zr :call ProbeCscopeAndTags(expand("%:h"))<CR>:call PushCurrentLocation()<CR>:cs find s <C-R>=expand("<cword>")<CR><CR>:normal zz<CR>:call OpenQuickfix()<CR>:cfirst<CR>

nmap <Bar>E :call ProbeCscopeAndTags(expand("%:h"))<CR>:call PushCurrentLocation()<CR>:cscope find e<Space>
nmap <Bar>U :call ProbeCscopeAndTags(expand("%:h"))<CR>:call PushCurrentLocation()<CR>:cscope find s<Space>
nmap <Bar>R :call ProbeCscopeAndTags(expand("%:h"))<CR>:call PushCurrentLocation()<CR>:cscope find s<Space>
nmap ZE :call ProbeCscopeAndTags(expand("%:h"))<CR>:call PushCurrentLocation()<CR>:cscope find e<Space>
nmap ZU :call ProbeCscopeAndTags(expand("%:h"))<CR>:call PushCurrentLocation()<CR>:cscope find s<Space>
nmap ZR :call ProbeCscopeAndTags(expand("%:h"))<CR>:call PushCurrentLocation()<CR>:cscope find s<Space>

nmap <silent> \<Delete> :cscope reset<CR>
nmap <silent> z<Delete> :cscope reset<CR>


" for better interoperability with relative and fully-qualified paths
" disable cscoperelative and manipulate result output and refresh
" directory in OpenQuickfix below.
try | set nocscoperelative | catch | endtry
function! OpenQuickfix()
   copen
   set modifiable
   for l:d in keys(g:cscope_tags_dir) | try | execute '%s¬^'.l:d.'/\?¬¬' | catch | endtry | endfor
   set nomodified
   cd .
endfunction

let g:cscope_tags_dir = {}

let g:vcs_find_top_level = []

if executable('git') | let g:vcs_find_top_level += [ 'git rev-parse --show-toplevel' ] | endif
if executable('svn') | let g:vcs_find_top_level += [ "svn info | sed -n '/Working Copy/ s/[^:]*: //p'" ] | endif

function! ProbeCscopeAndTags(dir, ...) " second arg is 'force'
   let l:force = a:0? 1 : 0
   if !l:force && has_key(g:cscope_tags_dir, a:dir) | return | endif
   let l:repo = ''
   for l:find_top_level in g:vcs_find_top_level
      let l:repo = substitute(system('cd '.a:dir.' && '.l:find_top_level), '[\r\n]*', '', 'g')
      if empty(l:repo) | continue | endif
      break
   endfor
   if empty(l:repo)
      let l:repo = a:dir
      while 1
         if filereadable(l:repo.'/tags') || filereadable(l:repo.'/cscope.out')
            break
         endif
         let l:oldrepo = l:repo
         let l:repo = fnamemodify(l:repo, ':h')
         if l:oldrepo == l:repo
            unlet l:repo
            break
         endif
      endwhile
   endif
   if !empty(l:repo)
      if a:dir | let g:cscope_tags_dir[a:dir] = l:repo | endif
      if l:force || !has_key(g:cscope_tags_dir, l:repo)
         let g:cscope_tags_dir[l:repo] = 1
         try
            let &tags = &tags . ','.l:repo.'/tags'
            execute 'cscope add '.l:repo
         catch
         endtry
      endif
   endif
endfunction

if ! g:windows " too slow on windows
try | call ProbeCscopeAndTags(getcwd()) | catch | endtry
endif

function! DirOf(f)
   if isdirectory(a:f)
      return a:f
   endif
   return fnamemodify(a:f, ':h')
endfunction

function! DumpSymbolSources()
   echo "\nCSCOPE DATABASES:\n\n"
   cscope show
   echo "\nTAG FILES:\n\n"
   for l:f in tagfiles()
      echo l:f
   endfor
   echo "\n"
endfunction
com! DumpSymbolSources call DumpSymbolSources()

" GenQuickTagsCscope will generate tags and cscope data for the path
" pointed to by the current buffer.  It behaves as follows:
"  - If the buffer points into a git repository, the data is generated
"    in the root of the repository for the entire repository.
"  - If the buffer does not point into a git repository, data is
"    updated in the current working directory (preserving existing
"    data) for the directory containing the current buffer.
"  - If <bang> is used i.e. the command is spelled GenQuickTagsCscope!
"    then the data is generated in the directory of the current buffer
"    for that directory exclusively. 
com! -nargs=? -complete=file -bang GenQuickTagsCscope let s:d = DirOf(empty(<q-args>)? expand('%'): <q-args>) | echo "Generating default tags and cscope database for '". s:d ."'..." | let s:error = system((len(expand('<bang>'))?'env FORCE_DIR=1 ':'') .'bash "'.get(split(&runtimepath, ','), 0).'/bin/quick-tags-cscope.sh" "'. s:d .'"') | if !empty(s:error) | echoerr s:error | endif | call ProbeCscopeAndTags(s:d, 1) | echo 'Done.'
com! -nargs=? -complete=file       AddCscopeTagsDir   let s:d = DirOf(empty(<q-args>)? expand('%'): <q-args>) | call ProbeCscopeAndTags(s:d)

" Cb kept for legacy reasons
com! -nargs=* Cb :cb
com! -nargs=* GrepParse let oef=&errorformat | let &errorformat='%f:%l:%m' | :cb | let &errorformat=oef


set hidden        " allow modified buffers to be hidden
set bs=2          " default backspace like normal
set ai            " auto-indent ALWAYS
set si            " smart-indent
set cin           " C-aware indent
set vb            " visible bell rather than beep

set linespace=1 "pixel


""""""""""""""""""""""""""""""""""""""""""""""""
" text and display wrapping

" display wrapping

set nowrap " off by default
set linebreak
set sidescroll=5
set sidescrolloff=1
set encoding=utf-8
set listchars+=precedes:«,extends:»
try
   set breakindent
   set breakindentshift=0
catch
endtry
set showbreak=\ »\ 

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

let g:default_textwidth = 78
let &textwidth = 0

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
" text shuffling
nnoremap <expr> gp '`[' . strpart(getregtype(), 0, 1) . '`]'

""""""""""""""""""""""""""""""""""""""""""""""""

" don't save backups
set nobackup

" do highlighting of search pattern and enable incremental search
set hlsearch
set incsearch

" set cursor indications in gui mode
set guicursor=n-v-c:block-lCursor/Cursor,ve:ver35-Cursor,o:block-Cursor,i-ci:block-wCursor/Cursor-blinkwait60-blinkoff60-blinkon60,r-cr:block-oCursor/Cursor-blinkwait60-blinkoff60-blinkon60,sm:block-lCursor/Cursor-blinkwait175-blinkoff150-blinkon175

" cursor defaults for terminal (wrapped in ESC P ESC \ for GNU screen passthrough)
" NOTE: This is not perfect under GNU screen; since the control sequences are
"       passed through, GNU screen is not aware of them and thus does not
"       remember what the last cursor shape and cursor blink state was for
"       each window when switching between them.
let &t_ti = "\eP\e[1049h\e[2 q\e\\"       " enter termcap mode: use alt buffer and solid block cursor
let &t_te = "\eP\e[1049l\e[0 q\e\\"       " leave termcap mode: back to default buffer and default cursor
let &t_SI = "\eP\e[1 q\e\\"               " insert: blinking block
let &t_SR = "\eP\e[3 q\e\\"               " replace: blinking underline
let &t_EI = "\eP\e[2 q\e\\"               " normal: solid block
" neuter hide/show cursor controls and just change shape and blinking state
let &t_ve = ""
let &t_vi = ""
let &t_vs = ""
let &t_VS = ""

" show the position of the cursor
set ruler

" show matching parenthesise.
set showmatch

" Ignore superfluous character sequences in error lists to allow correct
" parsing of errors for the quick-fix window.  Superfluous character
" sequences include:
"   *  ansi color escape sequences
"   *  "[pid] " prefixes (including ones colored by ansi sequences)
"   *  "|" prefixes (from, e.g., bitbake output)
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
   let s:mstart = '\(^\|,\(%\([DX]\|[-+]G\)\)\?\)'
   let &errorformat = substitute( &errorformat, s:mstart, '\1%\\%%([ %#%*\\d]%\\)%\\? %#', 'g' )
   let &errorformat = substitute( &errorformat, s:mstart, '\1%\\%%(%[| ]%#%\\)%\\?', 'g' )
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

   " Rendering undercurl over X11 over SSH is painfully slow.
   " Underline seems OK.
   if $SSH_CONNECTION != ''
      let l:under = 'underline'
   else
      let l:under = 'undercurl'
   endif


   " replace solid background of spell/grammar errors in cterm with bright underline
   exe ''
   \.'  hi SpellBad   term=bold cterm='.l:underline.' ctermbg=none ctermfg=174 gui='.l:under.' guisp=Red'
   \.'| hi SpellCap   term=bold cterm='.l:underline.' ctermbg=none ctermfg=32  gui='.l:under.' guisp=Blue'
   \.'| hi SpellLocal term=bold cterm=bold'.l:cunderline.' ctermbg=none ctermfg=42  gui=undercurl guisp=Cyan'
   \.'| hi SpellRare  term=bold cterm=bold ctermbg=none ctermfg=206 gui=undercurl guisp=Magenta'

   if exists(':Hreload')
      Hreload
   endif

endfunction 

" convenience for reloading cursor colors if changing color-scheme
" (now called from change event autocmd)
function! ResetCursor()

   if &term =~ 'gui'
      hi clear CursorLine
      hi clear CursorColumn

      hi CursorLine   guibg=lightgray ctermbg=235
      hi CursorColumn guibg=lightgray ctermbg=235

      "hi Cursor		  guifg=bg	guibg=#305080
      hi wCursor		  guifg=bg	guibg=#FF1020
      hi oCursor		  guifg=bg	guibg=#CC20FF
   endif

endfunction

""""""""""""""""""""""""""""""""""""""""""""""""

if has("autocmd")

   " disable spell under some conditions
   autocmd FileType diff,patch setlocal nospell comments=n:###,n:##,n:#,n:FIXME:,n:TODO:,n:XXX:,n:FIXME,n:TODO
   autocmd FileType git-diff setlocal nospell
   autocmd FileType git setlocal nospell
   autocmd FileType qf setlocal nospell
   autocmd FileType messages setlocal nospell
   autocmd BufNewFile __Tag_List__ setlocal nospell

   autocmd FileType md,rst,text,yaml setlocal spell

   autocmd ColorScheme * call SetTerminalHighlighting() | call ResetCursor()

   " Set reads from stdin to be considered unmodified
   " Also, for convenience, if the first line matches 'grep -n' style
   " output, then use it as quickfix content and center on the first
   " line.
   autocmd StdinReadPost * set nomodified | if getline(1) =~ '^\f\+:\d\+:\(\d\+:\)\?' |:cb|:execute 'normal zz'|:execute 'doautocmd filetypedetect BufRead '.expand('%')|:call ShowWhitespaceErrors()|:copen| endif

   autocmd BufReadPost *.patch,*.diff if getline(1) =~ '^From [0-9a-f]\{40\}' | let &ft='git-diff' | normal <CR> | fi

   " Set some sensible defaults for editing C-files
   augroup clikeprog
     " Remove all cprog autocommands
     au!

     " When starting to edit a file:
     "   For *.c and *.h files set formatting of comments and set C-indenting on.
     "   For other files switch it off.
     "   Don't change the order, it's important that the line with * comes first.
     autocmd BufNewFile,BufRead *       setlocal formatoptions=tcql nocindent noautoindent comments&
     autocmd BufNewFile,BufRead *.gpp setlocal filetype=cppcc cindent comments=sr:/*,mbl:*/,ex:*/,://
     autocmd BufNewFile,BufRead *.impl setlocal filetype=cpp spell
     autocmd BufNewFile,BufRead *.c,*.h,*.cpp,*.cxx,*.cc,*.inl,*.impl,*.hpp,*.java,*.js,*.jsx,*.ts,*.tsx,*.cs setlocal formatoptions=croql cindent comments=sr:/*,mb:\ *,ex:\ */,:///://,n:///,n://,n:FIXME:,n:TODO:,n:XXX:,n:FIXME,n:TODO,n:XXX,fb:- spell
     autocmd BufNewFile,BufRead *.s,*.asm,*.s11,*.i setlocal filetype=asm tabstop=14 formatoptions=croql cindent comments=";" spell
     autocmd BufNewFile,BufRead *.fp,*.cg,*.vp setlocal filetype=cg cindent comments=sr:/*,mbl:*/,ex:*/,://  setlocal spell
     autocmd BufNewFile,BufRead *.glsl,*.gls,*.frag,*.vert setlocal filetype=gls cindent comments=sr:/*,mbl:*/,ex:*/,:// spell
     autocmd BufNewFile,BufRead mib2c.*.conf setlocal filetype=mib2c
   augroup END
   autocmd BufNewFile,BufRead *.js,*.html,*.jade,*.xml setlocal ts=2 sw=2 spell

   autocmd BufNewFile,BufRead *.git-diff setlocal ft=git-diff
   autocmd BufNewFile,BufRead *.diff setlocal ft=diff
   autocmd BufNewFile,BufRead COMMIT_EDITMSG setlocal ft=gitcommit spell

   autocmd BufNewFile,BufRead *.rej,*.orig nmap <silent><buffer> <Bar>? :call SplitEditBase()<CR>

   autocmd BufNewFile,BufRead * call ShowWhitespaceErrors()

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
     autocmd BufReadPre,FileReadPre *.gz setlocal bin
     autocmd BufReadPre,FileReadPre *.gz let ch_save = &ch|setlocal ch=2
     autocmd BufReadPost,FileReadPost  *.gz '[,']!gunzip
     autocmd BufReadPost,FileReadPost  *.gz setlocal nobin
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
     autocmd BufReadPre,FileReadPre        *.bz2 setlocal bin
     autocmd BufReadPre,FileReadPre        *.bz2 let ch_save = &ch|setlocal ch=2
     autocmd BufReadPost,FileReadPost      *.bz2 setlocal cmdheight=2|'[,']!bunzip2
     autocmd BufReadPost,FileReadPost      *.bz2 setlocal cmdheight=1 nobin|execute ":doautocmd BufReadPost %:r"
     autocmd BufReadPost,FileReadPost      *.bz2 let &ch = ch_save|unlet ch_save
   
     autocmd BufWritePost,FileWritePost    *.bz2 !mv <afile> <afile>:r
     autocmd BufWritePost,FileWritePost    *.bz2 !bzip2 <afile>:r
   
     autocmd FileAppendPre                 *.bz2 !bunzip2 <afile>
     autocmd FileAppendPre                 *.bz2 !mv <afile>:r <afile>
     autocmd FileAppendPost                *.bz2 !mv <afile> <afile>:r
     autocmd FileAppendPost                *.bz2 !bzip2 -9 --repetitive-best <afile>:r
   augroup END

   " Reset the multi-cursor highlight when colorscheme changes
   augroup mc_cs_reload
      autocmd ColorScheme * hi multiple_cursors_cursor term=reverse cterm=reverse gui=reverse | hi link multiple_cursors_visual Visual
   augroup END

endif " has ("autocmd")


if $_ == "" || $_ =~ "gvim"
   " show the gui now, if possible (i.e. if running a gui capable vim).
   " some things below depend on overriding defaults provided by default
   " when opening the gui window.
   try
      eval ':gui'
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
let g:preferred_scheme='PaperColor'
let g:fallback_bg='light'
let g:fallback_scheme='default'

let g:fullcolorterm = &term =~ 'gui' || ( &t_Co == '256' && &term != 'linux' )

runtime prefs
if filereadable(expand("~/.vim-prefs")) | source ~/.vim-prefs | endif

" set colorscheme based on user name and terminal type
"
if g:user == 'root'

   colorscheme darkblue
   set bg=dark

elseif g:fullcolorterm && exists(':GuiColorScheme')

   runtime plugin/guicolorscheme.vim
   let &bg=g:preferred_bg
   exec "GuiColorScheme ".g:preferred_scheme

else

   try
      silent! exec "colorscheme ".g:preferred_scheme
      let &bg=g:preferred_bg
   catch
      exec "colorscheme ".g:fallback_scheme
      let &bg=g:fallback_bg
   endtry

endif


function! ShowWhitespaceErrors()
   highlight default link WSError Error
   syn match WSError / \+\ze\t/ containedin=ALL
   syn match WSError /\s\+$/ containedin=ALL
endfunction


function! ShowOverlongLines()
   highlight default link OverlongLine Todo
   if exists('b:line_length_error')
      call matchdelete(b:line_length_error)
   endif
   let b:line_length_error = matchadd("OverlongLine", '.\%>'.(&tw + 1).'v', 999)
endfunction


function! GNUStyle()
   set cinoptions=>4,n-2,{2,^-2,:2,=2,g0,h2,p5,t0,+2,(0,u0,w1,m1
   set shiftwidth=2
   set tabstop=8
   set noexpandtab
   set comments=s:/*,m:\ \ \ ,re:*/,:///://,n:///,n://,n:FIXME:,n:TODO:,n:XXX:,n:FIXME,n:TODO,n:XXX,fb:-
   set tw=80

   syn keyword cType tree

   call ShowOverlongLines()
endfunction
command! GNUStyle call GNUStyle()


function! Tab84()
   set tabstop=8
   set shiftwidth=4
   set textwidth=80
   set noexpandtab

   set cindent
   set formatoptions=tcqlron
   set cinoptions=:0,l1,t0,g0

   call ShowOverlongLines()
endfunction
command! Tab84 call Tab84()


function! LinuxStyle()
   call Tab84()
   set shiftwidth=8

   syn keyword cOperator likely unlikely
   syn keyword cType u8 u16 u32 u64 s8 s16 s32 s64

   call ShowOverlongLines()
endfunction
command! LinuxStyle call LinuxStyle()


function! DefaultStyle()
   set tabstop=3
   set shiftwidth=3
   set expandtab
endfunction
command! DefaultStyle call DefaultStyle()
call DefaultStyle()


function! LogView()
   colorscheme lucius
   set bg=light
   set ts=10
   set nospell
   set ve=all
   syn clear
   runtime syntax/logfile.vim
   let g:match_maps = 0
   normal \m
endfunction
command! LogView call LogView()

function! RediffWithout(...)
   let l:oldv = winsaveview()
   let l:oldw = winnr()
   if a:0 == 0
      echoerr 'usage: RediffWithout(pat[, pat, [...]])'
      throw 'badargs'
   endif
   let l:pat = '\(' . join(a:000, '\)\|\(') . '\)'
   wincmd w
   while 1
      if &diff
         let l:modified = &modified
         let l:modifiable = &modifiable
         let &modifiable = 1
         if search(l:pat) > 0
            call feedkeys("i\<C-G>u", 'intx')
            exec 'silent noautocmd %s/'.l:pat.'//g'
            let b:numsubst = 1
         else
            unlet b:numsubst
         endif
         let &modified = l:modified
         let &modifiable = l:modifiable
      endif
      if winnr() == l:oldw
         break
      endif
      wincmd w
   endwhile
   noautocmd diffupdate
   wincmd w
   while 1
      if &diff && exists('b:numsubst')
         let l:modified = &modified
         let l:modifiable = &modifiable
         let &modifiable = 1
         exec 'silent noautocmd undo'
         unlet b:numsubst
         let &modified = l:modified
         let &modifiable = l:modifiable
      endif
      if winnr() == l:oldw
         break
      endif
      wincmd w
   endwhile
   call winrestview(l:oldv)
endfunction

function! RediffWithoutNumbers(...)
   let l:pat = exists('g:numbers_pat')? g:numbers_pat :
            \ '0x[0-9a-fA-F]\+\|\<[0-9]\+\>'
   if exists('g:numbers_extra_pat')
      let l:pat = l:pat . '\|' . g:numbers_extra_pat
   endif
   call call("RediffWithout", [l:pat] + a:000)
endfunction


command! -nargs=* RediffWithout call RediffWithout(<f-args>)
command! -nargs=* RediffWithoutNumbers call RediffWithoutNumbers(<f-args>)


function! FocusOnCurrent()
   let [l:_, l:line, l:col, l:_] = getpos('.')
   exec 'silent! tabe %'
   exec 'silent! vnew! +setlocal\ buftype=nofile\ nobuflisted\ noswapfile\ nonumber\ nomodified\ nomodifiable\ readonly -'
   exec 'silent! vsplit'
   wincmd L
   let l:pad = &columns / 4
   exec l:pad . 'wincmd |'
   exec '1wincmd w'
   exec l:pad . 'wincmd |'
   exec '2wincmd w'
   call cursor(l:line, l:col)
endfunction
function! FocusTabClose()
   let l:first_buf = tabpagebuflist()[0]
   if buffer_name(l:first_buf) == '-'
      exec 'tabclose'
   else
      echo "Ignoring attempt to close tab that wasn't created with FocusOnCurrent."
   endif
endfunction
command! FocusOnCurrent call FocusOnCurrent()
command! FocusTabClose call FocusTabClose()
nmap <silent> \<PageUp> :FocusOnCurrent<C-M>
nmap <silent> \<PageDown> :FocusTabClose<C-M>
nmap <silent> z<PageUp> :FocusOnCurrent<C-M>
nmap <silent> z<PageDown> :FocusTabClose<C-M>


" Support * and # in visual mode (http://vim.wikia.com/wiki/Search_for_visually_selected_text)
" Search for selected text, forwards or backwards.
vnoremap <silent> * :<C-U>
  \let old_reg=getreg('"')<Bar>let old_regtype=getregtype('"')<CR>
  \gvy/<C-R><C-R>=substitute(
  \escape(@", '/\.*$^~['), '\_s\+', '\\_s\\+', 'g')<CR><CR>
  \gV:call setreg('"', old_reg, old_regtype)<CR>
vnoremap <silent> # :<C-U>
  \let old_reg=getreg('"')<Bar>let old_regtype=getregtype('"')<CR>
  \gvy?<C-R><C-R>=substitute(
  \escape(@", '?\.*$^~['), '\_s\+', '\\_s\\+', 'g')<CR><CR>
  \gV:call setreg('"', old_reg, old_regtype)<CR>


" lighten up control characters
hi SpecialKey guifg=gray

" show statusbar always
set laststatus=2

" allow overriding without changing this, possibly, version controlled
" file; this file should be placed in ~/.vim/ on unix or personal or
" system-wide vimfiles on windows.
runtime vimrc-overrides
" alternatively, place a dot-prefixed version in HOME.
if filereadable(expand("~/.vimrc-overrides")) | source ~/.vimrc-overrides | endif

if $PROFILE_VIM_STARTUP == 1
   profdel *
endif
if $PROFILE_VIM_POST_STARTUP == 1
   profile start vim-post-startup-profile.log
   profile func *
   profile file *
endif
