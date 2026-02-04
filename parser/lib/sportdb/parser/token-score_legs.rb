module SportDb
class Lexer


##
##  note - for now only two legs (1st,2nd) supported
##             maybe more in the future (if there is a real-world sample/use)    

##
##  win on away goals
##  aet
##

SCORE_LEGS_RE  =  %r{
        (?<score_legs>
           \b   
            (?<leg1_ft1>\d{1,2}) - (?<leg1_ft2>\d{1,2})
               (?: [ ]+ |  [ ]*,[ ]*)   # separate by spaces OR comma
            (?:
                ## opt 1 - after extra-time (et) score
                    (?<leg2_et1>\d{1,2}) - (?<leg2_et2>\d{1,2})
                       [ ]? #{ET_EN}   ## a.e.t./aet
                        ### note - might end in dot (.) not alpha
                        ###  thus, wordboundary NOT working
                       #{SCORE_LOOKAHEAD}   
                  |
                ## opt 2 - full-time (ft)  
                (?<leg2_ft1>\d{1,2}) - (?<leg2_ft2>\d{1,2})
                    \b 
            )                
            (?:   ## check optional aggregate e.g. (agg 4-4)
                [ ]+
                 \(
                     agg [ ]
                      (?<agg1>\d{1,2}) - (?<agg2>\d{1,2}) 
                      
                     ### add win options 
                     (?:
                         ## opt 1 - on away goals
                        (?<away> [ ]*,[ ]*
                                 (?:win [ ])? on [ ] away [ ] goals?
                         )
                           |
                         ## opt 2 - on penalties  
                        (?:
                           [ ]*,[ ]*
                           (?:win [ ])?
                            (?<leg2_p1>\d{1,2}) - (?<leg2_p2>\d{1,2})
                            [ ] on [ ] pens
                        )
                     )?
                 \)
            )?
        )}ix



end  #  class Lexer
end  # module SportDb
