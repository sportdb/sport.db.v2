module SportDb
class Lexer


###
#   check for start of group def line e.g.
#       Group A  | ...
#       Group 1  : ....
#       Group A2 | ....
##  note - use \A (instead of ^) - \A strictly matches the start of the string.
GROUP_DEF_LINE_RE =  %r{  \A
                     [ ]*  ## ignore leading spaces (if any)
                     (?<group_def>
                         Group
                          [ ]
                          [a-z0-9]+   ## todo/check - allow dot (.) too e.g. 1.A etc.- why? why not?         
                     )
                     ###   possitive lookahead MUST be : OR | 
                     (?= [ ]*
                         [:|] 
                         [ ])  ## note: requires space for now after [:|] - keep - why? why not?	
                  }ix 

GROUP_DEF_BASICS_RE = %r{
    (?<spaces> [ ]{2,}) |
    (?<space>  [ ])
        |
    (?<sym> [:|,] )    ### note - add comma (,) as optional separator  
}ix


GROUP_DEF_RE = Regexp.union(  GROUP_DEF_BASICS_RE, 
                              TEXT_RE,
                              ANY_RE,
                           )
      
     


    

end  #   class Lexer
end  # module SportDb
