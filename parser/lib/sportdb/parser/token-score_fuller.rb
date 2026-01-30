module SportDb
class Lexer

###
# alternate (more literate) score style
#      found in books & magazines
#         (with no half-time score)
#
#         4-4 (aet, 6-6 on aggregate, win 3-5 on pens)
#            -or-
#         4-4 (aet, 6-6 an aggregate, 3-5 on pens)
#            -or-
#         4-4 (aet, 6-6agg, 3-5p)
#
#         2-2 (3-3 on aggregate, win on away goals)
#            -or-
#         2-2 (3-3 agg, away goals)
#          etc.


############
#        4-4 (aet)
#        4-4 (a.e.t.)

SCORE_FULLER__ET__RE  =  %r{
        (?<score_fuller>
           \b   
            (?<et1>\d{1,2}) - (?<et2>\d{1,2})
            [ ]+
             \(
                (?<aet> #{ET_EN})
             \)
        )}ix


#############
#         4-4 (aet, win 3-5 on pens) 
#         4-4 (aet, 3-5 on pens)
#         4-4 (aet, 3-5 pen)
#         4-4 (a.e.t., 3-5 pen.)

SCORE_FULLER__ET_P__RE  =  %r{
        (?<score_fuller>
           \b   
            (?<et1>\d{1,2}) - (?<et2>\d{1,2})
            [ ]+
             \(
                (?<aet> #{ET_EN})
                 [ ]*,[ ]*
                 (?:
                    ############
                    ## opt 1)  with win
                    (?:
                        (?: win [ ] )?    ## note - win is optional
                        (?<p1>\d{1,2}) - (?<p2>\d{1,2})
                          [ ] on [ ] pens
                    )
                    |        
                    #####
                    ## opt 2)  "classic"
                    (?:
                       (?<p1>\d{1,2}) - (?<p2>\d{1,2})
                          [ ]*
                        #{P_EN}   
                    )
                 )
             \)
        )}ix


##########################        
#         4-4 (win 3-5 on pens)
#         4-4 (3-5 pen)
#         4-4 (3-5p)

SCORE_FULLER__FT_P__RE  =  %r{
        (?<score_fuller>
           \b   
            (?<ft1>\d{1,2}) - (?<ft2>\d{1,2})
            [ ]+
             \(
                 (?:
                    ############
                    ## opt 1)  with win
                    (?:
                        (?: win [ ] )?    ## note - win is optional
                        (?<p1>\d{1,2}) - (?<p2>\d{1,2})
                          [ ] on [ ] pens
                    )
                    |        
                    #####
                    ## opt 2)  "classic"
                    (?:
                       (?<p1>\d{1,2}) - (?<p2>\d{1,2})
                          [ ]*
                        #{P_EN}   
                    )
                 )
             \)
        )}ix

#####################
#   3-2 (win 4-5 on aggregate)
#   3-2 (4-5 on aggregate)
#   3-2 (4-5 on agg)
#   3-2 (4-5 agg)
#   3-2 (4-5 agg.)
#     or  
#   3-2 (agg 4-5)


SCORE_FULLER__FT_AGG__RE  =  %r{
        (?<score_fuller>
           \b   
            (?<ft1>\d{1,2}) - (?<ft2>\d{1,2})
            [ ]+
             \(
                 (?:
                    ############
                    ## opt 1)  with win
                    (?:
                        (?: win [ ] )?    ## note - win is optional
                        (?<agg1>\d{1,2}) - (?<agg2>\d{1,2})
                          [ ] on [ ] agg (?: regate )?  
                    )
                    |        
                    #####
                    ## opt 2)  "classic" (post)
                    (?:
                       (?<agg1>\d{1,2}) - (?<agg2>\d{1,2})
                          [ ]*
                        #{AGG_EN}   
                    )
                    |
                    #####
                    ## opt 3) agg up-front (pre)
                    (?:
                         agg [ ]
                       (?<agg1>\d{1,2}) - (?<agg2>\d{1,2})   
                    )
                 )
             \)
        )}ix


#####################
#   2-1 (aet, 3-3 on aggregate, win 5-2 on pens)
#   2-1 (aet, 3-3 agg, 5-2 pen.)

SCORE_FULLER__ET_AGG_P__RE  =  %r{
        (?<score_fuller>
           \b   
            (?<et1>\d{1,2}) - (?<et2>\d{1,2})
            [ ]+
             \(
                (?<aet> #{ET_EN})
                    [ ]*,[ ]*
                 (?:
                    ############
                    ## opt 1)  fuller long form (on aggregate)
                    (?:
                        (?<agg1>\d{1,2}) - (?<agg2>\d{1,2})
                          [ ] on [ ] agg (?: regate )?  
                    )
                    |        
                    #####
                    ## opt 2)  "classic" (post)
                    (?:
                       (?<agg1>\d{1,2}) - (?<agg2>\d{1,2})
                          [ ]*
                        #{AGG_EN}   
                    )
                    |
                    #####
                    ## opt 3) agg up-front (pre)
                    (?:
                         agg [ ]
                       (?<agg1>\d{1,2}) - (?<agg2>\d{1,2})   
                    )
                 )
                    [ ]*,[ ]*
                 (?:
                    ############
                    ## opt 1)  with win
                    (?:
                        (?: win [ ] )?    ## note - win is optional
                        (?<p1>\d{1,2}) - (?<p2>\d{1,2})
                          [ ] on [ ] pens
                    )
                    |        
                    #####
                    ## opt 2)  "classic"
                    (?:
                       (?<p1>\d{1,2}) - (?<p2>\d{1,2})
                          [ ]*
                        #{P_EN}   
                    )
                 )                   
             \)
        )}ix




#############################################
# map tables
#  note: order matters - first come-first matched/served

SCORE_FULLER_RE = Regexp.union(
  SCORE_FULLER__ET_P__RE,     ##  e.g.  2-2 (aet, win 5-3 on pens)
  SCORE_FULLER__ET__RE,       ##  e.g.  2-3 (aet)
  SCORE_FULLER__FT_P__RE,     ##  e.g.  2-2 (win 5-3 on pens)
  SCORE_FULLER__FT_AGG__RE,   ##  e.g.  2-3 (win 5-4 on aggregate)
  SCORE_FULLER__ET_AGG_P__RE, ##  e.g.  2-1 (aet, 3-3 on aggregate, win 5-2 on pens)
)



end  #  class Lexer
end  # module SportDb

