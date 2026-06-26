


        yellowcard_line : PROP_YELLOWCARDS card_body PROP_END NEWLINE
                             {
                               @tree << CardsLine.new( type: 'Y', bookings: val[1] )
                             }
        redcard_line     : PROP_REDCARDS card_body PROP_END NEWLINE
                             {
                               @tree << CardsLine.new( type: 'R', bookings: val[1] )
                             }
        yellowredcard_line  : PROP_YELLOWREDCARDS card_body PROP_END NEWLINE
                             {
                               @tree << CardsLine.new( type: 'Y/R', bookings: val[1] )
                             }

        ## use for "generic"  red|yellow/red cards  or pre-card era
        sentoff_line    : PROP_SENTOFF card_body PROP_END NEWLINE
                             {
                               @tree << CardsLine.new( type: 'SENTOFF', bookings: val[1] )
                             }


         ##
         ##  note - cards uses bookings:
         ##     (i)  []          -  single line (no separator)
         ##     (ii) [[],[]]     -  nested w/ bookings1/2 (separator or none required)

         card_body     : cards                  { result =  val[0]           }
                       | cards CARDS_NONE_RIGHT { result = [val[0], []]      }
                       | CARDS_NONE_LEFT cards  { result = [[],     val[1]]   }
                       | cards cards_sep cards  { result = [val[0], val[2]]  }


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
