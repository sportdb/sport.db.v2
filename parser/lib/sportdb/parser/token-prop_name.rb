module SportDb
class Lexer


##
##  see token-text for TEXT_RE
##          change PROP_NAME_RE to   TEXT_II or TEXT_???  - why? why not?


## name different from text (does NOT allow number in name/text)
PROP_NAME_RE = %r{
                 (?<prop_name> 
                      \b
                   (?<name>
                      \p{L}+       
                        \.?    ## optional dot
                          (?:
                             ## rule for space; only one single space allowed inline!!!
                              (?:
                                (?<![ ])  ## use negative lookbehind                             
                                  [ ] 
                                (?=\p{L}|['"])      ## use lookahead        
                              )
                              ## support (inline) quoted name e.g. "Rodri" or such
                                  |
                                  (?:
                                     (?<=[ ])  ## use positive lookbehind                             
                                     " \p{L}+ " 
                                      ## require space here too - why? why not?
                                   )                      
                                  |   
                             (?:
                                (?<=\p{L})   ## use lookbehind
                                 [-]   ## must be surrounded by letters
                                       ## e.g. One/Two NOT
                                       ##      One/ Two or One / Two or One /Two etc.
                                (?=\p{L})      ## use lookahead        
                              )
                                 |   
                              (?:  ## flex rule for quote - allow any
                                    ##  only check for double quotes e.g. cannot follow other ' for now - why? why not?
                                    ##        allows  rodrigez 'rodri' for example
                                (?<!')  ## use negative lookbehind                             
                                   '         
                              )      
                                 |   ## standard case with letter(s) and optinal dot
                              (?: \p{L}+
                                    \.?  ## optional dot
                              )
                          )*
                    )
               ## add lookahead - must be non-alphanum 
                  (?=[ ,;\]\)]|$)
                  )
}ix


end  # class Lexer
end  # module SportDb