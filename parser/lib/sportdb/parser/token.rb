

module SportDb
class Lexer



BASICS_RE = %r{
    (?<vs>
       (?<=[ ])	# positive lookbehind for space
       (?-i: 
           vs\.?|v 
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
         
## add support for WO or W-0 too - why? why not?
INLINE_WO_RE = %r{
                   (?<inline_wo>
                       \b (?: w/o | W/O ) \b
               )}x   ## note - NOT case insensitive 

INLINE_BYE_RE = %r{ 
                  (?<inline_bye>
                      \b (?: bye | BYE ) \b
               )}x   ## note - NOT case insensitive 


###
#   A n/p  B    (note - basically a inline short form of  A v B [cancelled] )
#     N/P
INLINE_NP_RE = %r{
                   (?<inline_np>
                       \b (?: n/p | N/P ) \b
               )}x   ## note - NOT case insensitive 


###
#  abd/abd. or aban/aban.  [abandoned]
#  ABD/ABAN
INLINE_ABD_RE = %r{
                   (?<inline_abd>
                       \b (?: abd\.? |
                              aban\.? |
                              ABD | ABAN
                          ) 
                  ## POSITIVE lookahead - requires space
                         (?= [ ])
               )}x  ## note - NOT case insensitive 

####
#  susp/susp.  [suspended]
#   SUSP
INLINE_SUSP_RE = %r{
                   (?<inline_susp>
                       \b (?: susp\.? |
                               SUSP ) 
                  ## POSITIVE lookahead - requires space
                         (?= [ ])
               )}x  ## note - NOT case insensitive 


####
# ppd/ppd. or pstp/pstp. or postp/postp.   [postponed] 
#  PPD/PSTP/POSTP/P-P              
#   todo/check - add/allow p-p too - why? why not?
INLINE_PPD_RE = %r{
                   (?<inline_ppd>
                       \b (?: ppd\.? |
                              po?stp\.? |
                              PPD | PO?STP | P-P
                           ) 
                  ## POSITIVE lookahead - requires space
                         (?= [ ])
               )}x   ## note - NOT case insensitive 

####
#  void via   x-x X-X
#     todo/check - only allow X-X - why? why not?
INLINE_VOID_RE = %r{
                      (?<inline_void>
                          \b (?: x-x |
                                 X-X 
                             )
                        ## POSITIVE lookahead - requires space
                           (?= [ ])
                )}x ## note - NOT case insensitive


####
#  awd/awd.                [awarded]
#   AWD
#   note - recommendation is to allways include score
#            thus, use/prefer SCORE_AWD e.g. 0-3 awd
INLINE_AWD_RE =  %r{
                   (?<inline_awd>
                       \b (?: awd\.? | AWD ) 
                  ## POSITIVE lookahead - requires space
                         (?= [ ])
               )}x   ## note - NOT case insensitive 

###
#  canc/canc.           [cancelled]
#    CANC
INLINE_CANC_RE =  %r{
                   (?<inline_canc>
                       \b (?: canc\.?  | CANC ) 
                  ## POSITIVE lookahead - requires space
                         (?= [ ])
               )}x   ## note - NOT case insensitive 


###
##   home/away/neutral  - (h), (a), (n)
##    add support for h/a/n  
##       with (?-i \b [han] \b) lower-case and \b boundry - why? why not?

TEAM_HOME_RE     = %r{  (?<team_home> \(h\) )}xi
TEAM_AWAY_RE     = %r{  (?<team_away> \(a\)  )}xi
TEAM_NEUTRAL_RE  = %r{  (?<team_neutral> \(n\) )}xi



## "top-level" regex used for:
##    - date_header
##    - match_header & match_line_more
##    - match_line


RE = Regexp.union(
                    STATUS_RE,   ## match status e.g. [cancelled], etc.

                    INLINE_WO_RE,    ## (inline) match status - w/o (walkout)
                    INLINE_NP_RE,    ## (inline) match status - n/p (not played)
                    INLINE_BYE_RE,   ## (inline) match status - bye (advance to next round)
                    INLINE_ABD_RE,   ## (inline) match status - abd/abd. (abandoned)
                    INLINE_SUSP_RE,  ## (inline) match status - susp/susp.  (suspended)
                    INLINE_PPD_RE,   ## (inline) match status - ppd/ppd. or pstp/pstp. or postp/postp. or p-p (postponed)            
                    INLINE_VOID_RE,  ## (inline) match status - x-x (voided) 
                    INLINE_AWD_RE,   ## (inline) match status - awd/awd. (awarded)
                    INLINE_CANC_RE,  ## (inline) match status - canc/canc. (cancelled/canceled)
                   

                    TEAM_HOME_RE,     ## (H)
                    TEAM_AWAY_RE,     ## (A)
                    TEAM_NEUTRAL_RE,  ## (N)

                    NOTE_RE,  ### fix - change to INLINE_NOTE !!!
                    DATE_LEGS_RE,  # note - must go before date!!!
                    DATE_RE,  ## note - date must go before time (e.g. 12.12. vs 12.12)
                     TIME_RE,
                    ATTENDANCE_RE,   # note - allow att: for now inline in matches too - why? why not? 
                    SCORE_LEGS_RE,
                    SCORE_FULL_RE, 
                    SCORE_FULLER_RE,
                    SCORE_FULLER_MORE_RE,
                    SCORE_AWD_RE,   #  (inline) score awarded e.g. 3-0 awd or 0-1 awd. etc.
                    SCORE_ABD_RE,   #  (inline) score abandoned e.g. 2-1 abd.
                    SCORE_RE,   ## note basic score e.g. 1-1 must go after SCORE_FULL_RE!!!
                    BASICS_RE, 
                   TEXT_RE,
                   ANY_RE,
                      )






##  ord (for ordinal number)
##   e.g. (51) or (1) etc.  - limit digits of number - why? why not???
 
START_WITH_ORD = %r{
   \A  
    [ ]*    ## ignore leading spaces (if any)
     (?<ord>
       \(  
        (?<value>\d+) 
       \)
     )}ix


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


HRULER_RE = %r{
                 \A
                           [ ]*  ## ignore leading spaces (if any)
                    -{3,}  ## must be at least three dashes!!!
                           [ ]*  ## ignore trailing spaces (if any)                   
                 \z
}ix

end  # class Lexer
end # module SportDb
