
##########################################################################
##     level 2 support for properties - line-up, penalties, etc.


        ##
        ## todo - maybe add (soldout) or such optional qualifier!!
        ##           or 50000+ or such for estimates NUM_APPROX/NUM_ESTIMATE ??

        attendance_line  : PROP_ATTENDANCE  PROP_NUM  PROP_END NEWLINE
                              {
                                 @tree << AttendanceLine.new( att: val[1].as_int )
                              }



        ## note - allow inline attendance prop in same line
        ##             why? why not?
        ##           todo - add usage samples here!!!
        referee_line   :  PROP_REFEREE  referees  attendance_opt PROP_END NEWLINE
                            {
                               @tree << RefereeLine.new( referees: val[1] )
                            }

        referees  :     referee                {  result = val }
                  |     referees ',' referee   {  result.push( val[2] ) }

        referee  :      PROP_NAME
                         {  result = Referee.new( name: val[0].as_str ) }
                 |      PROP_NAME  ENCLOSED_NAME
                         {  result = Referee.new( name: val[0].as_str, country: val[1].as_str ) }


     attendance_opt   : /* empty */
                        | ';' ATTENDANCE  PROP_NUM
                           {
                                 @tree << AttendanceLine.new( att: val[2].as_int )
                           }



##
##  fix-fix-fix  - [ ] add sentoff_lines & yellowredcard_lines !!!


        yellowcard_lines : PROP_YELLOWCARDS card_body PROP_END NEWLINE
                             {
                               @tree << CardsLine.new( type: 'Y', bookings: val[1] )
                             }
        redcard_lines    : PROP_REDCARDS card_body PROP_END NEWLINE
                             {
                               @tree << CardsLine.new( type: 'R', bookings: val[1] )
                             }

         ## use player_booking or such
         card_body :  player_w_minute
                        {
                           ## note - value must be DOUBLE [[]] nested in array
                           ##    allows separator for teams
                           ##   via semicolon (;) separator, see below!
                           result = [[val[0]]]
                        }
                   |  card_body card_sep player_w_minute
                        {
                          ## note - if lineup_sep is dash (-) start a new sub array!!
                          if val[1] == ';'
                            result << [val[2]]
                          else
                            result[-1] << val[2]
                          end
                        }

         card_sep  :  ','             { result = ',' }
                   |  ';'             { result = ';' }
                   |  ';' NEWLINE     { result = ';' }

         player_w_minute : PROP_NAME
                              { result = Booking.new( name: val[0].as_str )  }
                         | PROP_NAME MINUTE
                              { result = Booking.new( name:   val[0].as_str,
                                                      minute: Minute.new(**val[1].as_hash) )  }
