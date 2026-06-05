

        #######
        ## e.g. (Wirtz 10' Musiala 19' Havertz 45'+1 (pen)  Füllkrug 68' Can 90'+3;
        ##      Rüdiger 87' (og))
        ##         or
        ##      (Wirtz 10 Musiala 19 Havertz 45+1p Füllkrug 68 Can 90+3;
        ##        Rüdiger 87og)
        ##
        ##    (Higuaín 2', 9' (pen); Kane 35' Eriksen 71')
        ##      or
        ##    (Higuaín 2, 9p; Kane 35 Eriksen 71)

        #
        # note:  newlines allowed between goals
        #   for now possible after goals separator ; and -
        #    (Higuaín 2, 9p;
        #     Kane 35 Eriksen 71)
        #    (Higuaín 2, 9p -
        #      Kane 35 Eriksen 71)
        #
        #         and after goal separator ,
        #      (Wirtz 10, Musiala 19, Havertz 45+1p,
        #       Füllkrug 68, Can 90+3;
        #        Rüdiger 87og)
        #
        #     BUT now allowed in-between comma-separated minutes!!!
        #


        ##
        ## note - GOALS token is virtual - basically opening-paranthesis `(` for now
        goal_lines : GOALS goal_lines_body GOALS_END NEWLINE
                      {
                         kwargs = val[1]
                         @tree << GoalLine.new( **kwargs )
                      }


        goal_lines_body : goals                 {  result = { goals1: val[0],
                                                              goals2: [] }
                                                }
                        | GOALS_NONE goals           {  result = { goals1: [],
                                                              goals2: val[1] }
                                                }
                        | goals goals_sep goals  {  result = { goals1: val[0],
                                                              goals2: val[2] }
                                                }


        goals_sep    : ';'
                     | ';' NEWLINE
                     | GOAL_SEP_ALT   ## note - dash (-) with leading & trailing spaces required
                     | GOAL_SEP_ALT NEWLINE


         opt_goal_sep   :  {}        ## none; optional!!
                        | ','
                        | ',' NEWLINE
                        |  NEWLINE   ## note - allow "standalone" newline!!!

         goals   : goal                      { result = val }
                 | goals opt_goal_sep  goal  { result.push( val[2])  }

         #####
         ## todo -  make comma required for player only
         ##        (that is, no minutes or count)

         goal    : PLAYER goal_minutes
                    {
                       result = Goal.new( player:  val[0].value,
                                          minutes: val[1] )
                    }
                 | PLAYER GOAL_COUNT
                     {
                        ### todo/check:
                        ##    auto convert/expand
                        ##    count to minutes - why? why not?
                        ##  todo/fix - pass in empty minutes ary [] - why? why not?
                        result = Goal.new( player: val[0].value,
                                           count:  val[1].value )
                     }
                 | PLAYER
                     {
                        result = Goal.new( player: val[0].value,
                                           minutes: [] )
                     }


         ## note - hacky: lexer MUST change comma
         ##                  between GOAL_MINUTES to GOAL_MINUTE_SEP!!
         opt_goal_minute_sep : {}    ## none; optional!!!
                             | GOAL_MINUTE_SEP

         goal_minutes  : goal_minute   {  result = val }
                       | goal_minutes opt_goal_minute_sep goal_minute   {  result.push( val[2])  }

         goal_minute : GOAL_MINUTE
                          {
                             kwargs = {}.merge( val[0].value )
                             result = GoalMinute.new( **kwargs )
                          }


##########
##   alternate goal lines starting with score e.g.
##
##    (1-0 Messi     23'(pen.),
##     2-0 Di María  36',
##     2-1 Mbappé    80'(pen.),
##     2-2 Mbappé    81',
##     3-2 Messi    108',
##     3-3 Mbappé   118'(pen.))

        goal_lines_alt : GOALS_ALT goals_alt GOALS_END NEWLINE
                           {
                             @tree << GoalLineAlt.new( goals: val[1] )
                           }

        goals_alt   :  goal_alt
                        { result = val }
                       ## note - allow optional comma sep (or comma sep w/ newline)
                    |  goals_alt  opt_goal_sep  goal_alt
                        { result.push( val[2])  }



        goal_alt    :  SCORE PLAYER     ## note - minute is optinal in alt goalline style!!!
                        {
                           result = GoalAlt.new( score:   val[0].value[:score],
                                                 player:  val[1].value )
                        }
                    |  SCORE PLAYER GOAL_MINUTE
                        {
                           goal_minute = GoalMinute.new( **val[2].value )

                           result = GoalAlt.new( score:     val[0].value[:score],
                                                 player:    val[1].value,
                                                 minute:    goal_minute.to_minute,
                                                 goal_type: goal_minute.to_goal_type )
                        }
                   |  SCORE PLAYER GOAL_TYPE
                       {
                           result = GoalAlt.new( score:     val[0].value[:score],
                                                 player:    val[1].value,
                                                 goal_type: GoalType.new( **val[2].value ))
                       }
                  ###  allow score on the right-side (that is, the end NOT the beginning) e.g.
                  ##       Player      1-1
                  ##       Player 14' 1-1
                  ##       Player (og) 1-1
                   |  PLAYER SCORE
                         {
                           result = GoalAlt.new( player:  val[0].value,
                                                 score:   val[1].value[:score] )
                         }
                   |  PLAYER GOAL_MINUTE SCORE
                        {
                           goal_minute = GoalMinute.new( **val[1].value )

                           result = GoalAlt.new( player:    val[0].value,
                                                 minute:    goal_minute.to_minute,
                                                 goal_type: goal_minute.to_goal_type,
                                                 score:     val[2].value[:score] )
                        }
                   |  PLAYER GOAL_TYPE SCORE
                       {
                           result = GoalAlt.new( player:    val[0].value,
                                                 goal_type: GoalType.new( **val[1].value ),
                                                 score:     val[2].value[:score] )
                       }

################
##
##   compat ("legacy") goal line style starting with minute
##

        goal_lines_compat : GOALS_COMPAT goals_compat GOALS_END NEWLINE
                           {
                             @tree << GoalLineCompat.new( goals: val[1] )
                           }

        goals_compat   :  goal_compat
                           { result = val }
                       |  goals_compat  opt_goal_sep  goal_compat
                           { result.push( val[2])  }

/**
  * note - for now SCORE required - why? why not?
        goal_compat    :  MINUTE PLAYER
                        {
                           result = GoalCompat.new( minute:  Minute.new(**val[0].value),
                                                    player:  val[1].value )
                        }
                      |  MINUTE PLAYER GOAL_TYPE
                         {
                           result = GoalCompat.new( minute: Minute.new(**val[0].value),
                                                    player: val[1].value,
                                                    goal_type: GoalType.new( **val[2].value ))
                        }
 */

        goal_compat    :  MINUTE PLAYER SCORE
                        {
                           result = GoalCompat.new( minute:  Minute.new(**val[0].value),
                                                    player:  val[1].value,
                                                    score:  val[2].value[:score] )
                        }
                      | MINUTE PLAYER GOAL_TYPE SCORE
                        {
                           result = GoalCompat.new( minute: Minute.new(**val[0].value),
                                                    player: val[1].value,
                                                    goal_type: GoalType.new( **val[2].value ),
                                                    score:  val[3].value[:score] )
                       }
                       | MINUTE SCORE PLAYER
                        {
                           result = GoalCompat.new( minute:  Minute.new(**val[0].value),
                                                    score:  val[1].value[:score],
                                                    player:  val[2].value )
                        }
                      | MINUTE SCORE PLAYER GOAL_TYPE
                        {
                           result = GoalCompat.new( minute: Minute.new(**val[0].value),
                                                    score:  val[1].value[:score],
                                                    player: val[2].value,
                                                    goal_type: GoalType.new( **val[3].value ))
                       }
