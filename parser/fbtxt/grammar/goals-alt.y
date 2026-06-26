
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



        ## note - allow optional comma sep (or comma sep w/ newline)

        goals_alt   :  goal_alt
                        { result = val }
                    |  goals_alt  opt_goal_sep  goal_alt
                        { result.push( val[2])  }



        ## note - minute is optional in alt goal line style!!!

        goal_alt    :  SCORE PLAYER
                        {
                           result = GoalAlt.new( score:   val[0].as_ary,
                                                 player:  val[1].as_str )
                        }
                    |  SCORE PLAYER GOAL_MINUTE
                        {
                           goal_minute = GoalMinute.new( **val[2].as_hash )

                           result = GoalAlt.new( score:     val[0].as_ary,
                                                 player:    val[1].as_str,
                                                 minute:    goal_minute.to_minute,
                                                 goal_type: goal_minute.to_goal_type )
                        }
                   |  SCORE PLAYER GOAL_TYPE
                       {
                           result = GoalAlt.new( score:     val[0].as_ary,
                                                 player:    val[1].as_str,
                                                 goal_type: GoalType.new( **val[2].as_hash ))
                       }
                  ###  allow score on the right-side (that is, the end NOT the beginning) e.g.
                  ##       Player      1-1
                  ##       Player 14' 1-1
                  ##       Player (og) 1-1
                   |  PLAYER SCORE
                         {
                           result = GoalAlt.new( player:  val[0].as_str,
                                                 score:   val[1].as_ary )
                         }
                   |  PLAYER GOAL_MINUTE SCORE
                        {
                           goal_minute = GoalMinute.new( **val[1].as_hash )

                           result = GoalAlt.new( player:    val[0].as_str,
                                                 minute:    goal_minute.to_minute,
                                                 goal_type: goal_minute.to_goal_type,
                                                 score:     val[2].as_ary )
                        }
                   |  PLAYER GOAL_TYPE SCORE
                       {
                           result = GoalAlt.new( player:    val[0].as_str,
                                                 goal_type: GoalType.new( **val[1].as_hash ),
                                                 score:     val[2].as_ary )
                       }
