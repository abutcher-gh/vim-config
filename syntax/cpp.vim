"
" FILE: cpp.vim
"
" ABSTRACT:
"
" AUTHOR: Ralf Schandl <schandl@de.ibm.com>
"   
" $Id: c.vim,v 1.1 2000/12/27 12:01:25 rks Exp $
"   
" =============================================================================
"

source $VIMRUNTIME/syntax/cpp.vim


try
    source $HOME/.vim/doxyvim/doxygen.vim
catch /.*/
    try
        source $HOME/vimfiles/doxyvim/doxygen.vim
    catch /.*/
        source $VIM/vimfiles/doxyvim/doxygen.vim
    endtry
endtry


"---------------------------------------
" comment coloring
"---------------------------------------
syn case ignore
let main_syntax='java'  " the html syntax file knows about html in javadoc comments (which also works in doxygen)
syn include @cppCommentHtml $VIMRUNTIME/syntax/html.vim
if version >= 701
  syntax spell default
endif    
unlet main_syntax


syn match cdoxyTag           contained /[\\@][A-Za-z_]\+\s*/
syn match cdoxyTag           contained /[\\@]f[\[\]\$]\s*/
syn match cdoxyTagOptions    contained /\[[^\]]*\]/
syn match cdoxyTagBold       contained /[\\@]\(c\|b\|d\)\(\[[^\]]*\]\)\?\s\+\S\+\s*/ contains=cdoxyTag,cdoxyTagOptions
syn match cdoxyTagEmph       contained /[\\@]\(e\|t\)\(\[[^\]]*\]\)\?\s\+\S\+\s*/ contains=cdoxyTag,cdoxyTagOptions
syn match cdoxyTagWithArg    contained /[\\@]\(al\?\|\(sub\)\?page\|anchor\|ref\|itemref\|t\?param\|class\|struct\|namespace\|fn\|\(sub\)*section\|defgroup\|ingroup\|copyd\(oc\|etail\)\|see\|sa\|throws\)\(\[[^\]]*\]\)\?\s\+\S\+\s*/ contains=cdoxyTag,cdoxyTagOptions
syn region cdoxyBraceTag     contained keepend start=/[\\@]\([A-Za-z_]\+\){/  end=/}/       contains=cdoxyTag,cdoxyTagOptions,cdoxyRepeatedStar
syn region cdoxyBraceTagBold contained keepend start=/[\\@]\(b_\|d_\){/hs=s+4 end=/}/he=e-1 contains=cdoxyTag,cdoxyTagOptions,cdoxyRepeatedStar
syn region cdoxyBraceTagEmph contained keepend start=/[\\@]\(e_\|t_\){/hs=s+4 end=/}/he=e-1 contains=cdoxyTag,cdoxyTagOptions,cdoxyRepeatedStar
syn match cdoxyTitle         contained /[\\@]\(\(main\)\?page\|par\>\|section\|\(sub\)\+section\|defgroup\).*$/ contains=cdoxyTagWithArg,cdoxyTagBold,cdoxyTagEmph,cdoxyTag
syn match cdoxyUrl           contained `\<[a-z0-9]\+:/\+\S\+`
syn region cdoxyCommentSpecial contained keepend start=+"+hs=s+1 skip=+\\["\\]+ end=+"+he=e-1 end="\*\+/"me=s-1 contains=@Spell
syn match cdoxyCommentEmph contained /\([A-Za-z0-9_:][A-Za-z0-9_\-\+=<>!:]*\ze([^)]*)\)/
syn match cdoxyCommentEmph contained /\([A-Za-z0-9_:][A-Za-z0-9_\-\+=<>!:]*\ze<[^>]*>\)/
syn match cdoxyCommentEmph contained /¯\([^ 	()]*\)/ contains=cGhost
syn match cGhost /\(¯\)/ contained 

" highlight these differently
syn match cdoxyMarkers contained /[\\@]\(end\)\?\(code\|\(ez\)\?dot\|perl\|shell\|msc\|verbatim\)/
syn region cdoxyCode contained keepend start=/[\\@]\(code\|\(ez\)\?dot\|perl\|shell\|msc\|verbatim\)\>/hs=e+1,rs=e+1 end=/[\\@]end\(code\|\(ez\)\?dot\|perl\|shell\|msc\|verbatim\)\>/ contains=cdoxyRepeatedStar,cdoxyMarkers
syn match cdoxyAngles contained /<[^A-Za-z0-9_()"/-]/hs=e+1
syn match cdoxyAngles contained /[^A-Za-z0-9_()"/-]>/hs=e+1

syn region cdoxyBound       keepend start="/\*[*!]\+" end="\*\+/" contains=cdoxySentanceOne,@cppCommentHtml,cdoxyTag,cdoxyBraceTagBold,cdoxyBraceTagEmph,cdoxyBraceTag,cdoxyTitle,cdoxyTagWithArg,cdoxyTagBold,cdoxyTagEmph,cdoxyCommentEmph,cdoxyCommentSpecial,cdoxyRepeatedStar,@cCommentGroup,cdoxyCode,cdoxyAngles,cdoxyUrl
syn match  cComment     /\/\*\+\*\//
syn region cdoxySentanceOne contained keepend start="\(/\*[*!]\+\(*/\)\@!\|[@\\]\(copy\(doc\|brief\|details\)\|class\|struct\|namespace\|fn\)\)"hs=e+1 skip="\.\\" end="\.$" end="\.[ \t\r&]" end="\*\+/"me=s-1 contains=@cppCommentHtml,cdoxyRepeatedStar,cdoxyCommentSpecial,@cCommentGroup,cdoxyTag,cdoxyBraceTagBold,cdoxyBraceTagEmph,cdoxyBraceTag,cdoxyTitle,cdoxyTagWithArg,cdoxyTagBold,cdoxyTagEmph,cdoxyAngles,cdoxyCommentEmph
syn match  cdoxyRepeatedStar /^[     ]*\*\+/ contained
syn case match

hi def link cdoxyTag  SpecialComment
hi def link cdoxyMarkers  SpecialKey
hi def link cdoxyTagOptions  cdoxyCommentSpecial
hi def link cdoxyTagWithArg  Function
hi def link cdoxyTagBold  htmlBold
hi def link cdoxyTagEmph  htmlItalic
hi def link cdoxyBraceTag  Function
hi def link cdoxyBraceTagBold  htmlBold
hi def link cdoxyBraceTagEmph  htmlItalic
hi def link cdoxyTitle        htmlUnderline
hi def link cdoxyUrl        htmlLink
hi def link cdoxyBound        Comment
hi def link cdoxySentanceOne  SpecialComment
hi def link cdoxyRepeatedStar Comment
hi def link cdoxyCode        cdoxyCommentSpecial
hi def link cdoxyCommentEmph  Function
hi def link cdoxyCommentSpecial LineNr
hi def link cGhost  Ignore

syn cluster cCommentGroup add=cdoxyBound,cTodo,@Spell

" members of these groups are ignored within parens and ?:
syn cluster cParenGroup add=cdoxyCommentEmph,cdoxyCommentSpecial,cdoxyTagOptions,cdoxySentanceOne
syn cluster cMultiGroup add=cdoxyCommentEmph,cdoxyCommentSpecial,cdoxyTagOptions,cdoxySentanceOne

syn match cTodo contained /\(TODO\)\|\(FIXME\)\|\(XXX\)\|\(\\todo\)/

"--------------------------------------------------
" color preprocessor errors using warning color
"--------------------------------------------------
syn region cppErrorText matchgroup=Preproc start="#\s*error\s" end="$"
hi def link cppErrorText WarningMsg

syn match cppCast	"\<assert_\(static_\)\?cast\s*<"me=e-1
syn match cppCast	"\<assert_\(static_\)\?cast\s*$"
syn match cppCast	"\<\(reinterpret\|static\|const\|dynamic\)_pointer_cast\s*<"me=e-1
syn match cppCast	"\<\(reinterpret\|static\|const\|dynamic\)_pointer_cast\s*$"

syn match Special	"\<\(OpaqueLock\|[Ss]cope\(Acquire\|Relinquish\)\|\([Aa]cquire\|[Rr]el\(ease\|inquish\)\)[A-Za-z]*Lock\)\>"
syn match Special	"\<\(shared\|upgrade\|upgrade_to_unique\|unique\)_lock\>"

syn match Special	"\(->\|[.]\)\s*\zs\(\(Try\|try_\)\?[Ll]\|[Uu]nl\)ock\s*("me=e-1
syn match Special	"\<move\s*("me=e-1
syn match Special	"\<forward\s*<"me=e-1

syn keyword Keyword foreach
syn keyword Keyword auto_for for_auto
syn keyword Keyword	thread_local
syn keyword Keyword	alignof

syn keyword Type	decltype
syn keyword Type	constexpr

syn match cppScopeRes "::"
hi def link cppScopeRes Special

syn keyword cppBoostPP BOOST_PP_ADD BOOST_PP_ADD_D BOOST_PP_AND BOOST_PP_APPLY BOOST_PP_ARRAY_DATA BOOST_PP_ARRAY_ELEM BOOST_PP_ARRAY_INSERT BOOST_PP_ARRAY_INSERT_D BOOST_PP_ARRAY_POP_BACK 
syn keyword cppBoostPP BOOST_PP_ARRAY_POP_BACK_Z BOOST_PP_ARRAY_POP_FRONT BOOST_PP_ARRAY_POP_FRONT_Z BOOST_PP_ARRAY_PUSH_BACK BOOST_PP_ARRAY_PUSH_FRONT BOOST_PP_ARRAY_REMOVE BOOST_PP_ARRAY_REMOVE_D BOOST_PP_ARRAY_REPLACE BOOST_PP_ARRAY_REPLACE_D 
syn keyword cppBoostPP BOOST_PP_ARRAY_REVERSE BOOST_PP_ARRAY_SIZE BOOST_PP_ASSERT BOOST_PP_ASSERT_MSG BOOST_PP_ASSIGN_SLOT  BOOST_PP_BITAND BOOST_PP_BITNOR BOOST_PP_BITOR BOOST_PP_BITXOR 
syn keyword cppBoostPP BOOST_PP_BOOL  BOOST_PP_CAT BOOST_PP_COMMA BOOST_PP_COMMA_IF BOOST_PP_COMPL BOOST_PP_CONFIG_EXTENDED_LINE_INFO  BOOST_PP_DEC BOOST_PP_DEDUCE_D BOOST_PP_DEDUCE_R 
syn keyword cppBoostPP BOOST_PP_DEDUCE_Z BOOST_PP_DIV BOOST_PP_DIV_D  BOOST_PP_EMPTY BOOST_PP_ENUM BOOST_PP_ENUM_BINARY_PARAMS BOOST_PP_ENUM_BINARY_PARAMS_Z BOOST_PP_ENUM_PARAMS BOOST_PP_ENUM_PARAMS_WITH_A_DEFAULT 
syn keyword cppBoostPP BOOST_PP_ENUM_PARAMS_WITH_DEFAULTS BOOST_PP_ENUM_PARAMS_Z BOOST_PP_ENUM_SHIFTED BOOST_PP_ENUM_SHIFTED_PARAMS BOOST_PP_ENUM_SHIFTED_PARAMS_Z BOOST_PP_ENUM_SHIFTED_ BOOST_PP_ENUM_TRAILING BOOST_PP_ENUM_TRAILING_BINARY_PARAMS BOOST_PP_ENUM_TRAILING_BINARY_PARAMS_Z 
syn keyword cppBoostPP BOOST_PP_ENUM_TRAILING_PARAMS BOOST_PP_ENUM_TRAILING_PARAMS_Z BOOST_PP_ENUM_TRAILING_ BOOST_PP_ENUM_ BOOST_PP_EQUAL BOOST_PP_EQUAL_D BOOST_PP_EXPAND BOOST_PP_EXPR_IF BOOST_PP_EXPR_IIF  
syn keyword cppBoostPP BOOST_PP_FILENAME_1 BOOST_PP_FILENAME_2 BOOST_PP_FILENAME_3 BOOST_PP_FILENAME_4 BOOST_PP_FILENAME_5 BOOST_PP_FOR BOOST_PP_FOR_ BOOST_PP_FRAME_FINISH BOOST_PP_FRAME_FLAGS 
syn keyword cppBoostPP BOOST_PP_FRAME_ITERATION BOOST_PP_FRAME_START  BOOST_PP_GREATER BOOST_PP_GREATER_D BOOST_PP_GREATER_EQUAL BOOST_PP_GREATER_EQUAL_D  BOOST_PP_IDENTITY BOOST_PP_IF BOOST_PP_IIF 
syn keyword cppBoostPP BOOST_PP_INC BOOST_PP_INCLUDE_SELF BOOST_PP_INDIRECT_SELF BOOST_PP_INTERCEPT BOOST_PP_IS_ITERATING BOOST_PP_IS_SELFISH BOOST_PP_ITERATE BOOST_PP_ITERATION BOOST_PP_ITERATION_DEPTH 
syn keyword cppBoostPP BOOST_PP_ITERATION_FINISH BOOST_PP_ITERATION_FLAGS BOOST_PP_ITERATION_LIMITS BOOST_PP_ITERATION_PARAMS_1 BOOST_PP_ITERATION_PARAMS_2 BOOST_PP_ITERATION_PARAMS_3 BOOST_PP_ITERATION_PARAMS_4 BOOST_PP_ITERATION_PARAMS_5 BOOST_PP_ITERATION_START  
syn keyword cppBoostPP BOOST_PP_LESS BOOST_PP_LESS_D BOOST_PP_LESS_EQUAL BOOST_PP_LESS_EQUAL_D BOOST_PP_LIMIT_DIM BOOST_PP_LIMIT_FOR BOOST_PP_LIMIT_ITERATION BOOST_PP_LIMIT_ITERATION_DIM BOOST_PP_LIMIT_MAG 
syn keyword cppBoostPP BOOST_PP_LIMIT_REPEAT BOOST_PP_LIMIT_SEQ BOOST_PP_LIMIT_SLOT_COUNT BOOST_PP_LIMIT_SLOT_SIG BOOST_PP_LIMIT_TUPLE BOOST_PP_LIMIT_WHILE BOOST_PP_LINE BOOST_PP_LIST_APPEND BOOST_PP_LIST_APPEND_D 
syn keyword cppBoostPP BOOST_PP_LIST_AT BOOST_PP_LIST_AT_D BOOST_PP_LIST_CAT BOOST_PP_LIST_CAT_D BOOST_PP_LIST_CONS BOOST_PP_LIST_ENUM BOOST_PP_LIST_ENUM_R BOOST_PP_LIST_FILTER BOOST_PP_LIST_FILTER_D 
syn keyword cppBoostPP BOOST_PP_LIST_FIRST BOOST_PP_LIST_FIRST_N BOOST_PP_LIST_FIRST_N_D BOOST_PP_LIST_FOLD_LEFT BOOST_PP_LIST_FOLD_LEFT_2ND BOOST_PP_LIST_FOLD_LEFT_2ND_D BOOST_PP_LIST_FOLD_LEFT_ BOOST_PP_LIST_FOLD_LEFT_D BOOST_PP_LIST_FOLD_RIGHT 
syn keyword cppBoostPP BOOST_PP_LIST_FOLD_RIGHT_2ND BOOST_PP_LIST_FOLD_RIGHT_2ND_D BOOST_PP_LIST_FOLD_RIGHT_ BOOST_PP_LIST_FOLD_RIGHT_D BOOST_PP_LIST_FOR_EACH BOOST_PP_LIST_FOR_EACH_I BOOST_PP_LIST_FOR_EACH_I_R BOOST_PP_LIST_FOR_EACH_PRODUCT BOOST_PP_LIST_FOR_EACH_PRODUCT_R 
syn keyword cppBoostPP BOOST_PP_LIST_FOR_EACH_R BOOST_PP_LIST_IS_CONS BOOST_PP_LIST_IS_NIL BOOST_PP_LIST_NIL BOOST_PP_LIST_REST BOOST_PP_LIST_REST_N BOOST_PP_LIST_REST_N_D BOOST_PP_LIST_REVERSE BOOST_PP_LIST_REVERSE_D 
syn keyword cppBoostPP BOOST_PP_LIST_SIZE BOOST_PP_LIST_SIZE_D BOOST_PP_LIST_TO_TUPLE BOOST_PP_LIST_TO_TUPLE_R BOOST_PP_LIST_TRANSFORM BOOST_PP_LIST_TRANSFORM_D BOOST_PP_LOCAL_ITERATE BOOST_PP_LOCAL_LIMITS BOOST_PP_LOCAL_MACRO 
syn keyword cppBoostPP BOOST_PP_LPAREN BOOST_PP_LPAREN_IF  BOOST_PP_MAX BOOST_PP_MAX_D BOOST_PP_MIN BOOST_PP_MIN_D BOOST_PP_MOD BOOST_PP_MOD_D BOOST_PP_MUL 
syn keyword cppBoostPP BOOST_PP_MUL_D  BOOST_PP_NIL BOOST_PP_NOR BOOST_PP_NOT BOOST_PP_NOT_EQUAL BOOST_PP_NOT_EQUAL_D  BOOST_PP_OR  BOOST_PP_RELATIVE_FINISH BOOST_PP_RELATIVE_FLAGS 
syn keyword cppBoostPP BOOST_PP_RELATIVE_ITERATION BOOST_PP_RELATIVE_START BOOST_PP_REPEAT BOOST_PP_REPEAT_1ST BOOST_PP_REPEAT_2ND BOOST_PP_REPEAT_3RD BOOST_PP_REPEAT_FROM_TO BOOST_PP_REPEAT_FROM_TO_1ST BOOST_PP_REPEAT_FROM_TO_2ND 
syn keyword cppBoostPP BOOST_PP_REPEAT_FROM_TO_3RD BOOST_PP_REPEAT_FROM_TO_D BOOST_PP_REPEAT_FROM_TO_D_ BOOST_PP_REPEAT_FROM_TO_ BOOST_PP_REPEAT_ BOOST_PP_RPAREN BOOST_PP_RPAREN_IF  BOOST_PP_SEQ_CAT BOOST_PP_SEQ_CAT_S 
syn keyword cppBoostPP BOOST_PP_SEQ_ELEM BOOST_PP_SEQ_ENUM BOOST_PP_SEQ_FILTER BOOST_PP_SEQ_FILTER_S BOOST_PP_SEQ_FIRST_N BOOST_PP_SEQ_FOLD_LEFT BOOST_PP_SEQ_FOLD_LEFT_ BOOST_PP_SEQ_FOLD_RIGHT BOOST_PP_SEQ_FOLD_RIGHT_ 
syn keyword cppBoostPP BOOST_PP_SEQ_FOR_EACH BOOST_PP_SEQ_FOR_EACH_I BOOST_PP_SEQ_FOR_EACH_I_R BOOST_PP_SEQ_FOR_EACH_PRODUCT BOOST_PP_SEQ_FOR_EACH_PRODUCT_R BOOST_PP_SEQ_FOR_EACH_R BOOST_PP_SEQ_HEAD BOOST_PP_SEQ_INSERT BOOST_PP_SEQ_NIL 
syn keyword cppBoostPP BOOST_PP_SEQ_POP_BACK BOOST_PP_SEQ_POP_FRONT BOOST_PP_SEQ_PUSH_BACK BOOST_PP_SEQ_PUSH_FRONT BOOST_PP_SEQ_REMOVE BOOST_PP_SEQ_REPLACE BOOST_PP_SEQ_REST_N BOOST_PP_SEQ_REVERSE BOOST_PP_SEQ_REVERSE_S 
syn keyword cppBoostPP BOOST_PP_SEQ_SIZE BOOST_PP_SEQ_SUBSEQ BOOST_PP_SEQ_TAIL BOOST_PP_SEQ_TO_ARRAY BOOST_PP_SEQ_TO_TUPLE BOOST_PP_SEQ_TRANSFORM BOOST_PP_SEQ_TRANSFORM_S BOOST_PP_SLOT BOOST_PP_STRINGIZE 
syn keyword cppBoostPP BOOST_PP_SUB BOOST_PP_SUB_D  BOOST_PP_TUPLE_EAT BOOST_PP_TUPLE_ELEM BOOST_PP_TUPLE_REM BOOST_PP_TUPLE_REM_CTOR BOOST_PP_TUPLE_REVERSE BOOST_PP_TUPLE_TO_LIST BOOST_PP_TUPLE_TO_SEQ  
syn keyword cppBoostPP BOOST_PP_VALUE  BOOST_PP_WHILE BOOST_PP_WHILE_ BOOST_PP_WSTRINGIZE  BOOST_PP_XOR

syn match cppBoostPP /#.*BOOST_PP_IS_ITERATING.*$/
syn match cppBoostPP /#.*BOOST_PP_ITERATE\>.*$/

hi def link cppBoostPP WarningMsg

"--------------------------------------------------
" color C++0x null pointer token
"--------------------------------------------------
syn keyword cppNull nullptr

hi def link cppNull Constant


" expand \\\ to the start of a documentation section
"
iabbr \\\ /**<CR>/<Left>*<C-O>O<BS>

"    vim:tw=75 et ts=4 sw=4 sr ai comments=\:\" formatoptions=croq 
"
"---------[ END OF FILE cpp.vim ]----------------------------------------------
