

        ## change PROP to PROP_LINEUP
        ## change PROP_NAME to NAME - why? why not?


       lineup_lines  : PROP  lineup  opt_coach  PROP_END NEWLINE
                        {
                          kwargs = { team:    val[0].as_str,
                                     lineup:  val[1]  }.merge( val[2] )
                          @tree << LineupLine.new( **kwargs )
                        }


       ## add (factor out) coach_sep  - why? why not?


       opt_coach   : /* empty */    { result = {}  }    ## optional
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
                    {
                       ## note - value must be DOUBLE [[]] nested in array
                       ##    allows formations (e.g. 4-3-3 or such)
                       ##   via dash (-) separator, see below!
                       result = [[val[0]]]
                    }
              |   lineup lineup_sep lineup_name
                    {
                       ## note - if lineup_sep is dash (-) start a new sub array!!
                       if val[1] == '-'
                          result << [val[2]]
                       else
                          result[-1] << val[2]
                       end
                    }


     lineup_name   :   PROP_NAME  opt_captain  opt_cards  opt_lineup_sub
                           {
                              kwargs = { name: val[0].as_str }.merge( val[1], val[2], val[3] )
                              result = Lineup.new( **kwargs )
                           }




       opt_captain   :  /* empty */    { result = {} }   ## optional
                     | INLINE_CAPTAIN  { result = { captain: true }}





        #####
        ##  note - allow nested subs e.g.
        ##     Clément Lenglet
        ##          (Kingsley Coman 46'
        ##             (Marcus Thuram 111'))
        ##
          ##
          ##  note - no captain flag  in subs for now (only in "top-level" lineup)



      ## rename to lineup_sub_line/details/props or such - why? why not?

         lineup_sub_props
                       ## allow subs WITHOUT minutes  (but optional cards!)
                       : PROP_NAME  opt_cards
                          {
                             _trace( "REDUCE => lineup_sub_props : PROP_NAME  opt_cards" )
                             result = { name: val[0].as_str }.merge( val[1] )
                          }

                       ##     Schiener (Scharrer 46 [R 115])
                       | PROP_NAME  MINUTE  opt_cards
                           {
                             _trace( "REDUCE => lineup_sub_props : PROP_NAME  MINUTE  opt_cards" )
                              result = { name:   val[0].as_str,
                                         minute: Minute.new( **val[1].as_hash )
                                       }.merge( val[2])
                           }
                       ##   note - minutes AFTER cards  (note - card REQUIRED
                       ##           otherwise rule PROP_NAME MINUTE lineup_cards_opts will match)
                       ##     Schiener (Scharrer [R 115] 46)
                       | PROP_NAME  cards  MINUTE
                           {
                             _trace( "REDUCE => lineup_sub_props : PROP_NAME  cards  MINUTE" )
                              result = { name:   val[0].as_str,
                                         minute: Minute.new( **val[2].as_hash ),
                                         cards:  val[1]
                                       }
                           }

                       ## allow both styles? minute first or last? keep - yes, yes, yes
                       ##  why? why not?
                       | MINUTE  PROP_NAME  opt_cards
                           {
                             _trace( "REDUCE => lineup_sub_props : MINUTE  PROP_NAME  opt_cards" )

                               result = { name:   val[1].as_str,
                                          minute: Minute.new( **val[0].as_hash )
                                        }.merge( val[2])
                           }






         opt_lineup_sub   : /* empty */    {  result = {}   }
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



      opt_cards      :  /* empty */   { result = {} }   ## optional
                     |  cards         { result = { cards: val[0] } }


     ##
     ## todo/check - should ALWAYS return array of cards!!!
     ###      result = [val[0]]
     ###  or  result = [val[0],val[1]]   should be default action
     ###   but really defaults to result = val[0] - why?

      cards
        : inline_yellow                     {  result =  [val[0]]  }
        | inline_yellow inline_yellow_red   {  result =  [val[0],val[1]]  }
        | inline_yellow inline_red          {  result =  [val[0],val[1]]  }
        | inline_red                        {  result =  [val[0]]  }
        | inline_yellow_red                 {  result =  [val[0]]  }


      inline_yellow
         :  INLINE_YELLOW
             {
                minute = val[0].as_hash.empty? ? nil : Minute.new( **val[0].as_hash )
                result = Card.new( name: 'Y',  minute: minute )
             }
      inline_yellow_red
         :  INLINE_YELLOW_RED
             {
                minute = val[0].as_hash.empty? ? nil : Minute.new( **val[0].as_hash )
                result = Card.new( name: 'Y/R',  minute: minute )
             }
      inline_red
         :  INLINE_RED
             {
                minute = val[0].as_hash.empty? ? nil : Minute.new( **val[0].as_hash )
                result = Card.new( name: 'R',  minute: minute )
             }
