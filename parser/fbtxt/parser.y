##
## to compile use
##    $ racc -o parser.rb parser.y
##      racc -o ../lib/sportdb/parser/parser.rb parser.y



#
#
# todo/try/check:
#    use/add empty production to 
#     match_pre and match_post options to simplify production if possible?



class RaccMatchParser

     rule 
       document : {}  # note - allow empty documents - why? why not?
                | elements

       elements : element 
                | elements element
               
                        
       element
          : heading       # e.g. h1,h2,h3, etc.
          | group_def
          | round_def
          | round_outline   
          | date_header 
          | match_line_with_header
          | match_line
          ## add support for "compact" match legs (1st leg, 2nd leg, aggregate)
          | date_header_legs
          | match_line_legs
 
          ## check - goal_lines MUST follow match_line - why? why not?     
          | goal_lines     
         ### | goal_lines_alt   ## allow differnt style/variant 
 
          | BLANK        ##  was empty_line
             { trace( "REDUCE BLANK" ) } 
          | lineup_lines
          | yellowcard_lines   ## use _line only - why? why not?
          | redcard_lines
          | penalties_lines   ## rename to penalties_line or ___ - why? why not? 
          | referee_line
          | attendance_line
          | error      ## todo/check - move error sync up to elements - why? why not?
              { puts "!! skipping invalid content (trying to recover from parse error):"
                pp val[0]
                ##  note - do NOT report recover errors for now 
                ##  @errors << "parser error (recover) - skipping #{val[0].pretty_inspect}"
              }
         ### use   error NEWLINE - why? why not?
         ##           will (re)sync on NEWLINE?

    


        attendance_line  : PROP_ATTENDANCE  PROP_NUM  PROP_END NEWLINE
                              {
                                 @tree << AttendanceLine.new( att: val[1][1][:value] )
                              }

        ## note - allow inline attendance prop in same line
        referee_line   :  PROP_REFEREE  referee  attendance_opt PROP_END NEWLINE
                            {
                               kwargs = val[1] 
                               @tree << RefereeLine.new( **kwargs ) 
                            }

       attendance_opt   : /* empty */   
                        | ';' ATTENDANCE  PROP_NUM
                           { 
                                 @tree << AttendanceLine.new( att: val[2][1][:value] )
                           }
                  

        referee  :      PROP_NAME
                         {  result = { name: val[0]} }
                 |      PROP_NAME  ENCLOSED_NAME  
                         {  result = { name: val[0], country: val[1] } }   
                 

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
                                 result = Penalty.new( score: val[0][1][:score],
                                                       name: val[1] )
                              }
                        |  SCORE PROP_NAME ENCLOSED_NAME
                               {
                                 result = Penalty.new( score: val[0][1][:score],
                                                       name: val[1],
                                                       note: val[2] )
                               }
                        | PROP_NAME
                               {
                                 result = Penalty.new( name: val[0] )                                
                               }
                        |  PROP_NAME ENCLOSED_NAME        ## e.g. (save), (post), etc
                               {
                                 result = Penalty.new( name: val[0],
                                                       note: val[1] )                                
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
                              { result = Booking.new( name: val[0] )  }
                         | PROP_NAME MINUTE  
                              { result = Booking.new( name: val[0], minute: val[1][1] )  }



        ## change PROP to LINEUP_TEAM
        ## change PROP_NAME to NAME or LINEUP_NAME
       lineup_lines  : PROP lineup coach_opt PROP_END NEWLINE     ## fix add NEWLINE here too!!!
                        {  
                          kwargs = { team:    val[0],
                                     lineup:  val[1]  }.merge( val[2] ) 
                          @tree << LineupLine.new( **kwargs ) 
                        }

       coach_opt   : /* empty */   
                           { result = {}  }
                   | ';' COACH  PROP_NAME
                           {  result = { coach: val[2] } }
                   | ';' NEWLINE  COACH  PROP_NAME    ## note - allow newline break
                           {  result = { coach: val[3] } }
 
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
                     

      lineup_name    :    PROP_NAME  lineup_card_opts  lineup_sub_opts   
                           {
                              kwargs = { name: val[0] }.merge( val[1] ).merge( val[2] )
                              result = Lineup.new( **kwargs )
                           }

       lineup_card_opts      : /* empty */   { result = {} }
                             |  card         { result = { card: val[0] } }


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
                         | '(' PROP_NAME  lineup_card_opts  MINUTE  lineup_sub_opts ')'    
                          {
                              kwargs = { name: val[1] }.merge( val[2] ).merge( val[4] )
                              sub    = Sub.new( sub:    Lineup.new( **kwargs ),
                                                minute: Minute.new(val[3][1]) 
                                              )
                              result = { sub: sub }
                          }
                       |  '(' lineup_name ')'    ## allow subs without minutes too
                           {
                              sub = Sub.new( sub: val[1] )
                              result = { sub: sub }
                           }      
                  ## allow both styles? minute first or last? keep - why? why not?
                    |   '(' MINUTE lineup_name ')'    
                          {
                              sub = Sub.new( sub:    val[2],
                                             minute: Minute.new(val[1][1]) 
                                            )
                              result = { sub: sub }
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
                           { result = { name: val[0],
                                        minute: Minute.new(val[1][1]) } 
                           }
                     

       card_type    :  YELLOW_CARD | RED_CARD 




       heading
           : H1 NEWLINE   {  @tree << Heading1.new( text: val[0])  }
           | H2 NEWLINE   {  @tree << Heading2.new( text: val[0])  }
           | H3 NEWLINE   {  @tree << Heading3.new( text: val[0])  }
           

        ######  
        # e.g   Group A  |    Germany   Scotland     Hungary   Switzerland   
        group_def
              :   GROUP_DEF '|'  team_values   NEWLINE  
                  {
                      @tree << GroupDef.new( name:  val[0],
                                             teams: val[2] )
                  }

        team_values
              :   TEAM                       { 
                                               result = val
                                               ## e.g. val is ["Austria"] 
                                             }
              |   team_values TEAM           {
                                               result.push( val[1] )
                                             }


        #####
        # e.g.  Matchday 1  |  Fri Jun/14 - Tue Jun/18   
        round_def
             :  ROUND_DEF '|'  round_date_opts   NEWLINE
                  {
                      kwargs = { name: val[0] }.merge( val[2] )
                      @tree<< RoundDef.new( **kwargs )
                  }


        round_date_opts  :   DATE        { result = { date: val[0][1] } } 
                         |  DURATION     { result = { duration: val[0][1] } }


        ## note - only one option (DATE) allowed for "standalone" header now
        ##            use match header (with geo tree) 
        date_header
              :     DATE  NEWLINE
                  {
                     kwargs = { date: val[0][1]  }
                     @tree <<  DateHeader.new( **kwargs )  
                  }
            
        date_header_legs
             :     DATE_LEGS  NEWLINE
                  {
                     kwargs =  val[0][1]  
                     @tree <<  DateHeaderLegs.new( **kwargs )                      
                  }

         ###
         #  note - match_line_with_header 
         #     support less variants (no geo/date/time) in match line (already in header)
         #             use match_line_header to syntax check via parser
         match_line_with_header 
               :  match_header  match_line_header
                  {
                     ## todo/fix - add header flag (header: true)
                     ##    used downstream for scope / e.g. DateHeader merge/inheritance or such                     
                      kwargs = { header: true }.merge( val[0], val[1] )
                      @tree << MatchLine.new( **kwargs )  
                  }

         match_line_header    
               :  match  more_match_header_opts 
                  { 
                      result = {}.merge( val[0], val[1] )
                  }
     
        more_match_header_opts
             : STATUS NEWLINE      ## note - for now status must be BEFORE geo_opts!!
                 {
                      ## todo - add possible status_notes too!!! 
                      result = { status: val[0][1][:status] }
                 }
             | NOTE NEWLINE        { result = { note: val[0] } }
             | NEWLINE             { result = {} }



        ### note - match_header MUST incl. geo tree!!!
       match_header       
            :     match_header_body   NEWLINE  {  result = val[0]  }
            
         match_header_body              
               : match_header_date geo_opts opt_inline_attendance   
                   { 
                      result = {}.merge( val[0], val[1], val[2] ) 
                   }
               

         ## todo/fix - allow (inline) attendance in match w/o header too
         ##              for now match header required
         ##
         ##  note - use "hack" with INLINE_ATTENDANCE_SEP (a.k.a comma (,))
         ##           to help with shift/reduce conflict
         opt_inline_attendance
              :    {  result = {}  }    ## empty; make rule optinal, returns {}
              |   INLINE_ATTENDANCE   
                    { 
                       result = { att: val[0][1][:value] }
                    }
              |  INLINE_ATTENDANCE_SEP  INLINE_ATTENDANCE  
              ## |  ','  INLINE_ATTENDANCE  
                    { 
                       result = { att: val[1][1][:value] }
                    }


        match_header_date     ## note - only two option allowed (no "standalone" TIME etc.)
               : DATE            {   result = { date: val[0][1]}  }
               | DATETIME        {   result = {}.merge( val[0][1] ) }
               | DATETIME TIME_LOCAL  {
                                     result = { time_local: val[1][1] }.merge( val[0][1] ) 
                                 }


####
##   round ouline for now all-in-one line 
##       todo - split-up in tokens
         round_outline :    ROUND_OUTLINE NEWLINE
                              { 
                                  @tree << RoundOutline.new( outline: val[0] )
                              }


     ### experimental "compact" leg-style match format
     ##     no date/time in match line REQUIRES date_legs_header for now
     ##             (otherwise) date unknown!!
        match_line_legs
              : match_fixture  SCORE_LEGS  NEWLINE
                {
                      kwargs = { score: val[1][1] }.merge( val[0] )
                      @tree << MatchLineLegs.new( **kwargs )             
                }

        match_line
              :   match_opts  match  more_match_opts
                    {     
                       kwargs = {}.merge( val[0], val[1], val[2] )
                       @tree << MatchLine.new( **kwargs )
                    }
              |   match  more_match_opts 
                  { 
                      kwargs = {}.merge( val[0], val[1] )
                      @tree << MatchLine.new( **kwargs )
                  }
         

        match_opts
             # :  date_header_body    ## note: same as (inline) date header but WITHOUT newline!!!
             : match_header_date
             | match_header_date geo_opts {  result = val[0].merge( val[1]) }
             |  more_date_opts      
             |  more_date_opts geo_opts { result = val[0].merge( val[1]) }
          
       ### e.g.  time only e.g. 15.00,  or weekday with time only e.g. Fr 15.00
       more_date_opts
             : TIME                      {   result = { time: val[0][1]}  }
             | TIME TIME_LOCAL   {
                                             result = { time:        val[0][1],
                                                        time_local:  val[1][1] }
                                         }
      

        ##
        ## todo/fix - NOTE is ignored for now; add to parse tree!!!
        ##    assume NOTE is always (MUST BE) LAST option for now 
        ##      AND  you cannot use both STATUS and NOTE - why? why not?
        ##
        ##   allow/add lines with NOTE only - why? why not?
        ##        e.g. [nb: xxxxxx] or such

        more_match_opts
             : STATUS NEWLINE      ## note - for now status must be BEFORE geo_opts!!
                 {
                      ## todo - add possible status_notes too!!! 
                      result = { status: val[0][1][:status] }
                 }
             | STATUS geo_opts NEWLINE      
                 { 
                     result = { status: val[0][1][:status] }.merge( val[1] ) 
                 }
             | geo_opts NEWLINE             { result = {}.merge( val[0] ) }
             | geo_opts NOTE NEWLINE        { result = { note: val[1] }.merge( val[0] ) }
             | NOTE NEWLINE                 { result = { note: val[0] } }
             | NEWLINE                      { result = {} }


        ## e.g.  @ Parc des Princes, Paris
        ##       @ München 
        ##       @ Luzhniki Stadium, Moscow (UTC+3)
        geo_opts : '@' geo_values           { result = { geo: val[1] } }
         
         ###  note -  timezone for now moved to time use  13.00 (UTC+3) and such
         ##               maybe add back later for the geo table def lines
         ###       | '@' geo_values TIMEZONE  { result = { geo: val[1], timezone: val[2] } }

        geo_values
               :  GEO                         {  result = val }
               |  geo_values ',' GEO          {  result.push( val[2] )  }      




         match  :   match_result
                |   match_fixture 
                    
         match_fixture :  TEAM match_sep TEAM
                           {
                               trace( "RECUDE match_fixture" )
                               result = { team1: val[0],
                                          team2: val[2] }   
                           }

         match_sep :  '-' | VS
            ## note - does NOT include SCORE; use SCORE terminal "in-place" if needed
  

         score_full_or_fuller   
                : SCORE_FULL      ## full format    1-1 (0-1)
                                  ##             or 2-1 a.e.t. etc.
                | SCORE_FULLER    ## note - SCORE_FULLER NOT supported inline!!
                                  ##       only after  Team1 v Team2 !!
                   
      
        ## note - "inline" SCORE_NOTE-style is NOT allowed/supported
        ##                 only basic (SCORE) and more (SCORE_MORE)
        match_result :  TEAM  SCORE  TEAM      
                         {
                           trace( "REDUCE => match_result : TEAM SCORE TEAM" )
 
                          ## note - use/keep generic score (as array!! NOT hash!!!)
                          
                           result = { team1: val[0],
                                      team2: val[2],
                                      score: val[1][1][:score]  ## note - as array e.g. [1,1] !!
                                    }   
                           ## pp result
                        }
                     | TEAM SCORE TEAM SCORE_FULLER_MORE
                          {
                            trace( "REDUCE => match_result : TEAM SCORE TEAM SCORE_FULLER_MORE" )
                            score = nil
                            score =  if val[3][1][:aet]  ## check aet flag present? 
                                       ## note - remove/delete aet flag
                                       val[3][1].delete( :aet )
                                       { et: val[1][1][:score] }
                                     else   ## assume full-time (ft)
                                       { ft: val[1][1][:score] }
                                     end 
                           result = {  team1: val[0],
                                      team2: val[2],
                                      score: score.merge( val[3][1] )
                                    }                                    
                          }
                     | TEAM SCORE_FULL TEAM
                         {
                           result = { team1: val[0],
                                      team2: val[2],
                                      score: val[1][1]
                                    }                          
                         } 
                     |  match_fixture  SCORE   ## note - keep "plain/generic" score separate rule
                        {
                          trace( "REDUCE  => match_result : match_fixture SCORE" )
                          ## note - use/keep generic score (as array!! NOT hash!!!)
                          result = { score: val[1][1][:score]  ## note - as array e.g. [1,1] !! 
                                   }.merge( val[0] )  
                          ## pp result
                        }
                     |  match_fixture  score_full_or_fuller
                        {
                          trace( "REDUCE  => match_result : match_fixture score" )
                          result = { score: val[1][1] }.merge( val[0] )  
                          ## pp result
                        }
                     |  match_fixture  SCORE_NOTE     ## e.g. 1-1 [aet, 4-5 on penalties]
                        {
                           ## todo/fix - pass along (experimental) SCORE_NOTE!!
                           trace( "REDUCE  => match_result : match_fixture SCORE_NOTE" )
                           result = {}.merge( val[0] )  
                           ## pp result
                        }
                                        
   
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
        # note: allow newlines between goals
        #   for now possible after ;  and after , (if player with ALL goal_minutes)
        #



        ###
        ##   todo/fix add multi-line too!!
        ##
        ##  fix - for optional WITHOUT minutes
        #             make possible (og) and (pen) too!!! - missing fo now
#        goal_lines_alt : goals_alt NEWLINE
#                           {
#                             @tree << GoalLineAlt.new( goals: val[0] )
#                           }
#
#        goals_alt   :  goal_alt
#                        { result = val }
#                    |  goals_alt goal_alt_sep goal_alt  ## allow optional comma sep
#                        { result.push( val[2])  } 
#                    |  goals_alt goal_alt
#                        { result.push( val[1])  }
#                 
#        goal_alt_sep :  ','
#                     |  ',' NEWLINE    ## allow multiline goallines!!!
#
#
#        goal_alt    :  SCORE PLAYER     ## note - minute is optinal in alt goalline style!!!
#                        {
#                           result = GoalAlt.new( score:   val[0],
#                                                 player:  val[1] )
#                        }   
#                    |  SCORE PLAYER minute
#                        {
#                           result = GoalAlt.new( score:  val[0],
#                                                 player: val[1],
#                                                 minute: val[2] )
#                        }   
#


     ###
     #  merge  goal_lines_alt into goal_lines (or keep separate)    why? why not?
     #
     #  e.g.
     #     (E. Hazard,  R. Lukaku,  Batshuayi; Bronn, Khazri)
     #     (R. Lukaku, Batshuayi)          
     #
     #    todo: add  (pen.) or (og.) too - why? why not?
     #    todo:  find some real-world examples
     #           and add goal count e.g.   R. Lukaku 2 or such - why? why not?
     #          what syntax to use use for one (regular) goal and one penalty, for example?
     #
     #    (Higuaín x2 (1 pen); Kane, Eriksen)
     #    (Higuaín x2; Kane (pen), Eriksen (og))
     #    (Higuaín ×2)
     #      or
     #    (Higuaín 2x (1 pen); Kane, Eriksen)    ???
     #    (Higuaín 2x; Kane (pen), Eriksen (og))  ???
     #      or
     #    (Higuaín (2/1 pen); Kane, Eriksen)    ???
     #    (Higuaín (2/ 1 pen); Kane, Eriksen)    ???
     #    (Higuaín (2); Kane (pen), Eriksen (og))  ???
     #
     #    (Higuaín (2); Kane, Eriksen)  ???
     #    (Higuaín; Kane (2), Eriksen)  ???
     #
     #   note:
     #    (Higuaín 2)    is ambigious
     #      2 might be    MINUTE or GOAL_COUNT!!!
     #    (> Higuaín 2)
     #    (! Higuaín 2)
     #    (* Higuaín 2)  - use goal format marker */?/!/_ or such - why? why not?
     #                         if ambigous ??
     #    (? Higuaín 2 (1 pen); Kane, Eriksen)
     #    (_ Higuaín 2 (1 pen); Kane, Eriksen)


#        goal_lines_alt : goal_lines_alt_body NEWLINE
#                      {
#                         kwargs = val[0]
#                         @tree << GoalLine.new( **kwargs )
#                      }
#                
#
#        goal_lines_alt_body : goals_alt                 {  result = { goals1: val[0],
#                                                              goals2: [] } 
#                                                }
#                        | GOALS_NONE goals_alt           {  result = { goals1: [],
#                                                              goals2: val[1] } 
#                                                }
#                        | goals_alt goals_sep goals_alt  {  result = { goals1: val[0],
#                                                              goals2: val[2] }
#                                                }#
#
#         goal_sep   : ','           ## note: separator REQUIRED!!!
#                    | ',' NEWLINE
#
#         goals_alt   : goal_alt                      { result = val }
#                     | goals_alt goal_sep goal_alt   { result.push( val[2])  }
#               
#         goal_alt    : PLAYER  
#                    {  
#                        ## note - for minutes pass-in empty array!!!
#                       result = Goal.new( player: val[0], minutes: [] )   
#                    }
         


        goal_lines : goal_lines_body NEWLINE
                      {
                         kwargs = val[0]
                         @tree << GoalLine.new( **kwargs )
                      }
                

        goal_lines_body : goals                 {  result = { goals1: val[0],
                                                              goals2: [] } 
                                                }
                        | GOALS_NONE goals           {  result = { goals1: [],
                                                              goals2: val[1] } 
                                                }
                        | goals goals_sep goals  {  result = { goals1: val[0],
                                                              goals2: val[2] }
                                                }

     
        goals_sep    : ';'
                     | ';' NEWLINE
                       

         goal_sep_opt   :  {}        ## none; optional!!
                        | ','
                        | ',' NEWLINE

         ## note - hacky: lexer MUST change comma 
         ##                  between GOAL_MINUTES to GOAL_MINUTE_SEP!!
         goal_minute_sep_opt : {}    ## none; optional!!!
                             | GOAL_MINUTE_SEP   

         goals   : goal                      { result = val }
                  | goals goal_sep_opt goal   { result.push( val[2])  }

         #####
         ## todo -  make comma required for player only 
         ##        (that is, no minutes or count)


         goal    : PLAYER goal_minutes 
                    {  
                       result = Goal.new( player:  val[0],
                                          minutes: val[1] )   
                    }
                 | PLAYER GOAL_COUNT
                     {
                        ### todo/check:
                        ##    auto convert/expand 
                        ##    count to minutes - why? why not?
                        result = Goal.new( player: val[0],
                                           count:  val[1][1] )
                     }
                 | PLAYER
                     {
                        result = Goal.new( player: val[0],
                                           minutes: [] )
                     }
                 

         goal_minutes  : goal_minute   {  result = val }
                       | goal_minutes goal_minute_sep_opt goal_minute  {  result.push( val[2])  }

         goal_minute : GOAL_MINUTE
                          {
                             kwargs = {}.merge( val[0][1] )
                             result = Minute.new( **kwargs )  
                          }
                                      
 
end

