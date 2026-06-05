
##########################################################################
##     level 2 support for properties - line-up, penalties, etc.


        attendance_line  : PROP_ATTENDANCE  PROP_NUM  PROP_END NEWLINE
                              {
                                 @tree << AttendanceLine.new( att: val[1].value[:value] )
                              }

        ## note - allow inline attendance prop in same line
        referee_line   :  PROP_REFEREE  referees  attendance_opt PROP_END NEWLINE
                            {
                               @tree << RefereeLine.new( referees: val[1] )
                            }

       attendance_opt   : /* empty */
                        | ';' ATTENDANCE  PROP_NUM
                           {
                                 @tree << AttendanceLine.new( att: val[2].value[:value] )
                           }

        referees  :     referee
                          { result = [val[0]] }
                  |     referees ',' referee
                          {  result = (val[0] << val[2]) }

        referee  :      PROP_NAME
                         {  result = Referee.new( name: val[0].value ) }
                 |      PROP_NAME  ENCLOSED_NAME
                         {  result = Referee.new( name: val[0].value, country: val[1].value ) }


        penalties_lines : PROP_PENALTIES penalties_body PROP_END NEWLINE
                            {
                               @tree << PenaltiesLine.new( penalties: val[1] )
                            }

        penalties_body  :  penalty                             {  result = [val[0]]  }
                        |  penalties_body penalty_sep penalty  {  result << val[2]  }


        penalty_sep     :  ','
                        |  ',' NEWLINE
                        |  ';'
                        |  ';' NEWLINE

        penalty         :  SCORE PROP_NAME
                              {
                                 result = Penalty.new( score: val[0].value[:score],
                                                       name: val[1].value )
                              }
                        |  SCORE PROP_NAME ENCLOSED_NAME
                               {
                                 result = Penalty.new( score: val[0].value[:score],
                                                       name: val[1].value,
                                                       note: val[2].value )
                               }
                        | PROP_NAME
                               {
                                 result = Penalty.new( name: val[0].value )
                               }
                        |  PROP_NAME ENCLOSED_NAME        ## e.g. (save), (post), etc
                               {
                                 result = Penalty.new( name: val[0].value,
                                                       note: val[1].value )
                               }


        yellowcard_lines : PROP_YELLOWCARDS card_body PROP_END NEWLINE
                             {
                               @tree << CardsLine.new( type: 'Y', bookings: val[1] )
                             }
        redcard_lines    : PROP_REDCARDS card_body PROP_END NEWLINE
                             {
                               @tree << CardsLine.new( type: 'R', bookings: val[1] )
                             }

         ## use player_booking or such
         ##   note - ignores possible team separator (;) for now
         ##               returns/ builds all-in-one "flat" list/array
         card_body :  player_w_minute
                        {   result = [val[0]]  }
                   |  card_body card_sep player_w_minute
                        {  result << val[2]  }

         card_sep  :  ','
                   |  ';'
                   |  ';' NEWLINE

         player_w_minute : PROP_NAME
                              { result = Booking.new( name: val[0].value )  }
                         | PROP_NAME MINUTE
                              { result = Booking.new( name:   val[0].value,
                                                      minute: val[1].value )  }



        ## change PROP to LINEUP_TEAM
        ## change PROP_NAME to NAME or LINEUP_NAME
       lineup_lines  : PROP lineup coach_opt PROP_END NEWLINE     ## fix add NEWLINE here too!!!
                        {
                          kwargs = { team:    val[0].value,
                                     lineup:  val[1]  }.merge( val[2] )
                          @tree << LineupLine.new( **kwargs )
                        }

       coach_opt   : /* empty */
                           { result = {}  }
                   | ';' COACH  PROP_NAME
                           {  result = { coach: val[2].value } }
                   | ';' NEWLINE  COACH  PROP_NAME    ## note - allow newline break
                           {  result = { coach: val[3].value } }

       lineup :   lineup_name
                    { result = [[val[0]]] }
              |   lineup lineup_sep lineup_name
                    {
                       ## if lineup_sep is -  start a new sub array!!
                       if val[1] == '-'
                          result << [val[2]]
                       else
                          result[-1] << val[2]
                       end
                    }


       lineup_sep  :  ','
                     | ',' NEWLINE  { result = val[0]   }
                     | '-'
                     | '-' NEWLINE  { result = val[0]   }



       lineup_cards_opts      : /* empty */   { result = {} }
                              |  cards         { result = { cards: val[0] } }

       lineup_captain_opt     : /* empty */   { result = {} }
                              | INLINE_CAPTAIN  { result = { captain: true }}

       lineup_name_plus_cards_opts :  PROP_NAME  lineup_captain_opt  lineup_cards_opts
                                      {
                                        result = { name: val[0].value }.merge( val[1]).merge( val[2] )
                                      }

      lineup_name   :   lineup_name_plus_cards_opts   lineup_sub_opts
                           {
                              kwargs = {}.merge(val[0] ).merge( val[1])
                              result = Lineup.new( **kwargs )
                           }



        ##  allow nested subs e.g.
        ##     Clément Lenglet
        ##          (Kingsley Coman 46'
        ##             (Marcus Thuram 111'))
        ##
        ##  note -  lineup_name MINUTE is NOT working as expected, expects
        ##     Clément Lenglet
        ##          ( Kingsley Coman
        ##              ( Marcus Thuram 111' )
        ##            46'
        ##          )
        ##   thus use a "special" hand-coded recursive rule


         lineup_sub_opts : /* empty */   { result = {} }
                         | '(' lineup_name_plus_cards_opts  MINUTE  lineup_sub_opts ')'
                          {
                              kwargs = {}.merge( val[1] ).merge( val[3] )
                              sub    = Sub.new( sub:    Lineup.new( **kwargs ),
                                                minute: Minute.new(val[2].value)
                                              )
                              result = { sub: sub }
                          }
                       |  '(' lineup_name ')'    ## allow subs without minutes too
                           {
                              sub = Sub.new( sub: val[1] )
                              result = { sub: sub }
                           }
                  ## allow both styles? minute first or last? keep - yes, yes, yes
                  ##  why? why not?
                    |   '(' MINUTE lineup_name ')'
                          {
                              sub = Sub.new( sub:    val[2],
                                             minute: Minute.new(val[1].value)
                                            )
                              result = { sub: sub }
                          }


      cards
        :         INLINE_YELLOW
                     { result = [{ card: 'YELLOW' }.merge( val[0].value )] }
        |         INLINE_YELLOW INLINE_YELLOW_RED
                     { result = [{ card: 'YELLOW' }.merge( val[0].value ),
                                 { card: 'YELLOW_RED' }.merge( val[1].value)]  }
        |         INLINE_YELLOW INLINE_RED
                    { result = [{ card: 'YELLOW' }.merge( val[0].value ),
                                { card: 'RED' }.merge( val[1].value)]  }
        |         INLINE_RED
                    {  result = [{ card: 'RED' }.merge( val[0].value)] }
        |         INLINE_YELLOW_RED
                    {  result = [{ card: 'YELLOW_RED' }.merge( val[0].value)] }
