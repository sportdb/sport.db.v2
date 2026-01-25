

module SportDb
class Lexer


##
#  keep 18h30 - why? why not?
#    add support for 6:30pm 8:20am etc. - why? why not?
#
#    check - only support h e.g. 18h30  or 18H30 too - why? why not?
# e.g. 18.30 (or 18:30 or 18h30)
TIME_RE = %r{
    (?<time>  \b
        (?:   (?<hour>\d{1,2})
                 (?: :|\.|h )
              (?<minute>\d{2})) 
              \b
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



RE = Regexp.union(
                    STATUS_RE,
                    SCORE_NOTE_RE,
                    NOTE_RE,
                    DURATION_RE,  # note - duration MUST match before date
                    DATE_RE,  ## note - date must go before time (e.g. 12.12. vs 12.12)
                     TIME_RE,
                    SCORE_MORE_RE, 
                    SCORE_RE,   ## note basic score e.g. 1-1 must go after SCORE_MORE_RE!!!
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

##  note - use \A (instead of ^) - \A strictly matches the start of the string.
HEADING_RE = %r{   \A
                           [ ]*  ## ignore leading spaces (if any)
                         (?<heading_marker> ={1,5} ) 
                           [ ]+
                            (?<heading>
                               ## must start with letter - why? why not?
                               ###   1st round
                               ##  allow numbers e.g. Group A - 1 
                               [^=]+?   ## use non-greedy 
                            )
                           [ ]*  ## ignore trailing spaces (if any)
                            (?: =* )  ## allow any trailing heading markers
                           [ ]*  ## ignore trailing spaces (if any)
                         $
                       }ix


end  # class Lexer
end # module SportDb
