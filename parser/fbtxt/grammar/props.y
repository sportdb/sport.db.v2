
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


################
##   fix-fix-fix - use goal like
##                       cards1, cards2   with possible none
##                         only allow one separator

        yellowcard_line : PROP_YELLOWCARDS card_body PROP_END NEWLINE
                             {
                               @tree << CardsLine.new( type: 'Y', bookings: val[1] )
                             }
        redcard_line     : PROP_REDCARDS card_body PROP_END NEWLINE
                             {
                               @tree << CardsLine.new( type: 'R', bookings: val[1] )
                             }
        yellowredcard_line  : PROP_REDYELLOWCARDS card_body PROP_END NEWLINE
                             {
                               @tree << CardsLine.new( type: 'Y/R', bookings: val[1] )
                             }

        ## use for "generic"  red|yellow/red cards  or pre-card era
        sentoff_line    : PROP_SENTOFF card_body PROP_END NEWLINE
                             {
                               @tree << CardsLine.new( type: 'SENTOFF', bookings: val[1] )
                             }


         #####
         ## use player_booking or such

         ##
         ##  note - cards uses bookings NOT bookings1/2!!!
         ##           not assigned to team1/team2
         ##    maybe use bookings: [] & [[],[]]  - why? why not?

         card_body :   cards                    { result = { bookings:  val[0] }}
                       | cards CARDS_NONE_RIGHT { result = { bookings1: val[0],
                                                             bookings2: []}}
                       | CARDS_NONE_LEFT cards  { result = { bookings1: [],
                                                             bookings2: val[1]}}
                       | cards cards_sep cards  { result = { bookings1: val[0],
                                                             bookings2: val[2]}}

        cards_sep    : ';'
                     | ';' NEWLINE
                     | CARDS_SEP_ALT     ## note - dash (-) with leading & trailing spaces required
                     | CARDS_SEP_ALT NEWLINE

          cards    :  player_w_minute
                         {  result = val }
                   |  cards  opt_card_sep  player_w_minute
                         {
                            result.push( val[2] )
                         }

         opt_card_sep  :  /* empty */
                       | ','
                       | ',' NEWLINE


         player_w_minute : PROP_NAME
                              { result = Booking.new( name: val[0].as_str )  }
                         | PROP_NAME MINUTE
                              { result = Booking.new( name:   val[0].as_str,
                                                      minute: Minute.new(**val[1].as_hash) )  }
