module SportDb
class Lexer



###
## use nested class for context - why? why not?
##   note: first arg passed in MUST be ref to lexer (instance)
class Context
   ## passed along to on_round_def etc. handlers in tokenize_line
   ##   note - for now only offsets (in line begin/end) gets updated !!!
     attr_writer :offsets

     def initialize( lexer,
                     line:,
                     lineno:,
                     errors: )
        @lexer   = lexer
        @line    = line
        @lineno  = lineno
        @errors  = errors

        @offsets = [0,0]   ## or use [] aka [nil,nil] for not defined??? why? why not?
        ## @offsets = offsets    ## MatchData offsets e.g. [m.begin(0),m.end(0)]
     end



     def warn_skip_any( any, mode: 'TOP')
        _add_warn( "skip ANY match >#{any}< (#{mode})" )
     end

     def warn_unknown_match( match, mode: 'TOP' )
        _add_warn( "unknown match (#{mode}): #{match.pretty_inspect}")
     end


     def _add_warn( msg )
        ## note - warns gets logged as error for now too
        ##          maybe add @warns later - why? why not?
        msg =  "parse error (tokenize) -" +
                          msg +
                " in line #{@lineno}@#{@offsets[0]},#{@offsets[1]} >#{@line}<  "

        @errors << msg
        @lexer.log( "!! WARN - #{msg}" )

        @lexer._warn( msg )
     end

=begin
     ##  use report/log/??_parses_error
     def _add_error( msg )
         msg = "parse error (tokenize) -" +
                          msg +
                " in line #{@lineno}@#{@offsets[0]},#{@offsets[1]} >#{@line}<  "

        @errors << msg
     end
=end

end  # class Context





def _tokenize_line( line, lineno )
  tokens = []
  errors = []   ## keep a list of errors - why? why not?


  pos = 0
  ## track last offsets - to report error on no match
  ##   or no match in end of string
  offsets = [0,0]
  m = nil

  ## track number of geo text seen
  ##    (use for - do NOT break on two spaces if no geo text seen yet!!)
  @geo_count = 0

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

    elsif (m = START_WITH_GROUP_DEF_LINE_RE.match( line ))
      _trace( "ENTER GROUP_DEF_RE MODE" )
      @re = GROUP_DEF_RE

      tokens << [:GROUP_DEF, m[:group_def]]

      offsets = [m.begin(0), m.end(0)]
      pos = offsets[1]    ## update pos

    elsif (m = START_WITH_PROP_KEY_RE.match( line ))
      ##  start with prop key (match will switch into prop mode!!!)
      ##   - fix - remove leading spaces in regex (upstream) - why? why not?
      ##
      ###  switch into new mode
      ##  switch context  to PROP_RE
        _trace("ENTER PROP_RE MODE" )
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
          @re = PROP_LINEUP_RE
          tokens << [:PROP, m[:key]]
        end

        offsets = [m.begin(0), m.end(0)]
        pos = offsets[1]    ## update pos
    ###
    ### todo/fix
    ###   rename to START_WITH_ROUND_DEF_OUTLINE_RE !!!!
    elsif (m = ROUND_DEF_OUTLINE_RE.match( line ))
      _trace( "ENTER ROUND_DEF_RE MODE" )
      @re = ROUND_DEF_RE

      ## note - return ROUND_DEF NOT  ROUND_OUTLINE token
      tokens << [:ROUND_DEF, m[:round_outline]]

      offsets = [m.begin(0), m.end(0)]
      pos = offsets[1]    ## update pos
    elsif (m = ROUND_OUTLINE_RE.match( line ))
      _trace( "ROUND_OUTLINE" )
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
        _trace( "ENTER GOAL_COMPAT_RE MODE" )

        tokens << [:GOALS_COMPAT, "<|GOALS_COMPAT|>"]
      elsif START_GOAL_LINE_ALT_RE.match( line )
        ##  goals with scores e.g.
        ##    (1-0 Franck Ribéry, 2-0 Ivica Olić, 2-1 Wayne Rooney)
        ##         -or-
        ##      (Dion Beljo  1-0
        ##                   1-1  Andreas Gruber
        ##   Matthias Seidl  2-1)
        @re = GOAL_ALT_RE
        _trace( "ENTER GOAL_ALT_RE MODE" )

        tokens << [:GOALS_ALT, "<|GOALS_ALT|>"]
      else
        ## "standard" / default style
        @re = GOAL_RE
        _trace( "ENTER GOAL_RE MODE" )

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




  ctx = Context.new( self,
                     line:   line,
                     lineno: lineno,
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
      msg =  "parse error (tokenize) - skipping >#{line[pos..(offsets[0]-1)]}< in line #{lineno}@#{offsets[0]},#{offsets[1]} >#{line}<"
      errors << msg

      log( msg )
      puts "!! WARN - #{msg}"
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



  t = if    @re == ROUND_DEF_RE      then   _on_round_def( m, ctx: ctx )
      elsif @re == GROUP_DEF_RE      then   _on_group_def( m, ctx: ctx )
      elsif @re == GEO_RE
           ### note - possibly end inline geo on [ (and others?? in the future
           ## note: break on double spaces e.g.
           ## e.g. Jul/16 @ Arena Auf Schalke, Gelsenkirchen  Serbia 0-1 England
           if m[:spaces]
                 ### note - do NOT break out
                 ##           if not text seen yet!!!
                 if @geo_count > 0
                    ## get out-off geo mode and backtrack (w/ next)
                    _trace( "LEAVE GEO_RE MODE, BACK TO TOP_LEVEL/RE" )
                    @re = RE
                    pos = old_pos
                    next   ## backtrack (resume new loop step)
                 else
                     nil   ## skip spaces
                 end
           elsif m[:space]
               nil    ## skip (single) space
           elsif m[:text]
               @geo_count += 1
               [:GEO, m[:text]]   ## keep pos - why? why not?
           elsif m[:geo_end]   ## "hacky" special comma; always ends geo mode!!!
                 ## get out-off geo mode and backtrack (w/ next)
                 _trace( "LEAVE GEO_RE MODE, BACK TO TOP_LEVEL/RE" )
                 @re = RE
                 pos = old_pos
                 next   ## backtrack (resume new loop step)
           elsif m[:sym]
              case m[:sym]
                ## note - reset geo_count to 0 (avoids break on two spaces)
                ##                     if separator seen!!
              when ',' then @geo_count = 0; [:',']
              when '›' then @geo_count = 0; [:',']  ## note - treat geo sep › (unicode) like comma for now!!!
              when '>' then @geo_count = 0; [:',']  ## note - treat geo sep > (ascii) like comma for now!!!
              when '[' then
                 ## get out-off geo mode and backtrack (w/ next)
                 _trace( "LEAVE GEO_RE MODE, BACK TO TOP_LEVEL/RE" )
                 @re = RE
                 pos = old_pos
                 next   ## backtrack (resume new loop step)
              else
                 [m[:sym].to_sym]
              end
           else
             if m[:any]
                ctx.warn_skip_any( m[:any], mode: 'GEO' )
             else
                ctx.warn_unknown_match( m, mode: 'GEO' )
             end
             nil
           end
      elsif @re == PROP_CARDS_RE       then  _on_prop_cards( m, ctx: ctx )
      elsif @re == PROP_LINEUP_RE      then  _on_prop_lineup( m, ctx: ctx )
      elsif @re == PROP_ATTENDANCE_RE  then  _on_prop_attendance( m, ctx: ctx )
      elsif @re == PROP_REFEREE_RE     then  _on_prop_referee( m, ctx: ctx )
      elsif @re == PROP_PENALTIES_RE   then  _on_prop_penalties( m, ctx: ctx )
      elsif @re == GOAL_COMPAT_RE      then  _on_goal_compat( m, ctx: ctx )
      elsif @re == GOAL_ALT_RE         then  _on_goal_alt( m, ctx: ctx )
      elsif @re == GOAL_RE             then  _on_goal( m, ctx: ctx )
      ###################################################
      ## assume TOP_LEVEL (a.k.a. RE) machinery
      else
          _on_top( m, ctx: ctx )
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
    msg =  "parse error (tokenize) - skipping >#{line[offsets[1]..-1]}< in line #{lineno}@#{offsets[1]},#{line.size} >#{line}<"
    errors << msg

    log( msg )
    puts "!! WARN - #{msg}"
  end


  # if @re == GOAL_RE   ### ALWAYS switch back to top level mode
  #   puts "  LEAVE GOAL_RE MODE, BACK TO TOP_LEVEL/RE"  if debug?
  #   @re = RE
  # end

   if @re == GEO_RE   ### ALWAYS switch back to top level mode
     _trace( "LEAVE GEO_RE MODE, BACK TO TOP_LEVEL/RE" )
     @re = RE
   end

   ### ALWAYS switch back to top level mode
   @re = RE  if @re == GROUP_DEF_RE ||
                @re == ROUND_DEF_RE

   ##
   ## if in prop mode continue if   last token is [,-]
   ##        otherwise change back to "standard" mode
   if @re == PROP_LINEUP_RE     ||
      @re == PROP_CARDS_RE      ||
      @re == PROP_PENALTIES_RE  ||
      @re == PROP_ATTENDANCE_RE ||
      @re == PROP_REFEREE_RE
     if [:',', :'-', :';'].include?( tokens[-1][0] )
        ## continue/stay in PROP_RE mode
        ##  todo/check - auto-add PROP_CONT token or such
        ##                to help parser with possible NEWLINE
        ##                  conflicts  - why? why not?
     else
        ## switch back to top-level mode!!
        _trace( "LEAVE PROP_RE MODE, BACK TO TOP_LEVEL/RE" )
        @re = RE
        ## note - auto-add PROP_END (<PROP_END>)
        tokens << [:PROP_END, "<|PROP_END|>"]
     end
   end


  [tokens,errors]
end


end ## class Lexer
end ## module SportDb
