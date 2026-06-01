module SportDb
class Lexer



class Context
   ## passed along to on_round_def etc. handlers in tokenize_line
     attr_reader   :line, :errors
     attr_accessor :offsets

     def initialize( line:, errors: )
        @line    = line
        @errors  = errors
        ## @offsets = offsets    ## MatchData offsets e.g. [m.begin(0),m.end(0)]
     end
end



def _tokenize_line( line )
  tokens = []
  errors = []   ## keep a list of errors - why? why not?


  pos = 0
  ## track last offsets - to report error on no match
  ##   or no match in end of string
  offsets = [0,0]
  m = nil

  ## track number of geo text seen
  ##    (use for - do NOT break on two spaces if no geo text seen yet!!)
  geo_count = 0

  ####
  ## quick hack - keep re state/mode between tokenize calls!!!
  @re  ||= RE     ## note - switch between RE & INSIDE_RE


  if @re == RE  ## top-level
    ### check for modes once (per line) here to speed-up parsing
    ###   for now goals only possible for start of line!!
    ###        fix - remove optional [] - why? why not?

    ####
    ## note - ord e.g. (45) for match number can only start a (match) line
    ##                "inline" use NOT possible
    ## note -  ord (for ordinal number!!!) e.g match number (1), (42), etc.
    if (m = START_WITH_ORD.match(line))
       ## note -  strip enclosing () and convert to integer
       tokens << [:ORD, [m[:ord], { value: m[:value].to_i(10) } ]]

       offsets = [m.begin(0), m.end(0)]
       pos = offsets[1]    ## update pos
    elsif (m = START_WITH_YEAR.match(line))
       ## note -  strip enclosing () and convert to integer
       tokens << [:YEAR, m[:year].to_i(10)]

       offsets = [m.begin(0), m.end(0)]
       pos = offsets[1]    ## update pos

    ###
    ##  todo/fix - rename to START_GROUP_DEF_LINE_RE !!!!
    elsif (m = GROUP_DEF_LINE_RE.match( line ))
      puts "  ENTER GROUP_DEF_RE MODE"   if debug?
      @re = GROUP_DEF_RE

      tokens << [:GROUP_DEF, m[:group_def]]

      offsets = [m.begin(0), m.end(0)]
      pos = offsets[1]    ## update pos

    ###  todo/fix - rename to PROP_KEY_RE to START_WITH_PROP_KEY_RE !!!
    elsif (m = PROP_KEY_RE.match( line ))
      ##  start with prop key (match will switch into prop mode!!!)
      ##   - fix - remove leading spaces in regex (upstream) - why? why not?
      ##
      ###  switch into new mode
      ##  switch context  to PROP_RE
        puts "  ENTER PROP_RE MODE"   if debug?
        key = m[:key]


        ### todo/fix - add prop yellow/red cards too - why? why not?
        ##  todo/fix - separate sent off and red card
        ##     sent-off - incl. red card, yellow/red card and the era before red cards!!
        if ['sent off'].include?( key.downcase)
          @re = PROP_CARDS_RE    ## use CARDS_RE ???
          tokens << [:PROP_SENTOFF, m[:key]]
        elsif ['red cards'].include?( key.downcase )
          @re = PROP_CARDS_RE    ## use CARDS_RE ???
          tokens << [:PROP_REDCARDS, m[:key]]
        elsif ['yellow cards'].include?( key.downcase )
          @re = PROP_CARDS_RE
          tokens << [:PROP_YELLOWCARDS, m[:key]]
        elsif ['ref', 'referee',
               'refs', 'referees'   ## note - allow/support assistant refs
              ].include?( key.downcase )
          @re = PROP_REFEREE_RE
          tokens << [:PROP_REFEREE, m[:key]]
        elsif ['att', 'attn', 'attendance'].include?( key.downcase )
          @re = PROP_ATTENDANCE_RE
          tokens << [:PROP_ATTENDANCE, m[:key]]

     #   elsif ['goals'].include?( key.downcase )
     #     @re = PROP_GOAL_RE
     #     tokens << [:PROP_GOALS, m[:key]]

        elsif ['penalties',
               'penalty shootout',
               'penalty shoot-out',
               'penalty kicks'].include?( key.downcase )
          @re = PROP_PENALTIES_RE
          tokens << [:PROP_PENALTIES, m[:key]]
        else   ## assume (team) line-up
          @re = PROP_RE           ## use LINEUP_RE ???
          tokens << [:PROP, m[:key]]
        end

        offsets = [m.begin(0), m.end(0)]
        pos = offsets[1]    ## update pos
    ###
    ### todo/fix
    ###   rename to START_WITH_ROUND_DEF_OUTLINE_RE !!!!
    elsif (m = ROUND_DEF_OUTLINE_RE.match( line ))
      puts "   ENTER ROUND_DEF_RE MODE"  if debug?
      @re = ROUND_DEF_RE

      ## note - return ROUND_DEF NOT  ROUND_OUTLINE token
      tokens << [:ROUND_DEF, m[:round_outline]]

      offsets = [m.begin(0), m.end(0)]
      pos = offsets[1]    ## update pos
    elsif (m = ROUND_OUTLINE_RE.match( line ))
      puts "   ROUND_OUTLINE"  if debug?
      ## note - derive round level from no of (leading) markers
      ##             e.g. ▪/:: is 1, ▪▪/::: is 2, ▪▪▪/:::: is 3, etc.
      ##       note  - ascii-style starts with double ::, thus, autodecrement by one!
      round_level = m[:round_marker].size
      round_level -= 1  if m[:round_marker].start_with?( '::' )

      tokens << [:ROUND_OUTLINE, [m[:round_outline],
                      { outline: m[:round_outline] ,
                        level: round_level}]]

      ## note - eats-up line for now (change later to only eat-up marker e.g. »|>>)
      offsets = [m.begin(0), m.end(0)]
      pos = offsets[1]    ## update pos
    elsif (m = START_GOAL_LINE_RE.match( line ))   ## line starting with ( - assume
      ##  switch context to GOAL_RE (goalline(s))
      ####
      ##  note - check for alternate goal line styles / formats
      if START_GOAL_LINE_COMPAT_RE.match(line )
        ## "legacy" style starting with minute e.g.
        ##  (6 Puskás 0-1, 9 Czibor 0-2, 11 Morlock 1-2, 18 Rahn 2-2,
        ##    84 Rahn 3-2)
        @re = GOAL_COMPAT_RE
        puts "  ENTER GOAL_COMPAT_RE MODE"   if debug?

        tokens << [:GOALS_COMPAT, "<|GOALS_COMPAT|>"]
      elsif START_GOAL_LINE_ALT_RE.match( line )
        ##  goals with scores e.g.
        ##    (1-0 Franck Ribéry, 2-0 Ivica Olić, 2-1 Wayne Rooney)
        ##         -or-
        ##      (Dion Beljo  1-0
        ##                   1-1  Andreas Gruber
        ##   Matthias Seidl  2-1)
        @re = GOAL_ALT_RE
        puts "  ENTER GOAL_ALT_RE MODE"   if debug?

        tokens << [:GOALS_ALT, "<|GOALS_ALT|>"]
      else
        ## "standard" / default style
        @re = GOAL_RE
        puts "  ENTER GOAL_RE MODE"   if debug?

        tokens << [:GOALS, "<|GOALS|>"]
      end

      ## note - eat-up ( for now
      ##   pass along "virtual" GOALS or GOALS_ALT token
      ##      (see INLINE_GOALS for the starting goal line inline)
      offsets = [m.begin(0), m.end(0)]
      pos = offsets[1]    ## update pos
    end
  end



  old_pos = -1   ## allows to backtrack to old pos (used in geo)




  ctx = Context.new( line:   line,
                     errors: errors )


  while m = @re.match( line, pos )
    # if debug?
    #  pp m
    #  puts "pos: #{pos}"
    # end
    offsets = [m.begin(0), m.end(0)]
    ctx.offsets = offsets



    if offsets[0] != pos
      ## match NOT starting at start/begin position!!!
      ##  report parse error!!!
      msg =  "!! WARN - parse error (tokenize) - skipping >#{line[pos..(offsets[0]-1)]}< @#{offsets[0]},#{offsets[1]} in line >#{line}<"
      puts msg

      errors << "parse error (tokenize) - skipping >#{line[pos..(offsets[0]-1)]}< @#{offsets[0]},#{offsets[1]} in line >#{line}<"
      log( msg )
    end


    ##
    ## todo/fix - also check if possible
    ##   if no match but not yet end off string!!!!
    ##    report skipped text run too!!!

    old_pos = pos
    pos     = offsets[1]

#    pp offsets   if debug?

    ##
    ## note: racc requires pairs e.g. [:TOKEN, VAL]
    ##         for VAL use "text" or ["text", { opts }]  array




  t = if @re == ROUND_DEF_RE
            _on_round_def( m, ctx: ctx )
      elsif @re == GROUP_DEF_RE
           _on_group_def( m, ctx: ctx )
       elsif @re == GEO_RE
           ### note - possibly end inline geo on [ (and others?? in the future
           ## note: break on double spaces e.g.
           ## e.g. Jul/16 @ Arena Auf Schalke, Gelsenkirchen  Serbia 0-1 England
           if m[:spaces]
                 ### note - do NOT break out
                 ##           if not text seen yet!!!
                 if geo_count > 0
                    ## get out-off geo mode and backtrack (w/ next)
                    puts "  LEAVE GEO_RE MODE, BACK TO TOP_LEVEL/RE"  if debug?
                    @re = RE
                    pos = old_pos
                    next   ## backtrack (resume new loop step)
                 else
                     nil   ## skip spaces
                 end
           elsif m[:space]
               nil    ## skip (single) space
           elsif m[:text]
               geo_count += 1
               [:GEO, m[:text]]   ## keep pos - why? why not?
           elsif m[:geo_end]   ## "hacky" special comma; always ends geo mode!!!
                 ## get out-off geo mode and backtrack (w/ next)
                 puts "  LEAVE GEO_RE MODE, BACK TO TOP_LEVEL/RE"  if debug?
                 @re = RE
                 pos = old_pos
                 next   ## backtrack (resume new loop step)
           elsif m[:sym]
              sym = m[:sym]
              ## return symbols "inline" as is - why? why not?
              ## (?<sym>[;,@|\[\]-])
              case sym
                ## note - reset geo_count to 0 (avoids break on two spaces)
                ##                     if separator seen!!
              when ',' then geo_count = 0; [:',']
              when '›' then geo_count = 0; [:',']  ## note - treat geo sep › (unicode) like comma for now!!!
              when '>' then geo_count = 0; [:',']  ## note - treat geo sep > (ascii) like comma for now!!!
              when '[' then
                 ## get out-off geo mode and backtrack (w/ next)
                 puts "  LEAVE GEO_RE MODE, BACK TO TOP_LEVEL/RE"  if debug?
                 @re = RE
                 pos = old_pos
                 next   ## backtrack (resume new loop step)
            else
              puts "!!! TOKENIZE ERROR (sym) - ignore sym >#{sym}<"
              nil  ## ignore others (e.g. brackets [])
            end
          elsif m[:any]
             ## todo/check log error
             msg = "parse error (tokenize geo) - skipping any match>#{m[:any]}< @#{offsets[0]},#{offsets[1]} in line >#{line}<"
             puts "!! WARN - #{msg}"

             errors << msg
             log( "!! WARN - #{msg}" )

             nil
          else
            ## report error/raise expection
             puts "!!! TOKENIZE ERROR - no match found"
             nil
          end
      elsif @re == PROP_CARDS_RE
          _on_prop_cards( m, ctx: ctx )
      elsif @re == PROP_RE   ### todo/fix - change to LINEUP_RE !!!!
         if m[:space] || m[:spaces]
              nil    ## skip space(s)
         elsif m[:prop_key]   ## check for inline prop keys
              key = m[:key]
              ##  supported for now coach/trainer (add manager?)
              if ['coach',
                  'trainer'].include?( key.downcase )
                [:COACH, m[:key]]   ## use COACH_KEY or such - why? why not?
              else
                ## report error - for unknown (inline) prop key in lineup
                nil
              end
         elsif m[:inline_captain]
              [:INLINE_CAPTAIN, m[:inline_captain]]
         elsif m[:inline_yellow]
              card = {}
              card[:m]      = m[:minute].to_i(10)  if m[:minute]
              card[:offset] = m[:offset].to_i(10)  if m[:offset]
              [:INLINE_YELLOW, [m[:inline_yellow], card]]
         elsif m[:inline_red]
              card = {}
              card[:m]      = m[:minute].to_i(10)  if m[:minute]
              card[:offset] = m[:offset].to_i(10)  if m[:offset]
              [:INLINE_RED, [m[:inline_red], card]]
         elsif m[:inline_yellow_red]
              card = {}
              card[:m]      = m[:minute].to_i(10)  if m[:minute]
              card[:offset] = m[:offset].to_i(10)  if m[:offset]
              [:INLINE_YELLOW_RED, [m[:inline_yellow_red], card]]
         elsif m[:prop_name]
              [:PROP_NAME, m[:name]]
         elsif m[:minute]
              minute = {}
              minute[:m]      = m[:value].to_i(10)
              minute[:offset] = m[:value2].to_i(10)   if m[:value2]
             [:MINUTE, [m[:minute], minute]]
         elsif m[:sym]
            sym = m[:sym]
            ## return symbols "inline" as is - why? why not?
            ## (?<sym>[;,@|\[\]-])

            case sym
            when ',' then [:',']
            when ';' then [:';']
            when '[' then [:'[']
            when ']' then [:']']
            when '(' then [:'(']
            when ')' then [:')']
            when '-' then [:'-']
            else
              nil  ## ignore others (e.g. brackets [])
            end
         else
            ## report error
             puts "!!! TOKENIZE ERROR (PROP_RE) - no match found"
             nil
         end
      elsif @re == PROP_ATTENDANCE_RE
         if m[:space] || m[:spaces]
              nil    ## skip space(s)
         elsif m[:enclosed_name]
              ## reserverd for use for sold out or such (in the future) - why? why not?
             [:ENCLOSED_NAME, m[:name]]
         elsif m[:num]
             [:PROP_NUM, [m[:num], { value: m[:value].to_i(10) } ]]
=begin
         elsif m[:sym]
            sym = m[:sym]
            case sym
            when ',' then [:',']
            when ';' then [:';']
            # when '[' then [:'[']
            # when ']' then [:']']
            else
              nil  ## ignore others (e.g. brackets [])
            end
=end
         else
            ## report error
            puts "!!! TOKENIZE ERROR (PROP_ATTENDANCE_RE) - no match found"
            nil
         end
      elsif @re == PROP_REFEREE_RE
         if m[:space] || m[:spaces]
              nil    ## skip space(s)
         elsif m[:prop_key]   ## check for inline prop keys
              key = m[:key]
              ##  supported for now coach/trainer (add manager?)
              if ['att', 'attn', 'attendance' ].include?( key.downcase )
                [:ATTENDANCE, m[:key]]   ## use COACH_KEY or such - why? why not?
              else
                ## report error - for unknown (inline) prop key in lineup
                nil
              end
         elsif m[:prop_name]    ## note - change prop_name to player
             [:PROP_NAME, m[:name]]    ### use PLAYER for token - why? why not?
         elsif m[:num]
             [:PROP_NUM, [m[:num], { value: m[:value].to_i(10) } ]]
         elsif m[:enclosed_name]
              ## use HOLD,SAVE,POST or such keys - why? why not?
             [:ENCLOSED_NAME, m[:name]]
         elsif m[:sym]
            sym = m[:sym]
            case sym
            when ',' then [:',']
            when ';' then [:';']
 #           when '[' then [:'[']
 #           when ']' then [:']']
            else
              nil  ## ignore others (e.g. brackets [])
            end
         else
            ## report error
            puts "!!! TOKENIZE ERROR (PROP_REFEREE_RE) - no match found"
            nil
         end
      elsif @re == PROP_PENALTIES_RE
        if m[:space] || m[:spaces]
              nil    ## skip space(s)
         elsif m[:prop_name]    ## note - change prop_name to player
             [:PROP_NAME, m[:name]]    ### use PLAYER for token - why? why not?
         elsif m[:enclosed_name]
              ## use HOLD,SAVE,POST or such keys - why? why not?
             [:ENCLOSED_NAME, m[:name]]
         elsif m[:score]
              score = {}
              ## must always have ft for now e.g. 1-1 or such
              ###  change to (generic) score from ft -
              ##     might be score a.e.t. or such - why? why not?
              score[:score] = [m[:score1].to_i(10),
                               m[:score2].to_i(10)]
              [:SCORE, [m[:score], score]]
         elsif m[:sym]
            sym = m[:sym]
            case sym
            when ',' then [:',']
            when ';' then [:';']
            when '[' then [:'[']
            when ']' then [:']']
            else
              nil  ## ignore others (e.g. brackets [])
            end
         else
            ## report error
            puts "!!! TOKENIZE ERROR (PROP_PENALTIES_RE) - no match found"
            nil
         end
      elsif @re == GOAL_COMPAT_RE
         if m[:space] || m[:spaces]
              nil    ## skip space(s)
         elsif m[:prop_name]    ## note - change prop_name to player
             [:PLAYER, m[:name]]
         elsif m[:minute]
              minute = _build_minute( m )
             [:MINUTE, [m[:minute], minute]]
         elsif m[:goal_type]
              goal_type = _build_goal_type( m )
             [:GOAL_TYPE, [m[:goal_type], goal_type]]
         elsif m[:score]
            score = {}
             ##  note - score is "generic"
            ##      might be full-time (ft) or
            ##         after extra-time (aet) or such
            ##         or even undecided/unknown
            ##    thus, use score1/score2 and NOT ft1/ft2
            score[:score] = [m[:score1].to_i(10),
                             m[:score2].to_i(10)]
            ## note - for debugging keep (pass along) "literal" score
            [:SCORE, [m[:score], score]]
         elsif m[:sym]
            sym = m[:sym]
            ## return symbols "inline" as is - why? why not?
            ## (?<sym>[;,@|\[\]-])

            case sym
            when ',' then [:',']
            when ')'  ## leave goal mode!!
                puts "  LEAVE GOAL_COMPAT_RE MODE"   if debug?
                @re = RE
                ##  note - use/return GOAL_END token   - change to GOAL_END_PAREN(THESIS)
                ##                                or GOAL_PAREN_CLOSE/END ???
                [:GOALS_END, '<|GOALS_END|>']
            else
              nil  ## ignore others (e.g. brackets [])
            end
         else
            ## report error
            puts "!!! TOKENIZE ERROR (GOAL_COMPAT_RE) - no match found"
            nil
         end
      elsif @re == GOAL_ALT_RE
         if m[:space] || m[:spaces]
              nil    ## skip space(s)
         elsif m[:prop_name]    ## note - change prop_name to player
             [:PLAYER, m[:name]]
         elsif m[:goal_minute]
              minute = _build_goal_minute( m )
             [:GOAL_MINUTE, [m[:goal_minute], minute]]
         elsif m[:goal_type]
              goal_type = _build_goal_type( m )
             [:GOAL_TYPE, [m[:goal_type], goal_type]]
         elsif m[:score]
            score = {}
             ##  note - score is "generic"
            ##      might be full-time (ft) or
            ##         after extra-time (aet) or such
            ##         or even undecided/unknown
            ##    thus, use score1/score2 and NOT ft1/ft2
            score[:score] = [m[:score1].to_i(10),
                             m[:score2].to_i(10)]
            ## note - for debugging keep (pass along) "literal" score
            [:SCORE, [m[:score], score]]
         elsif m[:sym]
            sym = m[:sym]
            ## return symbols "inline" as is - why? why not?
            ## (?<sym>[;,@|\[\]-])

            case sym
            when ',' then [:',']
            when ')'  ## leave goal mode!!
                puts "  LEAVE GOAL_ALT_RE MODE"   if debug?
                @re = RE
                ##  note - use/return GOAL_END token   - change to GOAL_END_PAREN(THESIS)
                ##                                or GOAL_PAREN_CLOSE/END ???
                [:GOALS_END, '<|GOALS_END|>']
            else
              nil  ## ignore others (e.g. brackets [])
            end
         else
            ## report error
            puts "!!! TOKENIZE ERROR (GOAL_ALT_RE) - no match found"
            nil
         end
      elsif @re == GOAL_RE
         if m[:space] || m[:spaces]
              nil    ## skip space(s)
         elsif m[:goals_none]    ## note - eats-up semicolon!! e.g. -; or - ;
             [:GOALS_NONE, "<|GOALS_NONE|>"]
         elsif m[:goal_sep_alt]
             [:GOAL_SEP_ALT, "<|GOAL_SEP_ALT|>" ]   ## e.g. dash (-) WITH leading & trailing space required
         elsif m[:prop_name]    ## note - change prop_name to player
             [:PLAYER, m[:name]]
         elsif m[:goal_minute]
              minute = _build_goal_minute( m )
             [:GOAL_MINUTE, [m[:goal_minute], minute]]
         elsif m[:goal_minute_na]
              minute = _build_goal_minute_na( m )
              ## note -  (re)use GOAL_MINUTE token; no extra GOAL_MINUTE_NA or such - why? why not?
              ##          make sure to handle 'm' => nil upstream!!!
              ##                     change to  999 or -1 or such - why? why not?
             [:GOAL_MINUTE, [m[:goal_minute_na], minute]]
         elsif m[:goal_count]
              count = _build_goal_count( m )
              [:GOAL_COUNT, [m[:goal_count], count]]
         elsif m[:sym]
            sym = m[:sym]
            ## return symbols "inline" as is - why? why not?
            ## (?<sym>[;,@|\[\]-])

            case sym
            when ',' then [:',']
            when ';' then [:';']
            # when '[' then [:'[']
            # when ']' then [:']']
            when ')'  ## leave goal mode!!
                puts "  LEAVE GOAL_RE MODE"   if debug?
                @re = RE
                ##  note - use/return GOAL_END token   - change to GOAL_END_PAREN(THESIS)
                ##                                or GOAL_PAREN_CLOSE/END ???
                [:GOALS_END, '<|GOALS_END|>']
            else
              nil  ## ignore others (e.g. brackets [])
            end
         else
            ## report error
            puts "!!! TOKENIZE ERROR (GOAL_RE) - no match found"
            nil
         end
      ###################################################
      ## assume TOP_LEVEL (a.k.a. RE) machinery
      else
        if m[:space] || m[:spaces]
           nil   ## skip space(s)
        elsif m[:text]
          ##  note - top-level (for now always) assumes TEAM for TEXT match!!
          [:TEAM, m[:text]]   ## keep pos - why? why not?
        elsif m[:status]   ## (match) status e.g. cancelled, awarded, etc.
            [:STATUS, [m[:status], _build_status( m ) ]]
        elsif m[:inline_wo]   ## w/o - walkover  (match status)
            [:INLINE_WO, m[:inline_wo]]
        elsif m[:inline_np]   ## n/p - not played (match status)
            [:INLINE_NP, m[:inline_np]]
        elsif m[:inline_bye]  ## bye  (match status)
            [:INLINE_BYE, m[:inline_bye]]
        elsif m[:inline_abd]  ## abd/abd. - abandoned (match status)
            [:INLINE_ABD, m[:inline_abd]]
        elsif m[:inline_void]  ## abd/abd. - abandoned (match status)
            [:INLINE_VOID, m[:inline_void]]
        elsif m[:inline_susp]  ## susp/susp. - suspended (match status)
            [:INLINE_SUSP, m[:inline_susp]]
        elsif m[:inline_ppd]  ## ppd/ppd. or postp/postp. - postponed (match status)
            [:INLINE_PPD, m[:inline_ppd]]
        elsif m[:inline_awd]  ## awd/awd. - awarded (match status)
            [:INLINE_AWD, m[:inline_awd]]
        elsif m[:inline_canc]  ## canc/canc. - cancelled/canceled (match status)
            [:INLINE_CANC, m[:inline_canc]]

        elsif m[:team_home]
            [:TEAM_HOME, m[:team_home]]
        elsif m[:team_away]
            [:TEAM_AWAY, m[:team_away]]
        elsif m[:team_neutral]
            [:TEAM_NEUTRAL, m[:team_neutral]]

        elsif m[:attendance]
             att = {}
             att[:value] = m[:value].gsub( '_', '' ).to_i(10)
             ## note - for token id use INLINE_ATTENDANCE  (ATTENDANCE in use for prop!!!)
            [:INLINE_ATTENDANCE, [m[:attendance], att ]]
        elsif m[:note]
            ###  todo/check:
            ##      use value hash - why? why not? or simplify to:
            ## [:NOTE, [m[:note], {note: m[:note] } ]]
             [:NOTE, m[:note]]
        elsif m[:time]
            [:TIME, [m[:time], _build_time(m)]]
        elsif m[:date]
            [:DATE, [m[:date], _build_date(m)]]
        elsif m[:date_legs]
            [:DATE_LEGS, [m[:date_legs], _build_date_legs(m)]]
        elsif m[:score_team]
            [:SCORE_TEAM, [m[:score_team], _build_score_team(m)]]
        elsif m[:score_team_pen]
            [:SCORE_TEAM_PEN, [m[:score_team_pen], _build_score_team_pen(m)]]
        elsif m[:score_team_num]
            [:SCORE_TEAM_NUM, [m[:score_team_num], _build_score_team_num(m)]]
          elsif m[:score_legs]
              legs = {}

              ### leg1
              score = {}
              score[:ft] = [m[:leg1_ft1].to_i(10),
                            m[:leg1_ft2].to_i(10)]
              legs['leg1'] = score

              ### leg2
              score = {}
              score[:ft] = [m[:leg2_ft1].to_i(10),
                            m[:leg2_ft2].to_i(10)]  if m[:leg2_ft1] && m[:leg2_ft2]
              score[:et] = [m[:leg2_et1].to_i(10),
                            m[:leg2_et2].to_i(10)]  if m[:leg2_et1] && m[:leg2_et2]
              score[:p]  = [m[:leg2_p1].to_i(10),
                            m[:leg2_p2].to_i(10)]  if m[:leg2_p1] && m[:leg2_p2]
              legs['leg2'] = score

              ## check for (opt) aggregate - keep on "top-level"
              legs[:agg] = [m[:agg1].to_i(10),
                            m[:agg2].to_i(10)]  if m[:agg1] && m[:agg2]
              legs[:away] = true  if m[:away]

              ## note - for debugging keep (pass along) "literal" score
              [:SCORE_LEGS, [m[:score_legs], legs]]
        elsif m[:score_full]
              score = {}
              score[:p] = [m[:p1].to_i(10),
                           m[:p2].to_i(10)]  if m[:p1] && m[:p2]
              score[:et] = [m[:et1].to_i(10),
                            m[:et2].to_i(10)]  if m[:et1] && m[:et2]
              score[:ft] = [m[:ft1].to_i(10),
                            m[:ft2].to_i(10)]  if m[:ft1] && m[:ft2]
              score[:ht] = [m[:ht1].to_i(10),
                            m[:ht2].to_i(10)]  if m[:ht1] && m[:ht2]
              score[:agg] = [m[:agg1].to_i(10),
                             m[:agg2].to_i(10)]  if m[:agg1] && m[:agg2]

              if m[:away1] && m[:away2]
                 score[:away] = [m[:away1].to_i(10),
                                 m[:away2].to_i(10)]
              elsif m[:away]    ## fallback if no away score; check away flag
                 score[:away] = true
              end

              ## add golden/silver flags
              score[:golden] = true   if m[:aetgg]  ## golden goal (gg)/sudden death (sd)
              score[:silver] = true   if m[:aetsg]  ## silver goal (sg)

            ## note - for debugging keep (pass along) "literal" score
            [:SCORE_FULL, [m[:score_full], score]]
        elsif m[:score_fuller]
              score = {}
              score[:p] = [m[:p1].to_i(10),
                           m[:p2].to_i(10)]  if m[:p1] && m[:p2]
              score[:et] = [m[:et1].to_i(10),
                            m[:et2].to_i(10)]  if m[:et1] && m[:et2]
              score[:ft] = [m[:ft1].to_i(10),
                            m[:ft2].to_i(10)]  if m[:ft1] && m[:ft2]
              score[:ht] = [m[:ht1].to_i(10),
                            m[:ht2].to_i(10)]  if m[:ht1] && m[:ht2]
              score[:agg] = [m[:agg1].to_i(10),
                             m[:agg2].to_i(10)]  if m[:agg1] && m[:agg2]
              if m[:away1] && m[:away2]
                 score[:away] = [m[:away1].to_i(10),
                                 m[:away2].to_i(10)]
              elsif m[:away]    ## fallback if no away score; check away flag
                 score[:away] = true
              end

              ## add aet flag true/false
              # score[:aet] = true   if m[:aet] || m[:aetgg] || m[:aetsg]

              ## add golden/silver flags
              score[:golden] = true   if m[:aetgg]  ## golden goal (gg)/sudden death (sd)
              score[:silver] = true   if m[:aetsg]  ## silver goal (sg)

            ## note - for debugging keep (pass along) "literal" score
            [:SCORE_FULLER, [m[:score_fuller], score]]
        elsif m[:score_fuller_more]
               ##    SCORE + SCORE_FULLER_MORE
               ## note -  after extra-time (aet) or full-time (ft)
               ##           score may be present in SCORE!!!
              score = {}
              score[:p] = [m[:p1].to_i(10),
                           m[:p2].to_i(10)]  if m[:p1] && m[:p2]
              score[:et] = [m[:et1].to_i(10),
                            m[:et2].to_i(10)]  if m[:et1] && m[:et2]
              score[:ft] = [m[:ft1].to_i(10),
                            m[:ft2].to_i(10)]  if m[:ft1] && m[:ft2]
              score[:ht] = [m[:ht1].to_i(10),
                            m[:ht2].to_i(10)]  if m[:ht1] && m[:ht2]
              score[:agg] = [m[:agg1].to_i(10),
                             m[:agg2].to_i(10)]  if m[:agg1] && m[:agg2]
              if m[:away1] && m[:away2]
                 score[:away] = [m[:away1].to_i(10),
                                 m[:away2].to_i(10)]
              elsif m[:away]    ## fallback if no away score; check away flag
                 score[:away] = true
              end

              ## add flag in score for et/ft/ht
              score[:score] = 'et'   if m[:aet] || m[:aetgg] || m[:aetsg]
              score[:score] = 'ft'   if m[:ft]
              score[:score] = 'ht'   if m[:ht]

              ## add golden/silver flags
              score[:golden] = true   if m[:aetgg]  ## golden goal (gg)/sudden death (sd)
              score[:silver] = true   if m[:aetsg]  ## silver goal (sg)

            ## note - for debugging keep (pass along) "literal" score
            [:SCORE_FULLER_MORE, [m[:score_fuller_more], score]]
        elsif m[:score]
            score = {}
             ##  note - score is "generic"
            ##      might be full-time (ft) or
            ##         after extra-time (aet) or such
            ##         or even undecided/unknown
            ##    thus, use score1/score2 and NOT ft1/ft2
            score[:score] = [m[:score1].to_i(10),
                             m[:score2].to_i(10)]
         ## note - for debugging keep (pass along) "literal" score
          [:SCORE, [m[:score], score]]
        elsif m[:score_awd]   ## score awarded (awd/awd.)
            score = {}
            ### note - use "generic" score for now
            ##         to match  A 3-0 B [awarded] etc.
            score[:score] = [m[:score1].to_i(10),
                             m[:score2].to_i(10)]
            ## add score[:awarded] = true ???
            ##    or only use match status to avoid duplicate?
            [:SCORE_AWD, [m[:score_awd], score]]
        elsif m[:score_abd]   ## score abandonded (abd/abd.)
            score = {}
            ### note - use "generic" score for now
            score[:score] = [m[:score1].to_i(10),
                             m[:score2].to_i(10)]
            ## add score[:awarded] = true ???
            ##    or only use match status to avoid duplicate?
            [:SCORE_ABD, [m[:score_abd], score]]
      elsif m[:minute]
              minute = {}
              minute[:m]      = m[:value].to_i(10)
              minute[:offset] = m[:value2].to_i(10)   if m[:value2]
             ## note - for debugging keep (pass along) "literal" minute
             [:MINUTE, [m[:minute], minute]]
        elsif m[:vs]
           [:VS, m[:vs]]
        elsif m[:sym]
          sym = m[:sym]
          ## return symbols "inline" as is - why? why not?
          ## (?<sym>[;,@|\[\]-])

          case sym
          when '@'    ##  enter geo mode
            puts "  ENTER GEO_RE MODE"  if debug?
            @re = GEO_RE
            geo_count = 0
            [:'@']
          when ',' then [:',']
          when ';' then [:';']
          when '/' then [:'/']
          when '|' then [:'|']
          when '[' then [:'[']
          when ']' then [:']']
          when '-' then [:'-']
          when '('    ## enter goal scorer mode on "free-floating" open paranthesis!!!
             puts "  ENTER GOAL_RE MODE"   if debug?
             @re = GOAL_RE
              ## note - eat-up ( for now; do NOT pass along as token
              ##       pass along "virutal" INLINE GOALS - why? why not?
              [:INLINE_GOALS, "<|INLINE_GOALS|>"]
          when ')' then [:')']
          else
            puts "!!! TOKENIZE ERROR (sym) - ignore sym >#{sym}<"
            nil  ## ignore others (e.g. brackets [])
          end
        elsif m[:any]
           ## todo/check log error
           msg = "parse error (tokenize) - skipping any match>#{m[:any]}< @#{offsets[0]},#{offsets[1]} in line >#{line}<"
           puts "!! WARN - #{msg}"

           errors << msg
           log( "!! WARN - #{msg}" )

           nil
        else
          ## report error
           puts "!!! TOKENIZE ERROR - no match found"
           nil
        end
      end


    tokens << t    if t

#    if debug?
#      print ">"
#      print "*" * pos
#      puts "#{line[pos..-1]}<"
#    end
  end

  ## check if no match in end of string
  if offsets[1] != line.size
    msg =  "!! WARN - parse error - skipping >#{line[offsets[1]..-1]}< @#{offsets[1]},#{line.size} in line >#{line}<"
    puts msg
    log( msg )

    errors << "parse error (tokenize) - skipping >#{line[offsets[1]..-1]}< @#{offsets[1]},#{line.size} in line >#{line}<"
  end


  # if @re == GOAL_RE   ### ALWAYS switch back to top level mode
  #   puts "  LEAVE GOAL_RE MODE, BACK TO TOP_LEVEL/RE"  if debug?
  #   @re = RE
  # end

   if @re == GEO_RE   ### ALWAYS switch back to top level mode
     puts "  LEAVE GEO_RE MODE, BACK TO TOP_LEVEL/RE"  if debug?
     @re = RE
   end

   @re = RE  if @re == GROUP_DEF_RE   ### ALWAYS switch back to top level mode
   @re = RE  if @re == ROUND_DEF_RE

   ##
   ## if in prop mode continue if   last token is [,-]
   ##        otherwise change back to "standard" mode
   if @re == PROP_RE            || @re == PROP_CARDS_RE ||
      @re == PROP_PENALTIES_RE ||
      @re == PROP_ATTENDANCE_RE || @re == PROP_REFEREE_RE
     if [:',', :'-', :';'].include?( tokens[-1][0] )
        ## continue/stay in PROP_RE mode
        ##  todo/check - auto-add PROP_CONT token or such
        ##                to help parser with possible NEWLINE
        ##                  conflicts  - why? why not?
     else
        ## switch back to top-level mode!!
        puts "  LEAVE PROP_RE MODE, BACK TO TOP_LEVEL/RE"  if debug?
        @re = RE
        ## note - auto-add PROP_END (<PROP_END>)
        tokens << [:PROP_END, "<|PROP_END|>"]
     end
   end


  [tokens,errors]
end


end ## class Lexer
end ## module SportDb
