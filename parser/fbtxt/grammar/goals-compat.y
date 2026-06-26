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



 ## note - for now SCORE required - why? why not?

        goal_compat    :  MINUTE PLAYER SCORE
                        {
                           result = GoalCompat.new( minute:  Minute.new(**val[0].as_hash),
                                                    player:  val[1].as_str,
                                                    score:  val[2].as_ary )
                        }
                      | MINUTE PLAYER GOAL_TYPE SCORE
                        {
                           result = GoalCompat.new( minute: Minute.new(**val[0].as_hash),
                                                    player: val[1].as_str,
                                                    goal_type: GoalType.new( **val[2].as_hash ),
                                                    score:  val[3].as_ary )
                       }
                     | MINUTE SCORE PLAYER
                        {
                           result = GoalCompat.new( minute:  Minute.new(**val[0].as_hash),
                                                    score:  val[1].as_ary,
                                                    player:  val[2].as_str )
                        }
                      | MINUTE SCORE PLAYER GOAL_TYPE
                        {
                           result = GoalCompat.new( minute: Minute.new(**val[0].as_hash),
                                                    score:  val[1].as_ary,
                                                    player: val[2].as_str,
                                                    goal_type: GoalType.new( **val[3].as_hash ))
                       }


/**
  * note - for now SCORE required - why? why not?
        goal_compat    :  MINUTE PLAYER
                        {
                           result = GoalCompat.new( minute:  Minute.new(**val[0].as_hash),
                                                    player:  val[1].as_str )
                        }
                      |  MINUTE PLAYER GOAL_TYPE
                         {
                           result = GoalCompat.new( minute: Minute.new(**val[0].as_hash),
                                                    player: val[1].as_str,
                                                    goal_type: GoalType.new( **val[2].as_hash ))
                        }
 */
