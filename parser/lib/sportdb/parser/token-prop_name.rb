module SportDb
class Lexer


##
##  see token-text for TEXT_RE
##          change PROP_NAME_RE to   TEXT_II or TEXT_???  - why? why not?
###   no do NO change
##    change TEXT_RE to TEAM_RE or TEAM_NAME_RE !!!!
##          it is NOT generic TEXT regex!!!




PROP_NAME_WORD_ = %r{
                           \p{L}+
                             \.?     ## optional dot
                    }ix


## todo/fix - remove support for double quotes e.g. "Rodri"  - why? why not?
##

## name different from text (**does NOT allow number in name/text**)
##      different from PROP_KEY too
PROP_NAME_RE = %r{
                 (?<prop_name>
                      \b
                   (?<name>
                        #{PROP_NAME_WORD_}

                          ## connectors
                          (?:
                             ## (i) space - only one single space allowed inline!!!
                              (?:
                               ### check if negative lookbehind is redudant!!
                               ##    next char is \p{L} and NOT space
                               ##    thus double space not possible!!
                                (?<! [ ])             ## use negative lookbehind
                                  [ ]
                                (?=  \p{L}|['"]\p{L})      ## use lookahead
                              )
                              ## (ii) support (inline) quoted name e.g. "Rodri" or such
                                 | (?:
                                     (?<=[ ])   ## use positive lookbehind
                                     " \p{L}+ "
                                      ## require space here too - why? why not?
                                   )
                              ## (iii) dash (-)
                              | (?:
                                ## use  POSITIVE lookBEHIND
                                ## note - allow leading dot (.) e.g. K.-H.Förster
                                ##                short for          Karl-Heinz Förster
                                ##
                                ##    change to negative lookBEHIND   [ '"-]
                                ##      \p{L}\. | \p{L} - not MUST be fixed size
                                 (?<=
                                         [\p{L}.]
                                      )
                                 [-]   ## must be surrounded by letters
                                       ## e.g. One-Two NOT
                                       ##      One- Two or One - Two or One -Two etc.
                                (?= \p{L})      ## use lookahead
                              )
                                 |
                              (?:  ## flex rule for quote - allow any
                                    ##  only check for double quotes e.g. cannot follow other ' for now - why? why not?
                                    ##        allows  rodrigez 'rodri' for example
                                (?<!')  ## use negative lookbehind
                                   '
                              )
                            |   ## standard case with letter(s) and optional dot
                              #{PROP_NAME_WORD_}
                          )*
                    )
                ## add lookahead - must be non-alphanum
                ##    add colon (:) too - why? why not?
                  (?= [ ,;\]\)]|$)
)}ix


end  # class Lexer
end  # module SportDb