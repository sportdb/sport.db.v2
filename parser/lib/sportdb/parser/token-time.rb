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
#
#
#
#   note -  local time is now (inline) part of time!!!
#              and, thus, must always follow time
#                     e.g. 18:30 (19:30 BST)
#
##    local time e.g (19:30 UTC+1) or (19:30 BST/UTC+1) or 
##   note - timezone is optional!  e.g. (19:30) works too


TIME_RE = %r{
        \b
    (?<time>  
             (?<hour>\d{1,2})
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
                          ## GMT   - Greenwich Mean Time
                          ## BST   - British Summer Time
                          ## CES?T - Central European (Summer) Time
                          ## EES?T - Eastern European (Summer) Time
                          ##
                          (?: GMT|BST|CES?T|EES?T) 
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

####
###  note - local time is now INLINE and MUST follow time
       (?:     
           [ ]+   ## todo/check - make space optional - why? why not?
           \(
        (?<time_local>   
                (?<local_hour>\d{1,2})
                   [:h]    ### todo/fix - MUST match style in time above!!!
                (?<local_minute>\d{2})
                
                ####
                ## optional "local" timezone name eg. BRT or CEST etc.
                (?:
                    [ ] ## require space - why? why not
                   (?<local_timezone>
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
       )?
}ix


def self._build_time( m )
              ## unify to iso-format
              ###   12.40 => 12:40
              ##    12h40 => 12:40 etc.
              ##  keep string (no time-only type in ruby)
              data = { time: {} }
              
              hour     = m[:hour].to_i(10)  ## allow 08/07/etc.
              minute   = m[:minute].to_i(10)
   
              ##   check if 24:00 possible? or only 0:00 (23:59)
              unless (hour   >=0 && hour   <=23) &&
                     (minute >=0 && minute <=59)
                 raise ArgumentError, "parse error - time >#{m[:time]}< out-of-range"
              end
   
              data[:time][:h] = hour
              data[:time][:m] = minute
              data[:time][:timezone] = m[:timezone]    if m[:timezone] 
      

              ## check if local time present e.g.
              ##    18:30 (19:30)
              ##    18:30 (19:30 BST)  etc.
              if m[:time_local]
                  data[:time_local] = {}

                local_hour     = m[:local_hour].to_i(10)  ## allow 08/07/etc.
                local_minute   = m[:local_minute].to_i(10)
  
                ##   check if 24:00 possible? or only 0:00 (23:59)
                unless (hour   >=0 && hour   <=23) &&
                       (minute >=0 && minute <=59)
                   raise ArgumentError, "parse error - local time >#{m[:time_local]}< out-of-range"
                end
  
                data[:time_local][:h] = local_hour
                data[:time_local][:m] = local_minute
                data[:time_local][:timezone] = m[:local_timezone]    if m[:local_timezone] 
            end

              data
end
def _build_time(m) self.class._build_time(m); end

end  #   class Lexer
end  # module SportDb
