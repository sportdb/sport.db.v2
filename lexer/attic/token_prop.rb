

  PROP_KEY_RE = %r{
                    ^     # note - MUST start line; leading spaces optional (eat-up)
                    [ ]*
                 (?<prop_key>
                   (?<key>
                       (?: ## (i) starting w/ letters
                          \p{L}
                          [\p{L}\d]*        ##  e.g. a1, a2000, etc.
                           \.?               ##  optional dot
                           ## (ii) starting w/ number
                           ##      MUST be followed by (optional dot) and
                           ##                      required space !!!
                           ##      MUST be follow by a to z!!!!
                           ##       check for num lookahead (MUST be space or dot)
                          |  \d+                     ## eg. 1fc, 1a, etc.
                              [.°]?    ## optional dot or numsign e.g. 1. or 1°
                              [ ]?    ## make space optional too  - why? why not?
                                      ##  yes - eg. 1st, 2nd, 5th etc.
                             \p{L}
                             [\p{L}\d]*
                               \.?               ##  optional dot
                        )
                       (?:
                           ## connectors
                            (?: ## (i)   single space or WITHOUT surrounding spaces!! - slash (/), dash (-), dot (.)
                                ##                           e.g. u.s.a., real c.f., etc.
                                   [ ./-]
                                ## (ii)     surrounded by leading or trailing optional space
                                 | [ ]? ['&] [ ]?
                            )
                             (?:    [\p{L}\d]+
                                         \.?    ##  optional dot
                                 |  \d+ [.°]?
                               )
                       )*
                      )   ## close <key> capture
                    [ ]*?     # slurp trailing spaces
                     :

                ## positive lookahead (must be followed by space!!)
                ##     or allow end-of-line too
                    (?= [ ]+|$)
                   )  ## close <prop_key> capture
                 }ix
