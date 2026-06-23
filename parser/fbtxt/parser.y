



class RaccMatchParser
rule



       document   : { result = [] }  # note - allows empty documents
                  | elements

       elements  : element
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

          ## todo/fix - change (inline) NOTE to INLINE_NOTE
          ##              and only use NOTE for "standalone" NOTE (lines)
          | note_line
          | nota_bene

          ## check - change goal_lines to MUST follow match_line - why? why not?
          | goal_lines
          | goal_lines_alt     ## allow differnt style/variant e.g. 1-0 Player
                               ##  starting with score
          | goal_lines_compat


          | lineup_lines
          | yellowcard_lines   ## use _line only - why? why not?
          | redcard_lines
          | penalties_lines   ## rename to penalties_line or ___ - why? why not?
          | referee_line
          | attendance_line

          | BLANK        ##  was empty_line
             {
               ## _trace( "REDUCE BLANK" )
               @tree << BlankLine.new
             }

          ## todo/check - move error sync up to elements - why? why not?
          | error
              { puts "!! skipping invalid content (trying to recover from parse error):"
                pp val[0]
                ##  note - do NOT report recover errors for now
                ##  @errors << "parser error (recover) - skipping #{val[0].pretty_inspect}"
              }

          ### use   error NEWLINE - why? why not?
          ##           will (re)sync on NEWLINE?


       heading
           : H1 NEWLINE   {  @tree << Heading1.new( text: val[0].as_str)  }
           | H2 NEWLINE   {  @tree << Heading2.new( text: val[0].as_str)  }
           | H3 NEWLINE   {  @tree << Heading3.new( text: val[0].as_str)  }


        note_line
            : NOTE NEWLINE  { @tree << NoteLine.new( text: val[0].as_str) }

        nota_bene
            : NOTA_BENE NEWLINE    { @tree << NotaBene.new( text: val[0].as_str) }




####
## shared helpers

          opt_blank_lines : { }  ## optional - empty
                          | blank_lines

          blank_lines  : BLANK
                       | blank_lines BLANK



     ##  note - not used for now
     ##    opt_newline : { } ## empty; optional
     ##                | NEWLINE


        ######
        # e.g   Group A  |    Germany   Scotland     Hungary   Switzerland
        ##  or  Group A  :    Germany, Scotland, Hungary, Switzerland

        group_def_sep :  '|' | ':'

        group_def
              :   GROUP_DEF group_def_sep   team_values   NEWLINE
                  {
                      @tree << GroupDef.new( name:  val[0].as_str,
                                             teams: val[2] )
                  }

        team_values
              :   TEAM                       { result = [val[0].as_str]  }
              |   team_values TEAM           { result.push( val[1].as_str )  }
              |   team_values ',' TEAM       { result.push( val[2].as_str )  }




        ####
        ##   round ouline -  note: is an all-in-one line/text
        ##                          NOT tokens separated by comma(,) or dash(-)
        round_outline :    ROUND_OUTLINE NEWLINE
                              {
                                  @tree << RoundOutline.new( **val[0].as_hash )
                              }

        #####
        # e.g.  Matchday 1  |  Fri Jun 14 - Tue Jun 18
        #       Matchday 1  :  Fri Jun 14 - Tue Jun 18
        round_def_sep :  ':' | '|'

        ##
        ##  note - round_def is also a round_outline
        ##    todo/fix - allow a list of dates & durations
        ##           not just single date or duration!!!
        round_def
             :  ROUND_DEF round_def_sep   round_date_opts   NEWLINE
                  {
                      kwargs = { name: val[0].as_str }.merge( val[2] )
                      @tree << RoundDef.new( **kwargs )

                      ## auto-add RoundOutline here - why? why not?
                      ##    or handle "implicit" round_outline
                      ##     in tree walker?
                      @tree << RoundOutline.new( outline: val[0].as_str, level: 1 )
                  }

###
## todo/check - DATE   as_hash already includes { date:  } ??
##                             do NOT duplicate again?

       round_date_opts  :   DATE         { result = { date: val[0].as_hash } }
                         |  DURATION     { result = { duration: val[0].as_hash } }

##############
#  date & time rules / productions


    ##
    ## note - date incl. may be "standalone" year only
    ##               e.g.  1986   etc.
    date
      :   DATE    { result = { date: val[0].as_hash } }
      |   YEAR    { result = { year: val[0].as_int } }

    ##  check if we need to return a copy of the hash that later gets modified
    ##                 or if we can pass along the "original" token hash value
    datetime
      :   DATETIME              { result = val[0].as_hash  }

    time
      :   TIME                  { result = val[0].as_hash  }


     ## note - does NOT incl. time only  (BUT incl. datetime!)
     ##   todo/check - rename to date_or_datetime - why? why not?
       ##   yes - rename to date_datetime / date_or_datetime  !!!
    date_datetime
      :  date
      |  datetime


    ## rename to opt_date_datetime_time or such - why? why not?
    opt_date
      :         {  result = {} }       ## optional -- empty rule
      | date_datetime                  ##  note: is same as date | datetime
      | time




        ## note - only one option (DATE) allowed for "standalone" header now
        ##            use match header (with geo tree)

        date_header
              :    date  NEWLINE
                  {
                     @tree <<  DateHeader.new( **val[0] )
                  }


        date_header_legs
             :     DATE_LEGS  NEWLINE
                  {
                     @tree <<  DateHeaderLegs.new( **val[0].as_hash )
                  }


###
##  geo tree
##
## e.g.  @ Parc des Princes, Paris
##       @ München


        geo   :  '@' geo_names               { result = { geo: val[1] } }

        geo_names
               :  GEO                         {  result = [val[0].as_str] }
               |  geo_names ',' GEO          {  result.push( val[2].as_str )  }



       opt_geo  :   { result = {} }    ## empty -- optional
                |  geo



###
##  note - match_fixture   is always match WITHOUT SCORE
##                         e.g. two TEAMS
##                                with optional inline match status
##                                  - not/played, cancelled, postponed
##
##  for match WITH SCORE see match_result rule

    ## note - does NOT include SCORE; use SCORE terminal "in-place" if needed



         match_sep :  '-' | VS


         match_fixture :  TEAM  match_sep  TEAM
                           {
                               _trace( "RECUDE match_fixture" )
                               result = { team1: val[0].as_str,
                                          team2: val[2].as_str }
                           }



### todo/fix - change to match_fixture_canceled
##                     or keep - why? why not?!!!!

match_fixture_not_played : TEAM INLINE_NP TEAM
                            {
                               ## note - auto-add (match) status canceled - why? why not?
                               ##   A n/p B   short (inline) form of =>
                               ##   A v B [canceled]

                               result = { team1: val[0].as_str,
                                          team2: val[2].as_str,
                                          status_inline: 'canceled' }
                             }
                          | TEAM INLINE_CANC TEAM
                             {
                               result = { team1: val[0].as_str,
                                          team2: val[2].as_str,
                                          status_inline: 'canceled' }
                            }

 match_fixture_postponed  :  TEAM INLINE_PPD TEAM
                             {
                               result = { team1: val[0].as_str,
                                          team2: val[2].as_str,
                                          status_inline: 'postponed' }
                            }



    SCORE_FULL_OR_FULLER
                : SCORE_FULL      ## full format    1-1 (0-1)
                                  ##             or 2-1 a.e.t. etc.
                | SCORE_FULLER    ## note - SCORE_FULLER NOT supported inline!!
                                  ##       only after  Team1 v Team2 !!
                                  ##  for inline use MUST BE (split into two e.g.)
                                  ##      TEAM SCORE TEAM SCORE_FULLER_MORE !!


        match_result :  TEAM  SCORE  TEAM
                         {
                           _trace( "REDUCE => match_result : TEAM SCORE TEAM" )

                          ## note - use/keep generic score (as array!! NOT hash!!!)
                          ##      - as array e.g. [1,1] !!
                           result = { team1: val[0].as_str, team2: val[2].as_str,
                                      score: val[1].as_ary
                                    }
                        }
                     | TEAM SCORE_AWD TEAM
                          {
                           result = { team1: val[0].as_str, team2: val[2].as_str,
                                      score: val[1].as_ary,
                                      status_inline: 'awarded'
                                    }
                          }
                     | TEAM SCORE_ABD TEAM
                          {
                           result = { team1: val[0].as_str, team2: val[2].as_str,
                                      score: val[1].as_ary,
                                      status_inline: 'abandoned'
                                    }
                          }
                     | TEAM SCORE TEAM SCORE_FULLER_MORE
                          {
                            _trace( "REDUCE => match_result : TEAM SCORE TEAM SCORE_FULLER_MORE" )
                            score =  if val[3].as_hash[:score] &&
                                        val[3].as_hash[:score]=='et'   ## check aet flag present?
                                         val[3].as_hash.delete( :score )  ## note - remove/delete  flag
                                           { et: val[1].as_ary }
                                     elsif val[3].as_hash[:score] &&
                                           val[3].as_hash[:score]=='ht' ## check ht flag present?
                                         val[3].as_hash.delete( :score ) ## note - remove/delete flag
                                           { ht: val[1].as_ary }
                                     elsif val[3].as_hash[:score] &&
                                           val[3].as_hash[:score]=='ft'  ## check ft flag present?
                                         val[3].as_hash.delete( :score )  ## note - remove/delete flag
                                           { ft: val[1].as_ary }
                                     else   ## assume full-time (ft)
                                            { ft: val[1].as_ary }
                                     end

                           result = {  team1: val[0].as_str,
                                      team2: val[2].as_str,
                                      score: score.merge( val[3].as_hash )
                                    }
                          }
                     | TEAM SCORE_FULL TEAM
                         {
                           result = { team1: val[0].as_str,
                                      team2: val[2].as_str,
                                      score: val[1].as_hash
                                    }
                         }


                     ############
                     #  match fixture-style WITH SCORE!!!
                     #    e.g.  Austria v Rapid 3-2  or
                     #          Austria - Rapid 3-2

                     |  match_fixture  SCORE   ## note - keep "plain/generic" score separate rule
                        {
                          _trace( "REDUCE  => match_result : match_fixture SCORE" )
                          ## note - use/keep generic score (as array!! NOT hash!!!)
                          ##      - as array e.g. [1,1] !!
                          result = { score: val[1].as_ary }.merge( val[0] )
                        }
                     |  match_fixture  SCORE_FULL_OR_FULLER
                        {
                          _trace( "REDUCE  => match_result : match_fixture SCORE_FULL_OR_FULLER" )
                          result = { score: val[1].as_hash }.merge( val[0] )
                        }

                    ####################
                    ### with inline match status e.g.
                    ##     awarded (awd.),
                    ##     abandoned (abd.)
                    ##     void       -- aka annulled
                    ##     suspendend (susp.)
                    | TEAM INLINE_AWD TEAM
                          {
                           result = { team1: val[0].as_str, team2: val[2].as_str,
                                      status_inline: 'awarded'
                                    }
                          }
                     | TEAM INLINE_ABD TEAM
                          {
                           result = { team1: val[0].as_str, team2: val[2].as_str,
                                      status_inline: 'abandoned'
                                    }
                          }
                     | TEAM INLINE_VOID TEAM
                          {
                           result = { team1: val[0].as_str, team2: val[2].as_str,
                                      status_inline: 'annulled'
                                    }
                          }
                     | TEAM INLINE_SUSP TEAM
                          {
                           result = { team1: val[0].as_str, team2: val[2].as_str,
                                      status_inline: 'suspended'
                                    }
                          }

###
##  note - change/rename  _base  to _home_away or such - why? why not?

         ##########################
         ####  shortcuts (H), (A), (N) with base team
         ##         (H) = Home, (A) = Away, (N) = Neutral
         ##     note: use underscore (_) for base team placeholder for now

         match_fixture_base
                   :  TEAM_HOME    TEAM  { result = { team1: '_', team2: val[1].as_str } }
                   |  TEAM_AWAY    TEAM  { result = { team1: val[1].as_str, team2: '_' } }
                   |  TEAM_NEUTRAL TEAM  { result = { team1: '_', team2: val[1].as_str,
                                                       neutral: true } }


         match_result_base
                    :  match_fixture_base SCORE
                        {
                          _trace( "REDUCE  => match_result_base : match_fixture_base SCORE" )
                          ## note - use/keep generic score (as array!! NOT hash!!!)
                          ##      - as array e.g. [1,1] !!
                          result = { score: val[1].as_ary }.merge( val[0] )
                        }
                    |  match_fixture_base  SCORE_FULL_OR_FULLER
                        {
                          _trace( "REDUCE  => match_result_base : match_fixture_base SCORE_FULL_OR_FULLER" )
                          result = { score: val[1].as_hash }.merge( val[0] )
                        }
     ## support for (a), (h), (n)



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
                               |  inline_round_n_geo


        #  is   INLINE_ROUND        -or-
        #       INLINE_ROUND  GEO   -or-
        #       GEO

        inline_round_n_geo :  INLINE_ROUND  opt_geo  {
                                   _trace( "REDUCE => INLINE_ROUND  opt_geo" )
                                    result = { round_inline: val[0].as_str }.merge( val[1] )
                                }
                             | geo



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
             | inline_round_n_geo


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


## experimental match (w/ two legs)


     ### experimental "compact" leg-style match format
     ##     no date/time in match line REQUIRES date_legs_header for now
     ##             (otherwise) date unknown!!




        match_line_legs
              : match_fixture  SCORE_LEGS  NEWLINE
                {
                      kwargs = { score: val[1].as_hash }.merge( val[0] )
                      @tree << MatchLineLegs.new( **kwargs )
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
        # note:  newlines allowed between goals
        #   for now possible after goals separator ; and -
        #    (Higuaín 2, 9p;
        #     Kane 35 Eriksen 71)
        #    (Higuaín 2, 9p -
        #      Kane 35 Eriksen 71)
        #
        #         and after goal separator ,
        #      (Wirtz 10, Musiala 19, Havertz 45+1p,
        #       Füllkrug 68, Can 90+3;
        #        Rüdiger 87og)
        #
        #     BUT now allowed in-between comma-separated minutes!!!
        #


        ##
        ## note - GOALS token is virtual - basically opening-paranthesis `(` for now

        goal_lines : GOALS goal_lines_body GOALS_END NEWLINE
                      {
                         @tree << GoalLine.new( **val[1] )
                      }


        goal_lines_body : goals                 {  result = { goals1: val[0],
                                                              goals2: [] }
                                                }
                        | GOALS_NONE goals      {  result = { goals1: [],
                                                              goals2: val[1] }
                                                }
                        | goals goals_sep goals {  result = { goals1: val[0],
                                                              goals2: val[2] }
                                                }


        goals_sep    : ';'
                     | ';' NEWLINE
                     | GOAL_SEP_ALT   ## note - dash (-) with leading & trailing spaces required
                     | GOAL_SEP_ALT NEWLINE


         opt_goal_sep   : { }    ## empty -- optional
                        | ','
                        | ',' NEWLINE
                        |  NEWLINE       ## note - allow "standalone" newline!!!

         goals   : goal                      { result = val }
                 | goals opt_goal_sep  goal  { result.push( val[2])  }

         #####
         ## todo -  make comma required for player only
         ##        (that is, no minutes or count) - why? why not?

         goal    : PLAYER goal_minutes
                    {
                       result = Goal.new( player:  val[0].as_str,
                                          minutes: val[1] )
                    }
                 | PLAYER GOAL_COUNT
                     {
                        ### todo/check:
                        ##    auto convert/expand
                        ##    count to minutes - why? why not?
                        ##  todo/fix - pass in empty minutes ary [] - why? why not?
                        result = Goal.new( player: val[0].as_str,
                                           count:  val[1].as_hash )
                     }
                 | PLAYER
                     {
                        result = Goal.new( player: val[0].as_str,
                                           minutes: [] )
                     }


         ## note - hacky: lexer MUST change comma
         ##                  between GOAL_MINUTES to GOAL_MINUTE_SEP!!
         opt_goal_minute_sep : { }    ## none - optiona
                             | GOAL_MINUTE_SEP

         goal_minutes  : goal_minute   {  result = val }
                       | goal_minutes opt_goal_minute_sep goal_minute   {  result.push( val[2])  }

         goal_minute : GOAL_MINUTE
                          {
                             result = GoalMinute.new( **val[0].as_hash )
                          }



##########
##   alternate goal lines starting with score e.g.
##
##    (1-0 Messi     23'(pen.),
##     2-0 Di María  36',
##     2-1 Mbappé    80'(pen.),
##     2-2 Mbappé    81',
##     3-2 Messi    108',
##     3-3 Mbappé   118'(pen.))

        goal_lines_alt : GOALS_ALT goals_alt GOALS_END NEWLINE
                           {
                             @tree << GoalLineAlt.new( goals: val[1] )
                           }

        goals_alt   :  goal_alt
                        { result = val }
                       ## note - allow optional comma sep (or comma sep w/ newline)
                    |  goals_alt  opt_goal_sep  goal_alt
                        { result.push( val[2])  }



        goal_alt    :  SCORE PLAYER     ## note - minute is optional in alt goalline style!!!
                        {
                           result = GoalAlt.new( score:   val[0].as_ary,
                                                 player:  val[1].as_str )
                        }
                    |  SCORE PLAYER GOAL_MINUTE
                        {
                           goal_minute = GoalMinute.new( **val[2].as_hash )

                           result = GoalAlt.new( score:     val[0].as_ary,
                                                 player:    val[1].as_str,
                                                 minute:    goal_minute.to_minute,
                                                 goal_type: goal_minute.to_goal_type )
                        }
                   |  SCORE PLAYER GOAL_TYPE
                       {
                           result = GoalAlt.new( score:     val[0].as_ary,
                                                 player:    val[1].as_str,
                                                 goal_type: GoalType.new( **val[2].as_hash ))
                       }
                  ###  allow score on the right-side (that is, the end NOT the beginning) e.g.
                  ##       Player      1-1
                  ##       Player 14' 1-1
                  ##       Player (og) 1-1
                   |  PLAYER SCORE
                         {
                           result = GoalAlt.new( player:  val[0].as_str,
                                                 score:   val[1].as_ary )
                         }
                   |  PLAYER GOAL_MINUTE SCORE
                        {
                           goal_minute = GoalMinute.new( **val[1].as_hash )

                           result = GoalAlt.new( player:    val[0].as_str,
                                                 minute:    goal_minute.to_minute,
                                                 goal_type: goal_minute.to_goal_type,
                                                 score:     val[2].as_ary )
                        }
                   |  PLAYER GOAL_TYPE SCORE
                       {
                           result = GoalAlt.new( player:    val[0].as_str,
                                                 goal_type: GoalType.new( **val[1].as_hash ),
                                                 score:     val[2].as_ary )
                       }

################
##
##   compat ("legacy") goal line style starting with minute
##

        goal_lines_compat : GOALS_COMPAT goals_compat GOALS_END NEWLINE
                           {
                             @tree << GoalLineCompat.new( goals: val[1] )
                           }

        goals_compat   :  goal_compat
                           { result = val }
                       |  goals_compat  opt_goal_sep  goal_compat
                           { result.push( val[2])  }

/**
  * note - for now SCORE required - why? why not?
        goal_compat    :  MINUTE PLAYER
                        {
                           result = GoalCompat.new( minute:  Minute.new(**val[0].as_hash),
                                                    player:  val[1].as_str )
                        }
                      |  MINUTE PLAYER GOAL_TYPE
                         {
                           result = GoalCompat.new( minute: Minute.new(**val[0].as_hash),
                                                    player: val[1].as_str,
                                                    goal_type: GoalType.new( **val[2].as_hash ))
                        }
 */



        goal_compat    :  MINUTE PLAYER SCORE
                        {
                           result = GoalCompat.new( minute:  Minute.new(**val[0].as_hash),
                                                    player:  val[1].as_str,
                                                    score:  val[2].as_ary )
                        }
                      | MINUTE PLAYER GOAL_TYPE SCORE
                        {
                           result = GoalCompat.new( minute: Minute.new(**val[0].as_hash),
                                                    player: val[1].as_str,
                                                    goal_type: GoalType.new( **val[2].as_hash ),
                                                    score:  val[3].as_ary )
                       }
                       | MINUTE SCORE PLAYER
                        {
                           result = GoalCompat.new( minute:  Minute.new(**val[0].as_hash),
                                                    score:  val[1].as_ary,
                                                    player:  val[2].as_str )
                        }
                      | MINUTE SCORE PLAYER GOAL_TYPE
                        {
                           result = GoalCompat.new( minute: Minute.new(**val[0].as_hash),
                                                    score:  val[1].as_ary,
                                                    player: val[2].as_str,
                                                    goal_type: GoalType.new( **val[3].as_hash ))
                       }



##########
## "level" ii  props

##########################################################################
##     level 2 support for properties - line-up, penalties, etc.


        ##
        ## todo - maybe add (soldout) or such optional qualifier!!
        ##           or 50000+ or such for estimates NUM_APPROX/NUM_ESTIMATE ??

        attendance_line  : PROP_ATTENDANCE  PROP_NUM  PROP_END NEWLINE
                              {
                                 @tree << AttendanceLine.new( att: val[1].as_int )
                              }



        ## note - allow inline attendance prop in same line
        ##             why? why not?
        ##           todo - add usage samples here!!!
        referee_line   :  PROP_REFEREE  referees  attendance_opt PROP_END NEWLINE
                            {
                               @tree << RefereeLine.new( referees: val[1] )
                            }

        referees  :     referee                {  result = val }
                  |     referees ',' referee   {  result.push( val[2] ) }

        referee  :      PROP_NAME
                         {  result = Referee.new( name: val[0].as_str ) }
                 |      PROP_NAME  ENCLOSED_NAME
                         {  result = Referee.new( name: val[0].as_str, country: val[1].as_str ) }


     attendance_opt   : /* empty */
                        | ';' ATTENDANCE  PROP_NUM
                           {
                                 @tree << AttendanceLine.new( att: val[2].as_int )
                           }



##
##  fix-fix-fix  - [ ] add sentoff_lines & yellowredcard_lines !!!


        yellowcard_lines : PROP_YELLOWCARDS card_body PROP_END NEWLINE
                             {
                               @tree << CardsLine.new( type: 'Y', bookings: val[1] )
                             }
        redcard_lines    : PROP_REDCARDS card_body PROP_END NEWLINE
                             {
                               @tree << CardsLine.new( type: 'R', bookings: val[1] )
                             }

         ## use player_booking or such
         card_body :  player_w_minute
                        {
                           ## note - value must be DOUBLE [[]] nested in array
                           ##    allows separator for teams
                           ##   via semicolon (;) separator, see below!
                           result = [[val[0]]]
                        }
                   |  card_body card_sep player_w_minute
                        {
                          ## note - if lineup_sep is dash (-) start a new sub array!!
                          if val[1] == ';'
                            result << [val[2]]
                          else
                            result[-1] << val[2]
                          end
                        }

         card_sep  :  ','             { result = ',' }
                   |  ';'             { result = ';' }
                   |  ';' NEWLINE     { result = ';' }

         player_w_minute : PROP_NAME
                              { result = Booking.new( name: val[0].as_str )  }
                         | PROP_NAME MINUTE
                              { result = Booking.new( name:   val[0].as_str,
                                                      minute: Minute.new(**val[1].as_hash) )  }



        penalties_lines : PROP_PENALTIES penalties_body PROP_END NEWLINE
                            {
                               @tree << PenaltiesLine.new( penalties: val[1] )
                            }



        penalty_sep     :  ','
                        |  ',' NEWLINE
                        |  ';'
                        |  ';' NEWLINE

        penalties_body  :  penalty                             {  result = val  }
                        |  penalties_body penalty_sep penalty  {  result.push( val[2] )  }



        penalty         :  SCORE PROP_NAME
                              {
                                 result = Penalty.new( score: val[0].as_ary,
                                                       name:  val[1].as_str )
                              }
                        |  SCORE PROP_NAME ENCLOSED_NAME
                               {
                                 result = Penalty.new( score: val[0].as_ary,
                                                       name:  val[1].as_str,
                                                       note:  val[2].as_str )
                               }
                        | PROP_NAME
                               {
                                 result = Penalty.new( name: val[0].as_str )
                               }
                        |  PROP_NAME ENCLOSED_NAME        ## e.g. (save), (post), etc
                               {
                                 result = Penalty.new( name: val[0].as_str,
                                                       note: val[1].as_str )
                               }



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



end