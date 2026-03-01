

module SportDb
class Lexer



BASICS_RE = %r{
    ## e.g. (51) or (1) etc.  - limit digits of number - why? why not???
    ##  ord (for ordinal number)
    (?<ord> \(  (?<value>\d+) \) )
       |
    (?<vs>
       (?<=[ ])	# positive lookbehind for space
       (?-i: 
         vs|v 
       )        # note - only match case sensitive (downcased letters)!!!
                # note -  bigger match first e.g. vs than v etc.
       (?=[ ])   # positive lookahead for space
    )
       |
    (?<spaces> [ ]{2,}) |
    (?<space>  [ ])
        |
    (?<sym> [,;/@|()\[\]-] )   ### note: add parantheses too e.g () - why? why not?
}ix



###
## add att(endance) e.g.  att: 18000
##
##    A v B 2-1  att: 18000

ATTENDANCE_RE = %r{
    (?<attendance>
     \b
        att: [ ]*
         (?<value>
              [1-9]
              (?: _? \d+ )*
         )
     \b
)}ix


## "inline" match status e.g.
##  Clapham Rovers     w/o  Hitchin            
##  Queen's Park       bye
         
INLINE_WO_RE = %r{
                   (?<inline_wo>
                       \b w/o \b
               )}x   ## add support for upcase W/O or W-0 too - why? why not?

INLINE_BYE_RE = %r{ 
                  (?<inline_bye>
                      \b bye \b
               )}x   ## add support for upcase BYE - why? why not?


###
#   A n/p  B    (note - basically a inline short form of  A v B [cancelled] )
INLINE_NP_RE = %r{
                   (?<inline_np>
                       \b n/p \b
               )}x   ## add support for upcase N/P too - why? why not?


###
#  abd/abd.   [abandoned]
INLINE_ABD_RE = %r{
                   (?<inline_abd>
                       \b abd\.? 
                  ## POSITIVE lookahead - requires space
                         (?= [ ])
               )}x


## "top-level" regex used for:
##    - date_header
##    - match_header & match_line_more
##    - match_line


RE = Regexp.union(
                    STATUS_RE,   ## match status e.g. [cancelled], etc.
                    INLINE_WO_RE,   ## (inline) match status - w/o (walkout)
                    INLINE_NP_RE,   ## (inline) match status - n/p (not played)
                    INLINE_BYE_RE,  ## (inline) match status - bye (advance to next round)
                    INLINE_ABD_RE,  ## (inline) match status - abd/abd. (abandoned)
                    NOTE_RE,  ### fix - change to INLINE_NOTE !!!
                    DATE_LEGS_RE,  # note - must go before date!!!
                    DATE_RE,  ## note - date must go before time (e.g. 12.12. vs 12.12)
                     TIME_RE,
                     TIME_LOCAL_RE,
                    ATTENDANCE_RE,   # note - allow att: for now inline in matches too - why? why not? 
                    SCORE_LEGS_RE,
                    SCORE_FULL_RE, 
                    SCORE_FULLER_RE,
                    SCORE_FULLER_MORE_RE,
                    SCORE_AWD_RE,   #  (inline) score awarded e.g. 3-0 awd or 0-1 awd. etc.
                    SCORE_RE,   ## note basic score e.g. 1-1 must go after SCORE_FULL_RE!!!
                    BASICS_RE, 
                   TEXT_RE,
                   ANY_RE,
                      )



###
## check for headings 
##    e.g.  = heading 1
##          == heading 2  etc.
##          =Eurochampionship=
##    note  -  no spaces required (same as in wikipedia!!)
##             same as in wikipedia support six (6) levels
##
##  note - use \A (instead of ^) - \A strictly matches the start of the string.


HEADING_RE = %r{   \A
                           [ ]*  ## ignore leading spaces (if any)
                         (?<heading_marker> ={1,6} ) 
                           [ ]*
                            (?<heading>
                               ## must start with letter - why? why not?
                               ###   1st round
                               ##  allow numbers e.g. Group A - 1 
                               [^=]+?   ## use non-greedy 
                            )
                           [ ]*  ## ignore trailing spaces (if any)
                            (?: =* )  ## allow any trailing heading markers
                           [ ]*  ## ignore trailing spaces (if any)
                         \z
                       }ix


end  # class Lexer
end # module SportDb
