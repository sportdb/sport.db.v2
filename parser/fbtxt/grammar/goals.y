

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
                         @tree << GoalLine.new( goals: val[1] )
                      }




         ##
         ##  note - uses goals:
         ##     (i)  []          -  single line (no separator)
         ##     (ii) [[],[]]     -  nested w/ team1/2 (separator required)

        goal_lines_body : goals                  {  result = val[0] }
                        | goals goals_sep goals  {  result = [val[0],val[2]] }


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
