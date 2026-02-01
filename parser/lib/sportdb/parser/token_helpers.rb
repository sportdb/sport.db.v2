module SportDb
class Lexer



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



def self._parse_team( str )  
    ## note - strip - leading/trailing spaces
    m = IS_TEAM_RE.match( str.strip )
    m
end
   

end  #   class Lexer
end  # module SportDb
