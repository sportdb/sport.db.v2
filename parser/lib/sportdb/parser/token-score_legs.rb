module SportDb
class Lexer


##
##  note - for now only two legs (1st,2nd) supported
##             maybe more in the future (if there is a real-world sample/use)    

SCORE_LEGS_RE  =  %r{
        (?<score_legs>
           \b   
            (?<leg1_ft1>\d{1,2}) - (?<leg1_ft2>\d{1,2})
               (?: [ ]+ |  [ ]*,[ ]*)   # separate by spaces OR comma
            (?<leg2_ft1>\d{1,2}) - (?<leg2_ft2>\d{1,2})
           \b 
            (?:   ## check optional aggregate e.g. (agg 4-4)
                [ ]+
                 \(
                     agg [ ]
                      (?<agg1>\d{1,2}) - (?<agg2>\d{1,2})
                     
                 \)
            )?
        )}ix






end  #  class Lexer
end  # module SportDb
