
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

    

