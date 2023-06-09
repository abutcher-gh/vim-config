" guicolorscheme.vim: Convert GUI only color schems
"
" Maintainer:	 Aaron Griffin <aaron@archlinux.org>
" Last Modified: Mon Feb 26 22:52:34 UTC 2007
" Version:       1.0 for Vim 7.0+ 
" URL:           http://www.vim.org/script.php?script_id=39
"
" Convert a GUI-only colorscheme to support 88 and 256 color terminals
" This should also work on the GUI, so using it 100% of the time, assuming
" you always have a non 8/16 color terminal should work fine

" conversion functions {{{
" canibalized from desert256.vim

function! s:greynum(x) "{{{
    if &t_Co == 88
        if a:x < 23
            return 0
        elseif a:x < 69
            return 1
        elseif a:x < 103
            return 2
        elseif a:x < 127
            return 3
        elseif a:x < 150
            return 4
        elseif a:x < 173
            return 5
        elseif a:x < 196
            return 6
        elseif a:x < 219
            return 7
        elseif a:x < 243
            return 8
        else
            return 9
        endif
    else
        if a:x < 14
            return 0
        else
            let l:n = (a:x - 8) / 10
            let l:m = (a:x - 8) % 10
            if l:m < 5
                return l:n
            else
                return l:n + 1
            endif
        endif
    endif
endfunction "}}}
function! s:greylvl(n) "{{{
    if &t_Co == 88
        if a:n == 0
            return 0
        elseif a:n == 1
            return 46
        elseif a:n == 2
            return 92
        elseif a:n == 3
            return 115
        elseif a:n == 4
            return 139
        elseif a:n == 5
            return 162
        elseif a:n == 6
            return 185
        elseif a:n == 7
            return 208
        elseif a:n == 8
            return 231
        else
            return 255
        endif
    else
        if a:n == 0
            return 0
        else
            return 8 + (a:n * 10)
        endif
    endif
endfunction "}}}
function! s:grey(n) "{{{
    if &t_Co == 88
        if a:n == 0
            return 16
        elseif a:n == 9
            return 79
        else
            return 79 + a:n
        endif
    else
        if a:n == 0
            return 16
        elseif a:n == 25
            return 231
        else
            return 231 + a:n
        endif
    endif
endfunction "}}}

function! s:rgbnum(x) "{{{
    if &t_Co == 88
        if a:x < 69
            return 0
        elseif a:x < 172
            return 1
        elseif a:x < 230
            return 2
        else
            return 3
        endif
    else
        if a:x < 75
            return 0
        else
            let l:n = (a:x - 55) / 40
            let l:m = (a:x - 55) % 40
            if l:m < 20
                return l:n
            else
                return l:n + 1
            endif
        endif
    endif
endfunction "}}}
function! s:rgblvl(n) "{{{
    if &t_Co == 88
        if a:n == 0
            return 0
        elseif a:n == 1
            return 139
        elseif a:n == 2
            return 205
        else
            return 255
        endif
    else
        if a:n == 0
            return 0
        else
            return 55 + (a:n * 40)
        endif
    endif
endfunction "}}}
function! s:rgb(r, g, b) "{{{
    if &t_Co == 88
        return 16 + (a:r * 16) + (a:g * 4) + a:b
    else
        return 16 + (a:r * 36) + (a:g * 6) + a:b
    endif
endfunction "}}}

function! s:color(r, g, b) "{{{
    " get the closest grey
    let l:gx = s:greynum(a:r)
    let l:gy = s:greynum(a:g)
    let l:gz = s:greynum(a:b)

    " get the closest color
    let l:x = s:rgbnum(a:r)
    let l:y = s:rgbnum(a:g)
    let l:z = s:rgbnum(a:b)

    let l:level = (a:r * a:r) + (a:g * a:g) + (a:b * a:b)
    if l:gx == l:gy && l:gy == l:gz
        " there are two possibilities
        let l:dgr = s:greylvl(l:gx)
        let l:dgg = s:greylvl(l:gy)
        let l:dgb = s:greylvl(l:gz)
        let l:dgrey = (l:dgr * l:dgr) + (l:dgg * l:dgg) + (l:dgb * l:dgb) - l:level

        let l:dr = s:rgblvl(l:gx)
        let l:dg = s:rgblvl(l:gy)
        let l:db = s:rgblvl(l:gz)
        let l:drgb = (l:dr * l:dr) + (l:dg * l:dg) + (l:db * l:db) - l:level

        if l:dgrey < l:drgb
            " use the grey
            return s:grey(l:gx)
        else
            " use the color
            return s:rgb(l:x, l:y, l:z)
        endif
    else
        " only one possibility
        return s:rgb(l:x, l:y, l:z)
    endif
endfunction "}}}
function! s:cindex(rgb) "{{{
    "convert RRGGBB to a terminal (numeric) index
    let l:r = ("0x" . strpart(a:rgb, 0, 2)) + 0
    let l:g = ("0x" . strpart(a:rgb, 2, 2)) + 0
    let l:b = ("0x" . strpart(a:rgb, 4, 2)) + 0

    return s:color(l:r, l:g, l:b)
endfunction "}}}


" default colors; to allow for assignments like ctermfg=bg etc. 
let s:def_fg = '7'
let s:def_bg = '16'

function! s:HL(group, fg, bg, attr) "{{{
    "The main highlight (HL) function
    let l:fg = a:fg
    let l:bg = a:bg
    if a:group == "Normal"
        let s:def_fg = l:fg
        let s:def_bg = l:bg
    else
        if l:fg =~ '[fb]g'
            exe 'let l:fg = s:def_' . l:fg
        endif
        if l:bg =~ '[fb]g'
            exe 'let l:bg = s:def_' . l:bg
        endif
    endif
    if l:fg != ""
        exec "hi " . a:group . " guifg=#" . l:fg . " ctermfg=" . s:cindex(l:fg)
    endif
    if l:bg != ""
        exec "hi " . a:group . " guibg=#" . l:bg . " ctermbg=" . s:cindex(l:bg)
    endif
    if a:attr != ""
        exec "hi " . a:group . " gui=" . a:attr . " cterm=" . a:attr
    endif
endfunction "}}}

"}}}

" Completion Helpers {{{
function! s:Colorscheme_Complete(A,L,P)
    let l:files = split(globpath(&runtimepath, "colors/" . a:A . "*"), "\n")
    let l:retlist = []
    for file in l:files
        let l:basename = substitute(file, ".*/", "", "")
        let l:basename = substitute(l:basename, "\.vim", "", "")
        call add(l:retlist, l:basename)
    endfor
    return l:retlist
endfunction

function! s:GetColorschemeFile(fname)
    let l:files = split(globpath(&runtimepath, "colors/" . a:fname . ".vim"), "\n")
    if len(l:files) == 0
        echoerr "Colorscheme ".a:fname." not found"
        return ""
    else
        return l:files[0]
    endif
endfunction

command! -complete=customlist,s:Colorscheme_Complete -nargs=1 GuiColorScheme :call s:GuiColorScheme("<args>")
" }}}

function! s:GuiColorScheme(fname)
    if filereadable(a:fname)
        let l:file = a:fname
    else
        let l:file = s:GetColorschemeFile(a:fname)
    endif
    if l:file == ""
        return 1
    endif

    if has("gui_running")
        exec "colorscheme " . fnamemodify(l:file, ":t:r")
        return 0
    endif

    " simplistic nested if handling; these are both empty if there are
    " no if's
    let l:iftrue = []  " list of 0 or 1 for the current clause of each if level
    let l:ifdone = []  " list of 0 or 1 for the completed (i.e. true done) state of each if level

    for line in readfile(l:file)

        " chomp front
        let line = substitute(line, '^\s*', '', '')

        " transform variable names to be local (:exe won't work on s: vars)
        let line = substitute(line, 's:', 'l:gcs_s_', 'g')

        " handle simple if nesting
        if line =~ '^\(if\|elseif\)'
            if line =~ '^else'
                let l:ifdone[-1] = l:ifdone[-1] || l:iftrue[-1]
                let l:iftrue[-1] = 0
            else
                " decision is already made if an existing outer scope is false
                let l:ifdone += [ len(l:iftrue) > 0 && l:iftrue[-1] == 0 ]
                let l:iftrue += [ 0 ]
            endif
            if l:ifdone[-1] == 0
                let l:tokend = match(line, "[ \t]")
                exe 'let l:iftrue[-1] = ' . strpart(line, l:tokend)
            endif
        elseif line =~ '^else'
            let l:ifdone[-1] = l:ifdone[-1] || l:iftrue[-1]
            let l:iftrue[-1] = !l:ifdone[-1]
        elseif line =~ '^endif'
            let l:ifdone = l:ifdone[0:-2]
            let l:iftrue = l:iftrue[0:-2]
        endif

        " any live conditions?
        if len(l:iftrue) > 0
            " skip false clauses
            if l:ifdone[-1] == 1 || l:iftrue[-1] == 0
                continue
            endif
        endif

        " execute set/let lines
        if line =~ '^[sl]et' && line !~ 'colors_name'
            exe line
        endif

        " process highlight lines
        if line =~ '^hi'
            let l:name = ""
            let l:fg = ""
            let l:bg = ""
            let l:attr = ""

            " get highlight name
            let l:start = match(line, "hi")
            let l:end = match(line, "[ \t]", l:start)
            let l:start = l:end +1
            let l:end = match(line, "[ \t]", l:start)
            let l:name = strpart(line, l:start, l:end - l:start)

            " strip foreground color
            let l:start = match(line, "guifg=")
            if l:start != -1
                let l:start = l:start + 6 "strlen(guifg=)
                let l:end = match(line, "[ \t]", l:start)
                if l:end == -1
                    let l:fg = strpart(line, l:start)
                else
                    let l:fg = strpart(line, l:start, l:end - l:start)
                endif
                if strpart(l:fg, 0, 1) == "#"
                    let l:fg = strpart(l:fg, 1)
                endif
            endif

            " strip background color
            let l:start = match(line, "guibg=")
            if l:start != -1
                let l:start = l:start + 6 "strlen(guibg=)
                let l:end = match(line, "[ \t]", l:start)
                if l:end == -1
                    let l:bg = strpart(line, l:start)
                else
                    let l:bg = strpart(line, l:start, l:end - l:start)
                endif
                if strpart(l:bg, 0, 1) == "#"
                    let l:bg = strpart(l:bg, 1)
                endif
            endif

            " strip attribute
            let l:start = match(line, "gui=")
            if l:start != -1
                let l:start = l:start + 4 "strlen(gui=)
                let l:end = match(line, "[ \t]", l:start)
                if l:end == -1
                    let l:attr = strpart(line, l:start)
                else
                    let l:attr = strpart(line, l:start, l:end - l:start)
                endif
            endif

            call s:HL(l:name, l:fg, l:bg, l:attr)
        endif
    endfor

    doautocmd ColorScheme *
endfunction

" vim:ft=vim:fdl=0:fdm=marker:ts=4:sw=4
