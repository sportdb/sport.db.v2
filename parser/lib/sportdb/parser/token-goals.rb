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
        [;,)]   ##  add (-) dash too - why? why not?   
    )   
}ix


## note - assume lines starting with opening ( are goal lines!!!!
##  note - use \A (instead of ^) - \A strictly matches the start of the string.
##
##   note -  check for negative lookahead
##                 to exclude ord (numbers) e.g.  (1), (42), etc.!!!
GOAL_LINE_RE = %r{
                     \A\(
                       (?! \d+ \))	 # negative lookahead	
                 }x


###
##  e.g.  (-; Metzger)
GOAL_NONE_RE = %r{ (?<goals_none>
                        -[ ]*;
                    )
                 }x

###
#  note - alternate goal separator dash (-) MUST have leading and trailing space!!!
#    e.g.   (Metzger 83 - Krämer 29, 88, Cichy 33, Rahn 37)
#    e.g.   (Metzger - Krämer (2), Cichy, Rahn)
#            (Brunnenmeier 17 - Gerwien 74)
#            (Brunnenmeier - Gerwien)
#    that is,  NOT allowed  
#    e.g.   (Metzger 83-Krämer 29, 88, Cichy 33, Rahn 37)
#            (Brunnenmeier 17-Gerwien 74)
#            (Brunnenmeier-Gerwien) 

GOAL_SEP_ALT_RE = %r{
          (?<goal_sep_alt>
              (?<=[ ])   ## positive lookbehind - space required
              -
              (?=[ ])    ## positive lookahead - speace required
             )}x


## e.g.  (2)
##       (2/p), (2/pen.), (3/2p), (3/2 pen.)  
##       (p), (pen.) (2 pen.), (2p)               
##       (og), (o.g.), (2og), (2 o.g.)
##
##  note - start counting at 2 for penalties and own goals!!!
##                 no 0/1 possible for now

GOAL_COUNT_RE = %r{
   (?<goal_count>
      \(
        (?:
          ## opt penalties
            (?<pen>
              (?:  (?<pen_value> [2-9]) [ ]? )?
                 (?:pen|p)\.?
           )
            |
          ## opt own goals (og)
            (?<og>
             (?: (?<og_value> [2-9]) [ ]? )?
                (?:og|o\.g\.) 
            )          
            |
          ## opt fallback - classic count/number
          (?:  (?<value> [1-9])
                ## check for option penalties
                (?<pen>
                     /
                     (?: (?<pen_value> [2-9]) [ ]? )?
                     (?:pen|p)\.?
                )?
           )
         )  
      \)
)}ix


##   goal types
# (pen.) or (pen) or (p.) or (p)
## (o.g.) or (og)
##   todo/check - keep case-insensitive 
##                   or allow OG or P or PEN or
##                   only lower case - why? why not?
##
##  add (gg) for golden goal - why? why not?
##  add (sg) for silver goal - why? why not??

GOAL_MINUTE_RE = %r{
     (?<goal_minute>
       (?<=[ ,(])	 # positive lookbehind for space or opening ( e.g. (61')
                     #                             or [Messi] 21,37,42,88 required
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
    GOAL_COUNT_RE,
   ## MINUTE_NA_RE,   ## note - add/allow not/available (n/a,na) minutes hack for now
   ## GOAL_OG_RE, GOAL_PEN_RE,
   ## SCORE_RE,  ## add back in v2 (level 3) or such!!
    PROP_NAME_RE,    ## note - (re)use prop name for now for (player) name
    GOAL_SEP_ALT_RE,
    ## todo/fix - add GOAL_ANY_RE !!!!
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
