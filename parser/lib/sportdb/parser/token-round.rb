module SportDb
class Lexer

####
# 
##  note - use \A (instead of ^) - \A strictly matches the start of the string.
##
##  todo - add support for trailing markers e.g.
##    ▪ Round 1 ▪▪▪▪▪▪▪▪
##    :: Round 1 ::::::::::::
##
##  check - allow without space (like in heading =Heading 1=) - why? why not?
##    ▪Round 1▪▪▪▪▪▪▪▪
##    ::Round 1::::::::::::

ROUND_OUTLINE_I_RE = %r{   \A
                           [ ]*  ## ignore leading spaces (if any)
                         (?<round_marker>
                               [▪]{1,3}     ## BLACK SMALL SQUARE e.g. ▪,▪▪,▪▪▪
                          )     
                           [ ]+
                            (?<round_outline>
                               ## must start with letter - why? why not?
                               ###   1st round
                               ##  allow numbers e.g. Group A - 1 
                               ##   
                               ##  note - CANNOT incl. :| !!!
                               ##   used for markers for defs/definitions
                               [^:|]+?   ## use non-greedy 
                            )
                            (?:
                               [ ]+   
                               [▪]+
                            )?
                            [ ]*  ## ignore trailing spaces (if any) 
                          \z
                       }xi

ROUND_OUTLINE_II_RE =  %r{   \A
                           [ ]*  ## ignore leading spaces (if any)
                         (?<round_marker>
                                ::{1,3}     ## e.g. ::,:::,:::: 
                          )     
                           [ ]+
                            (?<round_outline>
                               ## must start with letter - why? why not?
                               ###   1st round
                               ##  allow numbers e.g. Group A - 1 
                               ##   
                               ##  note - CANNOT incl. :| !!!
                               ##   used for markers for defs/definitions
                               [^:|]+?   ## use non-greedy 
                            )
                            (?:
                               [ ]+   
                               ::+
                            )?
                           [ ]*  ## ignore trailing spaces (if any) 
                          \z
                       }xi

ROUND_OUTLINE_RE = Regexp.union(  ROUND_OUTLINE_I_RE,
                                  ROUND_OUTLINE_II_RE,
                               )


###
#  note -  for def(initions) only one level support 
#             that is, no round outline additions possible (e.g ▪▪ 1st leg etc.)
ROUND_DEF_OUTLINE_RE = %r{   \A
                           [ ]*  ## ignore leading spaces (if any)
                          (?: [▪]  ## BLACK SMALL SQUARE
                               |
                              :: )      
                           [ ]+
                            (?<round_outline>
                               [^:|]+?   ## use non-greedy 
                            )
                           [ ]*  ## ignore trailing spaces (if any) 
                          ###   possitive lookahead MUST be : OR | 
                           (?= [:|] 
                               [ ])  ## note: requires space for now after [:|] - keep - why? why not?	
                      }ix


ROUND_DEF_BASICS_RE = %r{
    (?<spaces> [ ]{2,}) |
    (?<space>  [ ])
        |
    (?<sym> [:|,] )    ### note - add comma (,) as optional separator  
}ix

ROUND_DEF_RE = Regexp.union(  ROUND_DEF_BASICS_RE, 
                              DURATION_RE,  # note - duration MUST match before date
                              DATE_RE,  ## note - date must go before time (e.g. 12.12. vs 12.12)
                              ANY_RE,
                           )
      


end  #   class Lexer
end  # module SportDb
