

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
                         @tree << GoalLine.new( **val[1] )
                      }



        ##
        ##  add a GOALS_NONE_RIGHT too  e.g.
        ##    Jr. 43'; -
        ##    Jr. 43'; none
        ##    Jr. 43'; ∅
        ##
        ##  fix-fix-fix - change GOALS_NONE to GOALS_NONE_LEFT - why? why not?

        ##  fix-fix-fix -
        ##         change single goals line to goals: !!!
        ##                               NOT goals1/goals2 pairs!!!

        goal_lines_body : goals                  {  result = { goals1: val[0],
                                                               goals2: [] }
                                                 }
                        | goals GOALS_NONE_RIGHT {  result = { goals1: val[0],
                                                               goals2: [] }
                                                 }
                        | GOALS_NONE goals      {  result = { goals1: [],
                                                              goals2: val[1] }
                                                }
                        | goals goals_sep goals {  result = { goals1: val[0],
                                                              goals2: val[2] }
                                                }


        goals_sep    : ';'
                     | ';' NEWLINE
                     | GOAL_SEP_ALT   ## note - dash (-) with leading & trailing spaces required
                     | GOAL_SEP_ALT NEWLINE


         opt_goal_sep   : /* empty */       ## empty -- optional
                        | ','
                        | ',' NEWLINE
                        |  NEWLINE       ## note - allow "standalone" newline!!!

         goals   : goal                      { result = val }
                 | goals opt_goal_sep  goal  { result.push( val[2])  }

         #####
         ## todo -  make comma required for player only
         ##        (that is, no minutes or count) - why? why not?

         goal    : PLAYER goal_minutes
                    {
                       result = Goal.new( player:  val[0].as_str,
                                          minutes: val[1] )
                    }
                 | PLAYER GOAL_COUNT
                     {
                        ### todo/check:
                        ##    auto convert/expand
                        ##    count to minutes - why? why not?
                        ##  todo/fix - pass in empty minutes ary [] - why? why not?
                        result = Goal.new( player: val[0].as_str,
                                           count:  val[1].as_hash )
                     }
                 | PLAYER
                     {
                        result = Goal.new( player: val[0].as_str,
                                           minutes: [] )
                     }


         ## note - hacky: lexer MUST change comma
         ##                  between GOAL_MINUTES to GOAL_MINUTE_SEP!!
         opt_goal_minute_sep : { }    ## none - optiona
                             | GOAL_MINUTE_SEP

         goal_minutes  : goal_minute   {  result = val }
                       | goal_minutes opt_goal_minute_sep goal_minute   {  result.push( val[2])  }

         goal_minute : GOAL_MINUTE
                          {
                             result = GoalMinute.new( **val[0].as_hash )
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



        goal_alt    :  SCORE PLAYER     ## note - minute is optional in alt goalline style!!!
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
