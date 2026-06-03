module SportDb
class Lexer


###
#   check for start of group def line e.g.
#       Group A  | ...
#       Group 1  : ....
#       Group A2 | ....
##  note - use \A (instead of ^) - \A strictly matches the start of the string.

START_WITH_GROUP_DEF_LINE_RE =  %r{
                     \A
                     [ ]*  ## ignore leading spaces (if any)
                     (?<group_def>
                         Group
                          [ ]
                          [a-z0-9]+   ## todo/check - allow dot (.) too e.g. 1.A etc.- why? why not?
                     )
                     ###   positive lookahead MUST be : OR |
                     (?= [ ]*
                         [:|]
                         [ ])  ## note: requires space for now after [:|] - keep - why? why not?
                  }ix



end  #   class Lexer
end  # module SportDb
