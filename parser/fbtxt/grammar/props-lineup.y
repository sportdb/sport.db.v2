

        ## change PROP to PROP_LINEUP
        ## change PROP_NAME to NAME - why? why not?


       lineup_lines  : PROP lineup coach_opt PROP_END NEWLINE
                        {
                          kwargs = { team:    val[0].as_str,
                                     lineup:  val[1]  }.merge( val[2] )
                          @tree << LineupLine.new( **kwargs )
                        }


       coach_opt   : /* empty */    { result = {}  }   ## optional
                   | ';' COACH  PROP_NAME
                           {  result = { coach: val[2].as_str } }
                   | ';' NEWLINE  COACH  PROP_NAME    ## note - allow newline break
                           {  result = { coach: val[3].as_str } }
                  | '-' COACH  PROP_NAME
                           {  result = { coach: val[2].as_str } }
                   | '-' NEWLINE  COACH  PROP_NAME    ## note - allow newline break
                           {  result = { coach: val[3].as_str } }



       lineup_sep  :  ','           { result = ',' }
                     | ',' NEWLINE  { result = ',' }
                     | '-'          { result = '-' }
                     | '-' NEWLINE  { result = '-' }


       lineup :   lineup_name
                    { result = [[val[0]]] }
              |   lineup lineup_sep lineup_name
                    {
                       ## note - if lineup_sep is dash (-) start a new sub array!!
                       if val[1] == '-'
                          result << [val[2]]
                       else
                          result[-1] << val[2]
                       end
                    }


     lineup_name   :   lineup_name_plus_cards_opts   lineup_sub_opts
                           {
                              kwargs = {}.merge(val[0] ).merge( val[1])
                              result = Lineup.new( **kwargs )
                           }


      lineup_name_plus_cards_opts :  PROP_NAME  lineup_captain_opt  lineup_cards_opts
                                      {
                                        result = { name: val[0].as_str }.merge( val[1]).merge( val[2] )
                                      }


       lineup_captain_opt     :  /* empty */    { result = {} }   ## optional
                              | INLINE_CAPTAIN  { result = { captain: true }}

       lineup_cards_opts      :  /* empty */   { result = {} }   ## optional
                              |  cards         { result = { cards: val[0] } }




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
                                                minute: Minute.new(val[2].as_hash)
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
                                             minute: Minute.new(val[1].as_hash)
                                            )
                              result = { sub: sub }
                          }



      cards
        :         INLINE_YELLOW
                     { result = [{ card: 'YELLOW' }.merge( val[0].as_hash )] }
        |         INLINE_YELLOW INLINE_YELLOW_RED
                     { result = [{ card: 'YELLOW' }.merge( val[0].as_hash ),
                                 { card: 'YELLOW_RED' }.merge( val[1].as_hash)]  }
        |         INLINE_YELLOW INLINE_RED
                    { result = [{ card: 'YELLOW' }.merge( val[0].as_hash ),
                                { card: 'RED' }.merge( val[1].as_hash)]  }
        |         INLINE_RED
                    {  result = [{ card: 'RED' }.merge( val[0].as_hash)] }
        |         INLINE_YELLOW_RED
                    {  result = [{ card: 'YELLOW_RED' }.merge( val[0].as_hash)] }
