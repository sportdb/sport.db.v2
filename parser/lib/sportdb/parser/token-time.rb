module SportDb
class Lexer



##
#  keep 18h30 - why? why not?
#    add support for 6:30pm 8:20am etc. - why? why not?
#
#    check - only support h e.g. 18h30  or 18H30 too - why? why not?
# e.g. 18:30 (or 18h30)
#   note - optional timezone possible e.g.
#        18:30 UTC+1   or 18:30 BST/UTC+1  or such!!!
#        18:30 UTC+01  or 18:30 BST/UTC+01
#       
#
#  note  18.30 no longer supported - MUST use 18:30 or 18h30 !!!

TIME_RE = %r{
    (?<time>  \b
        (?:   (?<hour>\d{1,2})
                   [:h] 
              (?<minute>\d{2})
                 
                 #### optional (inline) timezone
                 ##    note - non-utc timezone MUST be hard-coded (added) here!!!
                 ##     avoids eating-up team names (separated by one space)
                 ##            e.g.  18:30 MEX v MEX 
                 (?:
                    [ ]  ## require space - why? why not
                     (?<timezone>
                        (?: 
                          (?: BST|CEST|CEST|EEST) 
                               (?: /
                                   UTC[+-]\d{1,4}
                               )?
                          )
                          |
                          (?: UTC[+-]\d{1,4})
                     )
                 )?
          )
        \b  
    )}ix


##    local time e.g (19:30 UTC+1) or (19:30 BST/UTC+1) or 
##   note - timezone is optional!  e.g. (19:30) works too
TIME_LOCAL_RE = %r{
    (?<time_local>   
         \(
        (?:   (?<hour>\d{1,2})
                   [:h]
              (?<minute>\d{2})
                
                ####
                ## optional "local" timezone name eg. BRT or CEST etc.
                (?:
                    [ ] ## require space - why? why not
                   (?<timezone>
                      (?:  [A-Z]{3,4}
                           (?: /
                                   UTC[+-]\d{1,4}
                           )? 
                      )
                      |    
                      (?: UTC[+-]\d{1,4})   ## e.g. 0 or 00 or 0000
                  )
               )?  # note - make timezone  optional!!!
          )
      \)
)}ix

    

end  #   class Lexer
end  # module SportDb
