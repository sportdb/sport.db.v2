module Fbtxt
class Lexer


######################################################
## goal mode
##  note - must be enclosed in ()!!!
##
##          todo - add () in basics - why? why not?




## note - assume lines starting with opening ( are goal lines!!!!
##  note - use \A (instead of ^) - \A strictly matches the start of the string.
##
##   note -  check for negative lookahead
##                 to exclude ord (numbers) e.g.  (1), (42), etc.!!!
##
##  todo/fix -- exclude (a), (h), (n)  - TEAM_AWAY, TEAM_HOME, TEAM_NEUTRAL tokens!!

START_GOAL_LINE_RE = %r{
                     \A
                        [ ]*    ## ignore leading spaces (if any)
                       \(

                       # check NEGATIVE lookahead
                       (?!
                             ##  exclude (a), (h), (n)
                             ##    TEAM_AWAY, TEAM_HOME, TEAM_NEUTRAL
                             (?: a|h|n )
                             \)
                        )

 }xi



#############
##  check for goal compat(ility) "legacy" line
##         e.g.
## (6' Puskás 0-1, 9' Czibor 0-2, 11' Morlock 1-2, 18' Rahn 2-2,
##   84' Rahn 3-2)
## (6 Puskás 0-1, 9 Czibor 0-2, 11 Morlock 1-2, 18 Rahn 2-2,
##  84 Rahn 3-2)


START_GOAL_LINE_COMPAT_RE = %r{
                   \A
                        [ ]*    ## ignore leading spaces (if any)
                      \(

                      ## (i) check NEGATIVE lookahead
                      ##    exclude score e.g. 1-1 etc.
                          (?! [ ]* \b \d-\d \b)

                      ## (ii) check POSITIVE lookahead
                          (?= [ ]*
                               \d{1,3}
                                   '?    ## optional minute marker
                                  (?: \+
                                      \d{1,2}
                                    '?    ## optional minute marker
                                  )?
                            )
}xi



###
##  check for goal line (alternate syntax)
##    (1-0 Player, 1-1 Player, ...)
#    must start-off OR yes, include score
##
##    note - allow "centered" style e.g.
##           (    Player 44' (p)  1-0
##                                1-1 Player 64'   )
START_GOAL_LINE_ALT_RE = %r{
                     \A
                        [ ]*    ## ignore leading spaces (if any)
                      \(

                      # check POSITIVE lookahead
                       (?=  .*?         ## note - non-greedy
                                \b \d-\d \b    ## score e.g. 0-1
                         )
                 }xi







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
#
#   note - allow split by - e.g.
#     Frankfurt   4-2 Schalke     (Kreß 45, Solz 55, Trimhold 58, Huberts 73 p -
#                                  Berz 7, Herrmann 74)


GOAL_SEP_ALT_RE = %r{
          (?<goal_sep_alt>
              (?<=[ ])   ## positive lookbehind - space required
              -
              (?=[ ]|\z)    ## positive lookahead - speace required
             )}x


## e.g.  (2)
##       (2/p), (2/pen.), (3/2p), (3/ 2 pen.)
##      -or-  (2,1pen), (3, 2 pens)
##
##       (p), (pen.) (2 pen.), (2p)
##       (og), (o.g.),
##        (2og), (2 o.g.), (2ogs)
#
##

GOAL_COUNT_RE = %r{
   (?<goal_count>
      \(
        (?:
          ## opt penalties
            (?<pen>
              (?:  (?<pen_value> \d{1,2}) [ ]? )?
                 (?:pens|pen\.?|p)
           )
            |
          ## opt own goals (og)
            (?<og>
             (?: (?<og_value> \d{1,2}) [ ]? )?
                (?:ogs?|o\.g\.|o)
            )
            |
          ## opt fallback - classic count/number
          (?:  (?<value> [1-9])
                ## check for option penalties
                (?<pen>
                     [,/] [ ]*
                     (?: (?<pen_value> \d{1,2}) [ ]? )?
                     (?:pens|pen\.?|p)
                )?
           )
         )
      \)
)}ix




##
## note - inline \b check in MINUTE_RE excludes
##      85pen  or 90+4pen or 38p
##        (possible and NOT excluded in GOAL_MINUTE_RE  !!!)
##
##  minute with optional stoppage (offset)

MINUTE_RE = %r{
     (?<minute>
               \b
             (?<value>\d{1,3})      ## constrain numbers to 0 to 999!!!
                \b
                '?    ## optional minute marker

                (?: \+ (?<value2>\d{1,2})
                       \b
                      '?    ## optional minute marker
                 )?
      )
}ix



##
##  keep separate? or add simply inside GOAL_MINUTE_RE - why? why not?
##   fix-fix-fix - move into GOAL_MINUTE_RE !!!

GOAL_MINUTE_NA_RE = %r{
     (?<goal_minute_na>

       # positive lookbehind
       (?<=[ ,;])

       (?<value> \?{1,2})
            '?    ## optional minute marker
     ## note - add goal minute qualifiers here inline!!!
        (?:
            (?: [ ]? (?<og>   (?: \((?:og|o\.g\.|o)\))   ## allow (og)
                                   |
                              (?: (?:og|o\.g\.|o))      ## allow plain og
                      )
            )
            |
            (?: [ ]? (?<pen>  (?: \((?:pen\.?|p)\))   ## allow ()
                                   |
                              (?: (?:pen\.?|p))
                      )
            )
            |
            ## add experimental header qualifier
            (?: [ ]? (?<hdr> \( (?:hdr\.?|h ) \) | (?: hdr\.?|h ) ))
            |
            ## add experimental free kick qualifier
            (?: [ ]? (?<fk> \( (?:fk\.?|f ) \) | (?: fk\.?|f) ))
        )?

     ## note - check positive lookahead
     (?=[ ,;)]|$)
   )
}ix


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
               \b
             (?<value>\d{1,3})      ## constrain numbers to 0 to 999!!!
                '?    ## optional minute marker

                 (?: \+ (?<value2>\d{1,2})
                      '?    ## optional minute marker
                 )?

        ## note - add goal minute qualifiers here inline!!!
        (?:
            (?: [ ]? (?<og>   (?: \((?:og|o\.g\.|o)\))   ## allow (og)
                                   |
                              (?: (?:og|o\.g\.|o))      ## allow plain og
                      )
            )
            |
            (?: [ ]? (?<pen>  (?: \((?:pen\.?|p)\))   ## allow ()
                                   |
                              (?: (?:pen\.?|p))
                      )
            )
            |
            ## add experimental header qualifier
            (?: [ ]? (?<hdr> \( (?:hdr\.?|h ) \) | (?: hdr\.?|h ) ))
            |
            ## add experimental free kick qualifier
            (?: [ ]? (?<fk> \( (?:fk\.?|f ) \) | (?: fk\.?|f) ))
        )?

        ##  add experimental seconds
        ##    e.g. (95 secs) or (95sec) etc.
        (?: [ ]*  \(
                      (?<secs>\d{1,3})
                         [ ]?secs?
                   \)
        )?
     )

     ## note - check positive lookahead
     (?=[ ,;)]|$)
}ix





###
## more regex  for goal alt


GOAL_TYPE_RE = %r{
     (?<goal_type>
               \(
                 (?:
                      (?<og>  og|o\.g\.|o )
                         |
                      (?<pen> pen\.?|p )
                         |
                     ## add experimental header qualifier
                      (?<hdr>  hdr\.?|h )
                         |
                     ## add experimental free kick qualifier
                       (?<fk>  fk\.?|f )
                  )
                \)
)}xi




end  # class Lexer
end # module Fbtxt
