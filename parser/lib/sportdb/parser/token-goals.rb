module SportDb
class Lexer


######################################################
## goal mode (switched to by PLAYER_WITH_MINUTE_RE)  
##
##  note - must be enclosed in ()!!! 
##          todo - add () in basics - why? why not?

GOAL_BASICS_RE = %r{
    (?<spaces> [ ]{2,}) |
    (?<space>  [ ])
        |
    (?<sym>  
        [;,)]   ## add (-) dash too - why? why not?   
    )   
}ix


## note - assume lines starting with opening ( are goal lines!!!!
##  note - use \A (instead of ^) - \A strictly matches the start of the string.
GOAL_LINE_RE = %r{
                     \A\(
                 }x

GOAL_NONE_RE = %r{ (?<goals_none>
                        -[ ]*;
                    )
                 }x



##   goal types
# (pen.) or (pen) or (p.) or (p)
## (o.g.) or (og)
##   todo/check - keep case-insensitive 
##                   or allow OG or P or PEN or
##                   only lower case - why? why not?


GOAL_MINUTE_RE = %r{
     (?<goal_minute>
       (?<=[ (])	 # positive lookbehind for space or opening ( e.g. (61') required
                     #    todo - add more lookbehinds e.g.  ,) etc. - why? why not?
             (?<value>\d{1,3})      ## constrain numbers to 0 to 999!!!
                (?:
                     ## with minute marker inline
                     (?:
                         '?    ## optional minute marker
                         (?: \+
                            (?<value2>\d{1,3})   
                         )?          
                     )
                     |
                     (?:
                         (?: \+
                            (?<value2>\d{1,3})   
                         )?          
                         '  ## "old-style/legacy" minute marker at the end e.g. 45+1'
                            ##    use 45'+1 (or 45+1) instead!!!                
                     )
                )   
        ## note - add goal minute qualifiers here inline!!! 
        (?:
            (?: [ ]? (?<og>   (?: \((?:og|o\.g\.)\))   ## allow (og)
                                   |
                              (?: (?:og|o\.g\.))      ## allow plain og
                      )
            )
            |
            (?: [ ]? (?<pen>  (?: \((?:pen|p)\.?\))   ## allow ()
                                   |
                              (?: (?:pen|p)\.?)
                      )    
            )
        )?
     )
     ## note - check lookahead here
     (?=[ ,;)]|$)   
}ix






GOAL_RE = Regexp.union(
    GOAL_BASICS_RE,
    GOAL_NONE_RE,
    GOAL_MINUTE_RE,
   ## MINUTE_NA_RE,   ## note - add/allow not/available (n/a,na) minutes hack for now
   ## GOAL_OG_RE, GOAL_PEN_RE,
   ## SCORE_RE,  ## add back in v2 (level 3) or such!!
    PROP_NAME_RE,    ## note - (re)use prop name for now for (player) name
)

=begin
## note - leave out n/a minute in goals - make minutes optional!!!
PROP_GOAL_RE =  Regexp.union(
    GOAL_BASICS_RE,
    MINUTE_RE,
   ## MINUTE_NA_RE,   ## note - add/allow not/available (n/a,na) minutes hack for now
    GOAL_OG_RE, GOAL_PEN_RE,
    SCORE_RE,
    PROP_NAME_RE,    ## note - (re)use prop name for now for (player) name
)
=end

    
end  # class Lexer
end # module SportDb
