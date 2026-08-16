
##########################################################################
##     level 2 support for properties - line-up, penalties, etc.


        ##
        ## todo - maybe add (soldout) or such optional qualifier!!
        ##           or 50000+ or such for estimates NUM_APPROX/NUM_ESTIMATE ??

        attendance_line  : PROP_ATTENDANCE  PROP_NUM  PROP_END
                              {
                                 @tree << AttendanceLine.new( att: val[1].as_int )
                              }

     #####
     ## optional inline attendance
     ##      check/fix - change to INLINE_ATTENDANCE
     attendance_opt   : /* empty */
                        | ';' ATTENDANCE  PROP_NUM
                           {
                                 @tree << AttendanceLine.new( att: val[2].as_int )
                           }


        ## note - allow inline attendance prop in same line
        ##             why? why not?
        ##           todo - add usage samples here!!!
        referee_line   :  PROP_REFEREE  referees  PROP_END
                            {
                               @tree << RefereeLine.new( referees: val[1] )
                            }

        referees  :     referee                {  result = val }
                  |     referees ',' referee   {  result.push( val[2] ) }

        referee  :      PROP_NAME
                         {  result = Referee.new( name: val[0].as_str ) }
                 |      PROP_NAME  ENCLOSED_NAME
                         {  result = Referee.new( name: val[0].as_str, country: val[1].as_str ) }



       #############
       ## coaches

        coach_line   :  PROP_COACH  coaches PROP_END
                            {
                               @tree << CoachLine.new( coaches: val[1] )
                            }

        coaches   :     coach               {  result = val }
                  |     coaches ',' coach   {  result.push( val[2] ) }

        coach    :      PROP_NAME
                         {  result = Coach.new( name: val[0].as_str ) }
                 |      PROP_NAME  ENCLOSED_NAME
                         {  result = Coach.new( name: val[0].as_str, country: val[1].as_str ) }
