

module SportDb
class Lexer


##
#  keep 18h30 - why? why not?
#    add support for 6:30pm 8:20am etc. - why? why not?
#
#    check - only support h e.g. 18h30  or 18H30 too - why? why not?
# e.g. 18.30 (or 18:30 or 18h30)
#   note - optional timezone possible e.g.
#        18.30 (UTC+1)  or 18.30 (BST/UTC+1)  or such!!!
TIME_RE = %r{
    (?<time>  \b
        (?:   (?<hour>\d{1,2})
                   [:.h] 
              (?<minute>\d{2}))
                  \b       ## can use word boundry assert inline here?
              (?:
                  ## require space - why? why not
                   [ ]
                    \(
                      (?<timezone>
                         ## optional "local" timezone name eg. BRT or CEST etc.
                          (?:  [a-z]+
                                 /
                           )?
                            [a-z]+
                            [+-]
                            \d{1,4}   ## e.g. 0 or 00 or 0000
                      )
                    \)
              )?
    )
}ix


##    local time e.g (19.30 UTC+1) or (19.30 BSC/UTC+1) or 
##   note - timezone is optional!  e.g. (19.30) works too
TIME_LOCAL_RE = %r{
    (?<time_local>   \(
        (?:   (?<hour>\d{1,2})
                   [:.h]
              (?<minute>\d{2}))
                (?:
                    [ ]
                 (?<timezone>
                   ## optional "local" timezone name eg. BRT or CEST etc.
                    (?:  [a-z]+
                       /
                    )?
                   [a-z]+
                   [+-]
                   \d{1,4}   ## e.g. 0 or 00 or 0000
                 )
              )?  # note - make timezone  optional!!!
      \)
    )
}ix




BASICS_RE = %r{
    ## e.g. (51) or (1) etc.  - limit digits of number???
    ##  todo/fix - change num  to ord (for ordinal number)!!!!!
    (?<num> \(  (?<value>\d+) \) )
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
    (?<sym>  (?<=^|[ ])  ## positive lookahead 
                  (?: ----|
                      ---|
                      --
                  )
             (?=[ ])   ## positive lookahead
    )
        |
    (?<sym> [;,/@|\[\]-] )
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



RE = Regexp.union(
                    STATUS_RE,   ## match status e.g. [cancelled], etc.
                    INLINE_WO_RE,   ## (inline) match status - w/o (walkout)
                    INLINE_BYE_RE,  ## (inline) match status - bye (advance to next round)
                    SCORE_NOTE_RE,
                    NOTE_RE,
                    DURATION_RE,  # note - duration MUST match before date
                    DATE_LEGS_RE,  # note - must go before date!!!
                    DATE_RE,  ## note - date must go before time (e.g. 12.12. vs 12.12)
                     TIME_RE,
                     TIME_LOCAL_RE,
                    ATTENDANCE_RE,   # note - allow att: for now inline in matches too - why? why not? 
                    SCORE_LEGS_RE,
                    SCORE_FULL_RE, 
                    SCORE_FULLER_RE,
                    SCORE_FULLER_MORE_RE,
                    SCORE_RE,   ## note basic score e.g. 1-1 must go after SCORE_FULL_RE!!!
                    BASICS_RE, 
                   TEXT_RE,
                   ANY_RE,
                      )


####
# 
##  note - use \A (instead of ^) - \A strictly matches the start of the string.
ROUND_OUTLINE_RE = %r{   \A
                           [ ]*  ## ignore leading spaces (if any)
                         (?: [▪▸»]|>> )    ## BLACK SMALL SQUARE, BLACK RIGHT-POINTING SMALL TRIANGLE  
                           [ ]+
                            (?<round_outline>
                               ## must start with letter - why? why not?
                               ###   1st round
                               ##  allow numbers e.g. Group A - 1 
                               .+?   ## use non-greedy 
                            )
                           [ ]*  ## ignore trailing spaces (if any) 
                         $
                       }ix



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
