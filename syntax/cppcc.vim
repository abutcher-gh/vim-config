
if exists("b:current_syntax")
   finish
endif

runtime! syntax/cpp.vim
unlet b:current_syntax

" to be moved to their own section like PARSER
syn keyword cppccKeyword OPTIONS SCANNER

syn keyword cppccScannerBuiltins getInputStream pushStream popStream
syn keyword cppccScannerBuiltins getChar unGetChars unGetChar
syn keyword cppccScannerBuiltins la consume setMarker lookingAhead
syn keyword cppccScannerBuiltins getCurrentPos resetPos newLine
syn keyword cppccScannerBuiltins switchToState getState pushState
syn keyword cppccScannerBuiltins popState tPos resetPos newLine
syn keyword cppccScannerBuiltins rejectToken

syn keyword cppccParserDeclKeywords contained throw

syn keyword cppccKeyword MORE SKIP TOKEN KEYWORD LOOKAHEAD
syn keyword cppccOption PROVIDE_TOKEN_NAMES DEBUG_SCANNER DEBUG_PARSER CASE_SENSITIVE
syn keyword cppccOption CASE_SENSITIVE USE_EXCEPTIONS STRICT_EXCEPTIONS
syn keyword cppccOption DEFAULT_LOOKAHEAD
syn keyword cppccOption TOKENS_SPAN_EOF
syn keyword cppccOption COUNT_COLUMNS
syn keyword cppccOption SHARP_LINES
syn keyword cppccOption PROFILING_FILE
syn keyword cppccOption STRING_CLASS
syn keyword cppccOption NAMESPACE_NAME
syn keyword cppccOption SRC_EXTENSION
syn keyword cppccOption HDR_EXTENSION

syn region cppccReduction matchgroup=cppccScopeBrackets start=/<[^\t :]*:/rs=s+1 end=/>/re=e-1 contains=cppccReductionArgument nextgroup=cppccScope
syn region cppccReductionArgument contained start=/[^:]:[^:]/ms=s+2 end=/>/me=e-1 contains=@cppccReductionCluster

syn cluster cppccReductionCluster contains=cppccReductionSymbol,cppccRange,cppccChar,cppccString,cppccReductionParen,cComment

syn match cppccReductionSymbol /<[^:>]*>/ nextgroup=cppccScope
syn match cppccDefineReductionSymbol /^<[^:>]*>/ nextgroup=cppccScope
syn region cppccReductionParen matchgroup=cppccScopeBrackets start=/(/rs=s+1 end=/)/re=e-1 contains=@cppccReductionCluster,cComment transparent
syn region cppccString contained start=/"/ skip=/\\"/ end=/"/ contains=cppccEscapeChar

syn region cppccChar contained start=/'/ end=/'/ contains=cppccEscapeChar
syn match cppccEscapeChar contained /\\./
syn match cppccRangeDelims contained "[,=\-?*]"

syn match cppccSpecial /SPECIAL/ nextgroup=cppccScope

syn match cppccParserHead /\<PARSER\>[\t ]*[0-9_A-Za-z]*/he=s+6 nextgroup=cppccParserScope skipwhite skipempty
syn region cppccParserScope matchgroup=cppccParserScopeBrackets start=/{/ end=/}/ contains=cppccProductionStart,cComment,cCommentL,cppccCPlusPlus
syn match cppccProductionStart contained /(.*\n.*{/me=e-1 contains=cppccParserDeclKeywords,cppccProductionType,cppccProductionName,cComment nextgroup=cppccProductionReductions skipwhite skipempty

syn region cppccProductionType contained start=/(/ end=/)/ contains=cParen keepend
syn region cppccProductionReductions matchgroup=cppccProductionBrackets contained start=/{/rs=s+1 end=/}/re=e-1 contains=cppccCPlusPlus,cppccKeyword,cppccProductionReduction,cppccRangeDelims,cComment,cCommentL,cppccProductionParens,cppccProductionFunctionCall
syn match cppccProductionReduction contained /<[^>]*>/
syn region cppccProductionParens matchgroup=cppccProductionParenBrackets contained start=/(/ end=/)/ contains=cppccCPlusPlus,cppccKeyword,cppccProductionReduction,cppccRangeDelims,cComment,cCommentL,cppccProductionParens,cppccProductionFunctionCall,cppNumber,cppBoolean,cNumbers,cString
syn match cppccProductionFunctionCall contained /([ \t]*)/
syn region cppccCPlusPlus matchgroup=cppccProductionCode contained start=/{/ end=/}/ contains=cppccCPlusPlus,cDefine,cPreCondit,cCppOut,cKeyword,cppOperator,cBitField,cppCast,cppStructure,cStructure,cppBoolean,cppNumber,cNumbers,cStorageClass,cStatement,cType,cppType,cppStatement,cppExceptions,cLabel,cConditional,cRepeat,cType,cComment,cCommentL,cSpecial,cString,cFormat,cCharacter,cSpecialCharacter,cppAccess

highlight link cppccParserDeclKeywords Keyword
highlight link cppccScannerBuiltins Function

highlight link cppccParserHead Keyword
highlight link cppccParserScopeBrackets Keyword
highlight link cppccProductionType Normal
highlight link cppccProductionReductions Normal
highlight link cppccProductionBrackets LineNr
highlight link cppccProductionReduction PreProc
highlight link cppccProductionFunctionCall Normal
highlight link cppccProductionParenBrackets LineNr
highlight link cppccProductionCode PreProc
highlight link cppccCPlusPlus Normal

highlight link cppccKeyword Keyword
highlight link cppccOption Keyword
highlight link cppccSpecial Keyword

highlight link cppccChar PreProc
highlight link cppccEscapeChar StorageClass
highlight link cppccString PreProc

highlight link cppccDefineReductionSymbol StorageClass
highlight link cppccReductionSymbol PreProc
highlight link cppccReduction StorageClass

highlight link cppccReductionArgument LineNr
highlight link cppccRangeDelims LineNr

highlight link cppccInternalAngles Function

highlight link cppccRangeBrackets LineNr
highlight link cppccScopeBrackets Function

syn region cppccRange matchgroup=cppccRangeBrackets start=/\[/rs=s+1 end=/\]/re=e-1 contains=cppccString,cppccChar,cppccRangeDelims

syn region cppccScope matchgroup=cppccScopeBrackets start=/{/rs=s+1 end=/}/re=e-1 contains=TOP transparent

syn region cppccParen matchgroup=cppccScopeBrackets start=/(/rs=s+1 end=/)/re=e-1 contains=TOP transparent

let b:current_syntax = "cppcc"

syntax sync linebreaks=1
syntax sync fromstart


