

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


          ##
          ##  note - no captain flag  in subs for now (only in "top-level" lineup)



## rename to lineup_sub_line/details/props or such - why? why not?

         lineup_sub_props
                       ## allow subs WITHOUT minutes  (but optional cards!)
                       : PROP_NAME  lineup_cards_opts
                          {
                             _trace( "REDUCE => lineup_sub_props : PROP_NAME  lineup_cards_opts" )
                             result = { name: val[0].as_str }.merge( val[1] )
                          }

                       ##  allow minute last (AFTER cards!) in subs e.g.
                       ##     Schiener (Scharrer 46 [R 115])
                       | PROP_NAME  MINUTE  lineup_cards_opts
                           {
                             _trace( "REDUCE => lineup_sub_props : PROP_NAME  MINUTE  lineup_cards_opts" )
                              result = { name:   val[0].as_str,
                                         minute: Minute.new(val[1].as_hash)
                                       }.merge( val[2])
                           }
                       ##   note - minutes AFTER cards  (note - card REQUIRED
                       ##           otherwise rule PROP_NAME MINUTE lineup_cards_opts will match)
                       ##     Schiener (Scharrer [R 115] 46)
                       | PROP_NAME  cards  MINUTE
                           {
                             _trace( "REDUCE => lineup_sub_props : PROP_NAME  cards  MINUTE" )
                              result = { name:   val[0].as_str,
                                         minute: Minute.new(val[2].as_hash),
                                         cards:  val[1]
                                       }
                           }

                       ## allow both styles? minute first or last? keep - yes, yes, yes
                       ##  why? why not?
                       | MINUTE  PROP_NAME  lineup_cards_opts
                           {
                             _trace( "REDUCE => lineup_sub_props : MINUTE  PROP_NAME  lineup_cards_opts" )

                               result =  { name:   val[1].as_str,
                                          minute: Minute.new(val[0].as_hash)
                                        }.merge( val[2])
                           }





## fix-fix-fix
##   rename to opt_lineup_sub


         lineup_sub_opts   : /* empty */    {  result = {}   }
                           | lineup_sub


         ##
         ## note - allow nested (recursive) subs (player (player))
         ##                                       (player (player (player)))

         lineup_sub       : '(' lineup_sub_contents ')'    {  result = val[1] }

         lineup_sub_contents   :  lineup_sub_props
                                    {
                                   _trace( "REDUCE => lineup_sub_contents : line_sub_props" )
                                   kwargs  = {}.merge( val[0] )
                                   minute  = kwargs.delete( :minute )
                                   sub = Sub.new(  sub:     Lineup.new( **kwargs ),
                                                   minute:  minute )
                                   result = { sub: sub }
                                    }
                               |  lineup_sub_props lineup_sub
                                    {
                                    _trace( "REDUCE => lineup_sub_contents : line_sub_props lineup_sub" )
                                   kwargs  = {}.merge( val[0] ).merge( val[1] )
                                   minute  = kwargs.delete( :minute )
                                   sub = Sub.new(  sub:     Lineup.new( **kwargs ),
                                                   minute:  minute )
                                   result = { sub: sub }
                                    }





/*
                      ##   note - minutes AFTER cards
                      ##     Schiener (Scharrer [R 115] 46)
                      ##   | '(' lineup_name_plus_cards_opts  MINUTE  lineup_sub_opts ')'
                        | '(' PROP_NAME lineup_cards_opts  MINUTE  lineup_sub_opts ')'
                          {
                              kwargs = { name: val[0].as_str }.merge( val[1] ).merge( val[3] )
                              sub    = Sub.new( sub:    Lineup.new( **kwargs ),
                                                minute: Minute.new(val[2].as_hash)
                                              )
                              result = { sub: sub }
                          }
                     ##  allow minute last (AFTER cards!) in subs e.g.
                     ##     Schiener (Scharrer 46 [R 115])
                       | '(' PROP_NAME  MINUTE  lineup_cards_opts  lineup_sub_opts  ')'


                       |  '(' PROP_NAME lineup_sub_opts ')'    ## allow subs without minutes too
                           {
                              sub = Sub.new( sub: val[1] )
                              result = { sub: sub }
                           }
                  ## allow both styles? minute first or last? keep - yes, yes, yes
                  ##  why? why not?
                    |   '(' MINUTE PROP_NAME lineup_card_opts lineup_sub_opts ')'
                          {
                              sub = Sub.new( sub:    val[2],
                                             minute: Minute.new(val[1].as_hash)
                                            )
                              result = { sub: sub }
                          }


*/



      cards
        :         INLINE_YELLOW
                     {  result = [Card.build( name: 'Y',   minute: val[0].as_hash)] }
        |         INLINE_YELLOW  INLINE_YELLOW_RED
                     {  result = [Card.build( name: 'Y',   minute: val[0].as_hash),
                                  Card.build( name: 'Y/R', minute: val[1].as_hash)]  }
        |         INLINE_YELLOW  INLINE_RED
                     {  result = [Card.build( name: 'Y',   minute: val[0].as_hash),
                                  Card.build( name: 'R',   minute: val[1].as_hash)]  }
        |         INLINE_RED
                     {  result = [Card.build( name: 'R',   minute: val[0].as_hash)] }
        |         INLINE_YELLOW_RED
                     {  result = [Card.build( name: 'Y/R', minute: val[0].as_hash)] }
