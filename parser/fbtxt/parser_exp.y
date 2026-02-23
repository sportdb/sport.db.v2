##
## to compile use
##    $ racc -o parser_exp.rb parser_exp.y


##
# experimental grammar 
#   try alternate rules / production
#    to check for shift/reduce conflicts and more


#
#
# naming convention
#   use _opt or _opts only if first production is empty!!
#     and, thus, makes the rule optional by default
#           because it can return empty result ({})



class RaccMatchParser

     rule 
       document :  # allow empty documents - why? why not?
                | elements

       elements : element 
                | elements element
               
                
        
       element
          : match_line
          | empty_line    
          | lineup_lines
          | error      ## todo/check - move error sync up to elements - why? why not?
              { puts "!! skipping invalid content (trying to recover from parse error):"
                pp val[0] 
                @errors << "parser error (recover) - skipping #{val[0].pretty_inspect}"
              }
 


        match_line
              :   match_opts  match  more_match_opts NEWLINE
                    {     
                       kwargs = {}.merge( val[0], val[1], val[2] )
                       @tree << MatchLine.new( **kwargs )
                    }
           

        match_opts
             :  /* empty */
             |  ord
             |  ord date   { result = {}.merge( val[0], val[1] ) }
             |  date
                
    
        ord : ORD          {  result = { ord: val[0][1][:value] } }


       date: : DATE                 {   result = { date: val[0][1]}  }
             | DATETIME             {   result = {}.merge( val[0][1] ) }
             | DATETIME TIME_LOCAL  {   result = { time_local: val[1][1] }.merge( val[0][1] )  }
             | TIME                 {   result = { time: val[0][1]}  }
             | TIME TIME_LOCAL      {   result = { time: val[0][1]}.merge( val[1][1])  }



        more_match_opts
             : /* empty */   {}
             | STATUS      ## note - for now status must be BEFORE geo_opts!!
                 {
                      ## todo - add possible status_notes too!!! 
                      result = { status: val[0][1][:status] }
                 }
             | STATUS geo      
                 { 
                     result = { status: val[0][1][:status] }.merge( val[1] ) 
                 }
             | geo    { result = {}.merge( val[0] ) }
   

        ## e.g.  @ Parc des Princes, Paris
        ##       @ München 
        geo      : '@' geo_values           { result = { geo: val[1] } }
          
        geo_values
               :  TEXT                    {  result = val }
               |  geo_values ',' TEXT     {  result.push( val[2] )  }      


         match  :   match_result
                |   match_fixture 


         match_sep :  '-' | VS
            ## note - does NOT include SCORE; use SCORE terminal "in-place" if needed

         match_fixture :  TEAM match_sep TEAM
                           {
                               trace( "RECUDE match_fixture" )
                               result = { team1: val[0],
                                          team2: val[2] }   
                           }
  

        match_result :  TEAM  SCORE  TEAM
                         {
                           trace( "REDUCE => match_result : TEXT  SCORE  TEXT" )
                           result = { team1: val[0],
                                      team2: val[2],
                                      score: val[1][1]
                                    }   
                        }
                     |  match_fixture SCORE
                        {
                          trace( "REDUCE  => match_result : match_fixture SCORE" )
                          result = { score: val[1][1] }.merge( val[0] )  
                        }
                                        
   

        empty_line: NEWLINE
                    { trace( "REDUCE empty_line" ) }
            
 


        ## change PROP to LINEUP_TEAM
        ## change PROP_NAME to NAME or LINEUP_NAME
        ##
        ##  try without ending dot 
        ##   was PROP lineup '.' NEWLINE
        ##   change to/try
        ##       PROP lineup NEWLINE
       lineup_lines  : PROP lineup NEWLINE    ## fix add NEWLINE here too!!!
                        {  @tree << LineupLine.new( team:    val[0],
                                                    lineup:  val[1]
                                                  ) 
                        }


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


      lineup_name    :    PROP_NAME lineup_name_opts
                           {
                              kwargs = { name: val[0] }.merge( val[1] )
                              result = Lineup.new( **kwargs )
                           }

       lineup_name_opts : /* empty */   { result = {} }
                        | card 
                            {
                              result = { card: val[0] }
                            }
                        | card lineup_sub
                            {
                              result = { card: val[0], sub: val[1] }
                            }
                        | lineup_sub 
                            {
                              result = { sub: val[0] }
                            }
                
        ## todo/fix - use goal_minute and minute (w/o pen/og etc.)
       lineup_sub   :  '(' MINUTE lineup_name ')'    
                          {
                              result = Sub.new( minute: Minute.new(val[1][1]), 
                                                sub:    val[2] )
                          }



       card         :   '[' card_body ']'
                          {
                              kwargs = val[1]
                              result = Card.new( **kwargs )
                          }
       
       card_body    :     card_type
                           { result = { name: val[0] } } 
         ## todo/fix - use goal_minute and minute (w/o pen/og etc.)                          
                    |     card_type MINUTE
                           { result = { name: val[0], minute: Minute.new(val[1][1]) } }
                     

       card_type    :  YELLOW_CARD | RED_CARD 

end

