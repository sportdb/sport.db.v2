
        ##########
        ##  ord(inal) match number e.g (1), (42), etc.

        ord  : ORD        {  result = { num: val[0].as_int } }

        opt_ord
            :  /* empty */   {  result = {}  }
            | ord



         ########
         ##  (match) status or note
         ##          e.g. [annulled]  or [bankrupt]

         status : STATUS  {  result = val[0].as_hash  }

         note   : NOTE    { result = { note: val[0].as_str } }

         opt_inline_note
              :  /* empty */  {  result = {} }
              | note


         inline_round_short : INLINE_ROUND_SHORT   { result = { round_inline_short: val[0].as_str } }
         inline_round_big   : INLINE_ROUND_BIG     { result = { round_inline_big: val[0].as_str } }



         ## todo/fix - allow (inline) attendance in match w/o header too
         ##              for now match header required
         ##
         ##  note - use "hack" with INLINE_ATTENDANCE_SEP (a.k.a comma (,))
         ##           to help with shift/reduce conflict
         ## |  ','  INLINE_ATTENDANCE
         inline_attendance
                : INLINE_ATTENDANCE
                    {
                       result = { att: val[0].as_hash[:value] }
                    }
                 |  INLINE_ATTENDANCE_SEP  INLINE_ATTENDANCE
                    {
                       result = { att: val[1].as_hash[:value] }
                    }

         opt_inline_attendance
              :    {  result = {}  }    ## empty; make rule optinal
              |    inline_attendance








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


       ### note - match_header REQUIRES
       ##          (i) geo (tree) or
       ##          (ii) or inline_attendance
       ##

       match_header
            :     date_datetime  geo  opt_inline_attendance  NEWLINE
                   {
                      result = {}.merge( val[0], val[1], val[2] )
                   }
       ##
       ##  quick test for inline_round_big - make more flexible - why? why not?
            |     date_datetime  geo  inline_round_big  NEWLINE
                   {
                      result = {}.merge( val[0], val[1], val[2] )
                   }
       ##
       ##  keep simple match header with date and inline attendance only - why? why not?
            |      date_datetime inline_attendance  NEWLINE
                   {
                      result = {}.merge( val[0], val[1] )
                   }

         match_line_header
               :  opt_ord  match  more_match_header_opts  NEWLINE
                  {
                      result = {}.merge( val[0], val[1], val[2] )
                  }


        ### note - NO geo in (more_)match_line (w/ header)
        ##               always incl. in header

        more_match_header_opts
             : /* empty */      {  result = {} }
             | status
             | note







        match_line
              :   pre_match_opts  match  more_match_opts NEWLINE
                    {
                       kwargs = {}.merge( val[0], val[1], val[2] )
                       @tree << MatchLine.new( **kwargs )
                    }
              |  match  more_match_opts NEWLINE
                    {
                       kwargs = {}.merge( val[0], val[1] )
                       @tree << MatchLine.new( **kwargs )
                    }


              |  match_bye  opt_inline_note  NEWLINE
                      {
                         kwargs = {}.merge( val[0], val[1] )
                         @tree << MatchLineBye.new( **kwargs )
                      }



               ###############
               ### note - for now inline goals only for "compact" match results
               ###           make more flexible (allow leading date/time etc. too)
               ###   plus allow  match status/note - why? why not?

               |   match_result  INLINE_GOALS  goal_lines_body GOALS_END  NEWLINE
                  {
                      @tree << MatchLine.new( **val[0] )

                      @tree << GoalLine.new( goals: val[2] )
                  }






        ##########
        ##  opt_ord  opt_date|datetime|time  opt_inline_round  opt_geo

        ## note - allow ord only
        ##      - allow date/datetime only
        ##      - allow time only
        ##      - allow inline_round_short only
        ##      - allow geo only

        pre_match_opts
            : ord
            | ord pre_match1     { result = {}.merge( val[0], val[1]) }
            | pre_match1

        pre_match1
            : date_datetime
            | date_datetime pre_match2  { result = {}.merge( val[0], val[1]) }
            | time
            | time  pre_match2    { result = {}.merge( val[0], val[1]) }
            | pre_match2

        pre_match2
            : inline_round_short
            | inline_round_short  geo  { result = {}.merge( val[0], val[1]) }
            | geo




        #######
        ## note - you cannot use both STATUS and NOTE - why? why not?
        ##      - for now status must be BEFORE geo!!

      more_match_opts
             :  /* empty */  { result = {} }
             | status
             | status  geo  opt_inline_attendance
                 {
                     result = {}.merge( val[0], val[1], val[2] )
                 }
             | geo  opt_inline_attendance  opt_inline_note
                 {
                   result = {}.merge( val[0], val[1], val[2] )
                 }
             | note
             ## fix-fix-fix  quick test for inline round - make more flexible!!
             | inline_round_big





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
