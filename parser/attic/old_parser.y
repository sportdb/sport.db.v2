
##########
##  note - match_header_date  is now the "generic"  date_clause (is date | datetime)
        match_header_date     ## note - only two option allowed (no "standalone" TIME etc.)
               : DATE            {   result = { date: val[0][1]}  }
               | DATETIME        {   result = {}.merge( val[0][1] ) }
               | DATETIME TIME_LOCAL  {
                                     result = { time_local: val[1][1] }.merge( val[0][1] ) 
                                 }
#########
##  note - more_date_opts is now simply time
 e.g.  time only e.g. 15.00,  or weekday with time only e.g. Fr 15.00
       more_date_opts
             : TIME                      {   result = { time: val[0][1]}  }
             | TIME TIME_LOCAL   {
                                             result = { time:        val[0][1],
                                                        time_local:  val[1][1] }
                                         }


        match_opts
             : date_clause
             | date_clause geo_opts {  result = val[0].merge( val[1]) }
             |  time      
             |  time geo_opts { result = val[0].merge( val[1]) }
             | ord date_clause          { result = {}.merge( val[0], val[1] )  }
             | ord date_clause geo_opts { result = {}.merge( val[0], val[1], val[2] ) }
             | ord time             { result = {}.merge( val[0], val[1] )  }
             | ord time geo_opts    { result = {}.merge( val[0], val[1], val[2] ) }



          |   match_fixture  more_match_opts NEWLINE
                  { 
                      kwargs = {}.merge( val[0], val[1] )
                      @tree << MatchLine.new( **kwargs )
                  }
               
               |   match_result  more_match_opts NEWLINE
                  { 
                      kwargs = {}.merge( val[0], val[1] )
                      @tree << MatchLine.new( **kwargs )
                  }
     

              
