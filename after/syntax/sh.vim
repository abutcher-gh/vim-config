# When spell is enabled, check in HERE docs using EOT, EOH or USAGE.
syn region shHereDoc matchgroup=shHereDoc01 start="<<\s*\z(EO[HT]\|USAGE\)"     matchgroup=shHereDoc01 end="^\z1\s*$"      contains=@shDblQuoteList,@Spell
syn region shHereDoc matchgroup=shHereDoc02 start="<<-\s*\z(EO[HT]\|USAGE\)"    matchgroup=shHereDoc02 end="^\s*\z1\s*$"   contains=@shDblQuoteList,@Spell
syn region shHereDoc matchgroup=shHereDoc05 start="<<\s*'\z(EO[HT]\|USAGE\)'"   matchgroup=shHereDoc05 end="^\z1\s*$"      contains=@Spell
syn region shHereDoc matchgroup=shHereDoc06 start="<<-\s*'\z(EO[HT]\|USAGE\)'"  matchgroup=shHereDoc06 end="^\s*\z1\s*$"   contains=@Spell
