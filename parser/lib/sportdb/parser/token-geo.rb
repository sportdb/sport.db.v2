module SportDb
class Lexer


##
#  allow Cote'd Ivoir or such
##   e.g. add '


## todo/fix - make geo text regex more generic
##               only care about two space rule


GEO_TEXT_RE = %r{
    ## must start with alpha (allow unicode letters!!)
    (?<text>
           ## positive lookbehind -  for now space (or beginning of line - for testing) only
           ##  (MUST be fixed number of chars - no quantifier e.g. +? etc.)
            (?<= [ ,›>\[\]]|^)
            (?:
                # opt 1 - start with alpha
                 \p{L}+    ## all unicode letters (e.g. [a-z])
                   |
                # opt 2 - start with num!! - 
                     \d+  # check for num lookahead (MUST be space or dot)
                      ## MAY be followed by (optional space) !
                      ## MUST be follow by a to z!!!!
                      [ ]?   ## make space optional too  - why? why not?
                             ##  yes - eg. 1st, 2nd, 5th etc.
                       \p{L}+
                  |
                ## opt 3 - add another weirdo case
                ##   e.g.   's Gravenwezel-Schilde
                ##   add more letters (or sequences here - why? why not?)
                    '\p{L}+
               )

               ##
               ## todo/check - find a different "more intuitive" regex/rule if possible?
               ##    for single spaces only (and _/ MUST not be surround by spaces) 

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
              )*

              ## for now allow auto-add optional
              ##   parenthesis enclosed closed text
              ##   e.g. Dublin (Dalymount Park)
              ##        Bucuresti (23 August)
              ##        Paris (Parc des Princes)
              ##        Ost-Berlin (Walter-Ulbricht)
              ##        Athinai (OAKA - Maroussi)  
              (?:
                    [ ]
                    \(
                        [^()\[\],;:›<>]+    ## todo - add more special chars
                                            ##   maybe list only allowed ones??
                                            ##   make pattern more strict - why? why not?
                    \)
              )?
         
              ## must NOT end with space or dash(-)
              ##  todo/fix - possible in regex here
              ##     only end in alphanum a-z0-9 (not dot or & ???)

            ## add lookahead/lookbehind
           ##    must be space!!!
           ##   (or comma or  start/end of string)
           ##   kind of \b !!!
            ## positive lookahead
            (?=[ ,›>\[\]]|$)
   )
}ix





GEO_BASICS_RE = %r{
    (?<spaces> [ ]{2,}) |
    (?<space>  [ ])
        |
    (?<sym> [,›>\[] )
}ix




GEO_RE = Regexp.union(
                    GEO_BASICS_RE, 
                    GEO_TEXT_RE,
                    ANY_RE,
                      )

end # class Lexer
end # module SportDb
