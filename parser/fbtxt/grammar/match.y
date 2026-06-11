
        ##########
        ## optional ord(inal) match number e.g (1), (42), etc.

        ord  : ORD    {  result = { num: val[0].as_int } }

        opt_ord
           :         {  result = {}  }     ## empty -- optional
           | ord





         ###
         #  note - match_line_with_header
         #     support less variants (no geo/date/time) in match line (already in header)
         #             use match_line_header to syntax check via parser
         match_line_with_header
               :  match_header  opt_blank_lines  match_line_header
                  {
                     ## note - header flag (header: true)
                     ##    used downstream for scope / e.g. DateHeader merge/inheritance or such
                      kwargs = { header: true }.merge( val[0], val[2] )
                      @tree << MatchLine.new( **kwargs )
                  }

         match_line_header
               :  opt_ord  match  more_match_header_opts
                  {
                      result = {}.merge( val[0], val[1], val[2] )
                  }
                |  match_line_alt_props

              # |  match_alt NEWLINE
              #     {
              #        result = {}.merge( val[0] )
              #     }




        ### note - no geo in (more_)match_line (w/ header)
        ##               always incl. in header

        more_match_header_opts
             : STATUS NEWLINE
                 {
                      result = val[0].as_hash
                 }
             | NOTE NEWLINE        { result = { note: val[0].as_str } }
             | NEWLINE             { result = {} }



       ### note - match_header REQUIRES
       ##          (i) geo (tree) or
       ##          (ii) or inline_attendance
       ##
       match_header
            :     date_datetime geo opt_inline_attendance  NEWLINE
                   {
                      result = {}.merge( val[0], val[1], val[2] )
                   }
            |      date_datetime inline_attendance  NEWLINE
                   {
                      result = {}.merge( val[0], val[1] )
                   }

         ## todo/fix - allow (inline) attendance in match w/o header too
         ##              for now match header required
         ##
         ##  note - use "hack" with INLINE_ATTENDANCE_SEP (a.k.a comma (,))
         ##           to help with shift/reduce conflict
         inline_attendance
                : INLINE_ATTENDANCE
                    {
                       result = { att: val[0].as_hash[:value] }
                    }
              ## |  ','  INLINE_ATTENDANCE
                 |  INLINE_ATTENDANCE_SEP  INLINE_ATTENDANCE
                    {
                       result = { att: val[1].as_hash[:value] }
                    }

         opt_inline_attendance
              :    {  result = {}  }    ## empty; make rule optinal
              |    inline_attendance




        opt_inline_note
            :            {  result = {} }  ## empty -- optional
            | NOTE       {  result = { note: val[0].as_str } }







        match_line
              :   match_opts  match  more_match_opts NEWLINE
                    {
                       kwargs = {}.merge( val[0], val[1], val[2] )
                       @tree << MatchLine.new( **kwargs )
                    }
              |   match_opts  match  NEWLINE
                    {
                       kwargs = {}.merge( val[0], val[1])
                       @tree << MatchLine.new( **kwargs )
                    }
              |  match  more_match_opts NEWLINE
                    {
                       kwargs = {}.merge( val[0], val[1] )
                       @tree << MatchLine.new( **kwargs )
                    }
              |  match  NEWLINE
                    {
                       kwargs = {}.merge( val[0] )
                       @tree << MatchLine.new( **kwargs )
                    }

              |  match_bye  opt_inline_note  NEWLINE
                      {
                         kwargs = {}.merge( val[0], val[1] )
                         @tree << MatchLineBye.new( **kwargs )
                      }
              |  match_walkover  opt_inline_note   NEWLINE
                     {
                         kwargs = {}.merge( val[0], val[1] )
                         @tree << MatchLineWalkover.new( **kwargs )
                     }


               ###############
               ### note - for now inline goals only for "compact" match results
               ###           make more flexible (allow leading date/time etc. too)
               ###   plus allow  match status/note - why? why not?

               |   match_result  INLINE_GOALS  goal_lines_body GOALS_END  NEWLINE
                  {
                      kwargs = {}.merge( val[0] )
                      @tree << MatchLine.new( **kwargs )

                      kwargs = val[2]
                      @tree << GoalLine.new( **kwargs )
                  }


##         opt_inline_round :   /* empty */   { result = {} }
##                          | INLINE_ROUND    { result = { inline_round: val[0].as_str } }


        opt_inline_round_n_geo : /* empty */          { result = {} }
                             | INLINE_ROUND  opt_geo  {
                                   _trace( "REDUCE => INLINE_ROUND  opt_geo" )
                                    result = { round_inline: val[0].as_str }.merge( val[1] )
                                }


         ##
         ##   todo/check - make opt_inline_round (e.g. ▪18/▪QF etc)  more "flexible"
         ##                 even allow standalone - why? why not?

        match_opts
             : ord  opt_date  opt_inline_round_n_geo {
                                     result = {}.merge( val[0], val[1], val[2] )
                                }
             | date_datetime  opt_inline_round_n_geo   {
                                     result = {}.merge( val[0], val[1] )
                                }
             | time  opt_inline_round_n_geo   {
                                     result = {}.merge( val[0], val[1] )
                                }
             | geo


        ## note - you cannot use both STATUS and NOTE - why? why not?
        ##
        ##  todo/check - allow attendance w/o geo_tree - why? why not?
        ###
        ###   :   { result = {} }   ## empty -- optional


        more_match_opts
             : STATUS       ## note - for now status must be BEFORE geo!!
                 {
                      result = val[0].as_hash
                 }
             | STATUS geo opt_inline_attendance
                 {
                     result = {}.merge( val[0].as_hash, val[1], val[2] )
                 }
             | geo opt_inline_attendance opt_inline_note
                 {
                   result = {}.merge( val[0], val[1], val[2] )
                 }
             | NOTE   { result = { note: val[0].as_str } }





         match  :   match_result
                |   match_fixture

                ### note - match_fixtures with (match) status - do not use with scores
                ##                       e.g. Rapid v Austria 3-1
                |   match_fixture_not_played    ## note - uses n/p or canc/canc. as match separator
                |   match_fixture_postponed     ## note - uses ppd/ppd. or postp/postp. as match separator

                ### note - separarte match fixtures & results
                ##             with "built-in" team using (A), (H), (N) shortcut
                |   match_fixture_base
                |   match_result_base




         match_bye
              :   TEAM INLINE_BYE       ## e.g.  Queen's Park   bye
                    {
                      result = { team: val[0].as_str }
                    }

        ###
        ##  fix/fix/fix  - remove special walkover (w/o) handling!!!
        ##                      add nodate/notime and hrule etc.
         match_walkover
              :   TEAM INLINE_WO TEAM    ## e.g.  Oxford University  w/o  Queen's Park
                   {
                      result = { team1: val[0].as_str,
                                 team2: val[2].as_str }
                   }
