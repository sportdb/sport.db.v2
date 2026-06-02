module SportDb
class Lexer


###
##
##  add support for score awarded (inline style)
##    3-0 awd  3-0 awd. 3-0awd
##    0-1 awd  or 0-1 AWD etc.

##
##   note - keep AWD w/o dot - why? why not?

SCORE_AWD_RE  = %r{
            (?<score_awd>
              \b
               (?<score1>\d{1,2}) - (?<score2>\d{1,2})
                 [ ]?
                   (?-i: awd\.? | AWD )
               ## POSITIVE lookahead - requires space
               (?= [ ])
             )}ix

###
##
##  add support for score abandoned (inline style)
##       2-1 abd.   or 2-1 ABD
SCORE_ABD_RE  = %r{
            (?<score_abd>
              \b
               (?<score1>\d{1,2}) - (?<score2>\d{1,2})
                 [ ]?
                  (?-i: abd\.? | ABD )
               ## POSITIVE lookahead - requires space
               (?= [ ])
             )}ix

#####
##      2-1
###
###  note - was SCORE__FT__RE
###           changed to "generic" SCORE_RE
###                and
##             (?<ft1>\d{1,2}) - (?<ft2>\d{1,2})
##      changed
##             (?<score1>\d{1,2}) - (?<score2>\d{1,2})
##                to
##             pattern match not necessarily the full-time (ft) scoreline!!!
##    - pattern also used for goal seq(uence) e.g. 1-0 Kane, 1-1 Johnson
SCORE_RE  = %r{
            (?<score>
              \b
               (?<score1>\d{1,2}) - (?<score2>\d{1,2})
              \b
             )}ix



end # class Lexer
end # module SportDb
