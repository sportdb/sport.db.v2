

def self._mk_is( re )
    ##   add  \A ... \z to regex
    ##     for strict matching of beginning and end of string
    ##     regex note -  \z will NOT allow trailing newline(s)!!!!
    ##      note - must double espace \\A,\\z  in quoted string!!
    Regexp.new( %Q<   \\A
                    (?:#{re.source})
                       \\z
                  >, re.options )
end


  IS_TEAM_RE = _mk_is( TEXT_RE )   ## todo/fix - rename TEXT_RE to TEAM_RE!!!
  IS_DATE_RE = _mk_is( DATE_IIII_RE )    ## DATE_RE )
