module Fbtxt
class Lexer


##
#  allow Cote'd Ivoir or such
##   e.g. add '


## todo/fix - make geo text regex more generic
##               only care about two space rule


##
## before with optional space
##   trying to use "hard" (joiner) space
=begin
                (?:
                    [ ]?   # only single (inline) space allowed - double spaces are breaks!!!
                    (?:
                       \p{L} | \d  | [.&'°]
                        |
                       (?: (?<! [ ])  ## no space allowed before (but possible after)
                            [-]
                       )
                         |
                       (?: (?<! [ ])  ## no spaces allowed around these characters
                           [_/]
                          (?! [ ])
                       )
                    )+
=end

## positive lookbehind -  for now space (or beginning of line - for testing) only
##  (MUST be fixed number of chars - no quantifier e.g. +? etc.)
GEO_LEFT_BOUNDARY_  = '(?<= [ ,›>\[\]]|^)'
## add lookahead/lookbehind
##    must be space!!!
##   (or comma or  start/end of string)
##   kind of \b !!!
 ## POSITIVE lookahead
GEO_RIGHT_BOUNDARY_ = '(?= [ ,›>\[\]]|$)'



GEO_TEXT_RE = %r{
    ## must start with alpha (allow unicode letters!!)
    (?<text>
             #{GEO_LEFT_BOUNDARY_}
          (?:
              (?:
                # opt 1 - start with alpha
                #   note - allow (dots)
                 \p{L}[\p{L}.]*    ## all unicode letters (e.g. [a-z])
                   |
                # opt 2 - start with num!! -
                     \d+  # check for num lookahead (MUST be space or dot)
                      ## MAY be followed by (optional space) !
                      ## MUST be follow by a to z!!!!
                      [ ]?   ## make space optional too  - why? why not?
                             ##  yes - eg. 1st, 2nd, 5th etc.
                       \p{L}[\p{L}.]*
                  |
                ## opt 3 - add another weirdo case
                ##   e.g.   's Gravenwezel-Schilde
                ##   add more letters (or sequences here - why? why not?)
                ##    or hard-code simly 's for now - why? why not?
                    ' \p{L}[\p{L}.]*
               )

               ##
               ## todo/check - find a different "more intuitive" regex/rule if possible?
               ##    for single spaces only
               ## | [_]              ## no space allowed around - keep (why? why not?)


                (?:
                  (?:
                        [ ]? [&/-] [ ]?  ## note - yes, allow space before and after
                     |  [ ]              # only single (inline) space allowed - double spaces are breaks!!!
                   )

                   (?:
                       ##  followed by word (incl. specials .°' for now)
                       [\p{L}\d.°']+
                    ##  todo/fix - possible in regex here
                    ##     only end in alphanum a-z0-9 (not dot or & ???)

                       ## or
              ##   parenthesis enclosed closed text
              ##   e.g. Dublin (Dalymount Park)
              ##        Bucuresti (23 August)
              ##        Paris (Parc des Princes)
              ##        Ost-Berlin (Walter-Ulbricht)
              ##        Athinai (OAKA - Maroussi)
              ##
              ##   or   Valencia (Spain) or Solna
                   |   \(
                        [^()\[\],;:›<>]+    ## todo - add more special chars
                                            ##   maybe list only allowed ones??
                                            ##   make pattern more strict - why? why not?
                      \)
                 )
               )*
        )
            #{GEO_RIGHT_BOUNDARY_}
   )
}ix






##  note - add "hacky" check for comma that is followed by a prop(erty)
##
##  make sure to NOT match
##      props  e.g.  att: 18000
##   July 10 @ Paris, Parc des Princes, att: 18000
##   July 10 @ Paris, Parc des Princes,   att: 18000
##


GEO_END_RE = %r{
   (?<geo_end>
        ,
    )
    ## POSITIVE lookahead for props
    ##   todo/fix - use generic [a-z]+ - why? why not?
    (?=
        [ ]*  ## optional spaces
         (?:     attendance|att
              |  referee?s|refs?
          )
         :
    )
}ix




GEO_RE = Regexp.union(
                    SPACES_RE,
                    GEO_END_RE,
                    GEO_TEXT_RE,
                    /  (?<sym> [,›>\[▪] ) /x,
                    ANY_RE,
                      )

end # class Lexer
end # module Fbtxt
