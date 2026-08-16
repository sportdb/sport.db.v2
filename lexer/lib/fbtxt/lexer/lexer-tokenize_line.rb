module Fbtxt
class Lexer



def _tokenize_line( line, lineno )
  tokens = []
  errors = []   ## keep a list of errors - why? why not?


  pos = 0        ## note - usually same as offset[1] aka offset[end] after match
  ## track last offset (begin/end) - to report error on no match
  ##   or no match in end of string
  offset = [0,0]
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
       tokens << Token.new(:ORD, m[:ord],
                                lineno: lineno, offset: m.offset(:ord),
                                value: m[:value].to_i(10)  )

       offset = m.offset(0)
       pos    = offset[1]      ## update pos

    elsif (m = START_WITH_GROUP_DEF_LINE_RE.match( line ))
      _trace( "ENTER GROUP_DEF_RE MODE" )
      @re = GROUP_DEF_RE

      tokens << Token.new( :GROUP_DEF, m[:group_def],
                               lineno: lineno, offset: m.offset(:group_def) )


      offset = m.offset(0)
      pos = offset[1]    ## update pos

    elsif (m = START_WITH_PROP_KEY_RE.match( line ))
      ##  start with prop key (match will switch into prop mode!!!)
      ##   - fix - remove leading spaces in regex (upstream) - why? why not?
      ##
      ###  switch into new mode
      ##  switch context  to PROP_RE
        _trace("ENTER PROP_RE MODE" )

        ##  check for (well-known) property (e.g. yellow,red,ref,attn, etc.)
        ## find prop spec (token_sym, mode , ..)
        prop = KNOWN_PROP_KEYS[ m[:key].downcase ]

        if prop
          ## e.g. :PROP_YELLOWCARD, PROP_CARDS_RE
          prop_token, prop_re, _ = prop

          @re = prop_re
          tokens << Token.new( prop_token, m[:key],
                                   lineno: lineno, offset: m.offset(:key))
        else   ## assume (team) line-up
          @re = PROP_LINEUP_RE
          ## fix-fix-fix - rename to PROP_LINEUP !!
          tokens << Token.new(:PROP, m[:key],
                                 lineno: lineno, offset: m.offset(:key))
        end

        offset = m.offset(0)
        pos    = offset[1]     ## update pos

    elsif (m = START_WITH_YEAR.match(line))
       tokens << Token.new(:YEAR, m[:year],
                                 lineno: lineno, offset: m.offset(:year),
                                 value:  m[:year].to_i(10) )

       offset = m.offset(0)
       pos    = offset[1]    ## update pos

    ###
    ### todo/fix
    ###   rename to START_WITH_ROUND_DEF_OUTLINE_RE !!!!
    elsif (m = ROUND_DEF_OUTLINE_RE.match( line ))
      _trace( "ENTER ROUND_DEF_RE MODE" )
      @re = ROUND_DEF_RE

      ## note - return ROUND_DEF NOT  ROUND_OUTLINE token
      ##   fix - add leading ▪ too!!
      tokens << Token.new( :ROUND_DEF, m[:round_outline],
                            lineno: lineno, offset: m.offset(:round_outline))

      offset = m.offset(0)
      pos    = offset[1]    ## update pos
    elsif (m = ROUND_OUTLINE_RE.match( line ))
      _trace( "ROUND_OUTLINE" )
      ## note - derive round level from no of (leading) markers
      ##             e.g. ▪/:: is 1, ▪▪/::: is 2, ▪▪▪/:::: is 3, etc.
      ##       note  - ascii-style starts with double ::, thus, autodecrement by one!
      round_level = m[:round_marker].size
      round_level -= 1  if m[:round_marker].start_with?( '::' )

      tokens << Token.new( :ROUND_OUTLINE, m[:round_outline],
                           lineno: lineno, offset: m.offset(:round_outline),
                           value: { outline: m[:round_outline],
                                    level: round_level})

      ## note - eats-up line for now (change later to only eat-up marker e.g. »|>>)
      offset = m.offset(0)
      pos    = offset[1]       ## update pos
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

        tokens << Token.virtual( :GOALS_COMPAT, lineno: lineno )
      elsif START_GOAL_LINE_ALT_RE.match( line )
        ##  goals with scores e.g.
        ##    (1-0 Franck Ribéry, 2-0 Ivica Olić, 2-1 Wayne Rooney)
        ##         -or-
        ##      (Dion Beljo  1-0
        ##                   1-1  Andreas Gruber
        ##   Matthias Seidl  2-1)
        @re = GOAL_ALT_RE
        _trace( "ENTER GOAL_ALT_RE MODE" )

        tokens << Token.virtual( :GOALS_ALT, lineno: lineno )
      else
        ## "standard" / default style
        @re = GOAL_RE
        _trace( "ENTER GOAL_RE MODE" )

        tokens << Token.virtual( :GOALS, lineno: lineno )
      end

      ## note - eat-up ( for now
      ##   pass along "virtual" GOALS or GOALS_ALT token
      ##      (see INLINE_GOALS for the starting goal line inline)
      ##
      ## fix-fix-fix
      ##  keep offset at [0,0] - why? why not?
      ##    do NOT eat-up
      ##   or better
      ##    add tokens << Token.literal( '(', lineno: lineno, offset: ...) !!!
      offset = m.offset(0)
      pos    = offset[1]      ## update pos
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
    offset = m.offset(0)
    ctx.offset = offset



    if offset[0] != pos
      ## match NOT starting at start/begin position!!!
      ##  report parse error!!!
      msg =  "parse error (tokenize) - skipping >#{line[pos..(offset[0]-1)]}< in line #{lineno}@#{offset[0]},#{offset[1]} >#{line}<"
      errors << msg

      log( msg )
      puts "!! WARN - #{msg}"
    end


    ##
    ## todo/fix - also check if possible
    ##   if no match but not yet end off string!!!!
    ##    report skipped text run too!!!

    old_pos = pos
    pos     = offset[1]

#    pp offset  if debug?

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
                    ##
                    ## todo/fix
                    ##   add virtual geo_end token!!!
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
                ## keep pos - why? why not?
               Token.new(:GEO, m[:text],
                                lineno: lineno, offset: m.offset(:text))
           elsif m[:geo_end]   ## "hacky" special comma; always ends geo mode!!!
                 ## get out-off geo mode and backtrack (w/ next)
                    ## todo/fix
                    ##   add (semi-) virtual geo_end token!!!
                 _trace( "LEAVE GEO_RE MODE, BACK TO TOP_LEVEL/RE" )
                 @re = RE
                 pos = old_pos
                 next   ## backtrack (resume new loop step)
           elsif m[:sym]
              case m[:sym]
                ## note - reset geo_count to 0 (avoids break on two spaces)
                ##                     if separator seen!!
              when ',' then @geo_count = 0
                            Token.literal( m[:sym], lineno: lineno, offset: m.offset(:sym))
              when '›' then @geo_count = 0;
                            Token.literal( ',', lineno: lineno, offset: m.offset(:sym))
                                ## note - treat geo sep › (unicode) like comma for now!!!
              when '>' then @geo_count = 0;
                            Token.literal( ',', lineno: lineno, offset: m.offset(:sym))
                               ## note - treat geo sep > (ascii) like comma for now!!!


              when '[','▪'
                    ##
                    ## todo/fix
                    ##   add virtual geo_end token!!!
                 ## get out-off geo mode and backtrack (w/ next)
                 _trace( "LEAVE GEO_RE MODE, BACK TO TOP_LEVEL/RE" )
                 @re = RE
                 pos = old_pos
                 next   ## backtrack (resume new loop step)
               ## fix-fix-fix  merge  '▪' with '['
              else
                 Token.literal( m[:sym], lineno: lineno, offset: m.offset(:sym))
              end
           else
             ctx.warn_on_else( m, mode: 'GEO' )
             nil
           end
      elsif @re == PROP_CARDS_RE       then  _on_prop_cards( m, ctx: ctx )
      elsif @re == PROP_LINEUP_RE      then  _on_prop_lineup( m, ctx: ctx )
      elsif @re == PROP_ATTENDANCE_RE  then  _on_prop_attendance( m, ctx: ctx )
      elsif @re == PROP_REFEREE_RE     then  _on_prop_referee( m, ctx: ctx )
      elsif @re == PROP_PENALTIES_RE   then  _on_prop_penalties( m, ctx: ctx )
      elsif @re == PROP_COACH_RE       then  _on_prop_coach( m, ctx: ctx )

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
  if offset[1] != line.size
    msg =  "parse error (tokenize) - skipping >#{line[offset[1]..-1]}< in line #{lineno}@#{offset[1]},#{line.size} >#{line}<"
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

=begin
   ##
   ## if in prop mode continue if   last token is [,-]
   ##        otherwise change back to "standard" mode
   if @re == PROP_LINEUP_RE     ||
      @re == PROP_CARDS_RE      ||
      @re == PROP_PENALTIES_RE  ||
      @re == PROP_ATTENDANCE_RE ||
      @re == PROP_REFEREE_RE

     ## note - add :CARDS_SEP_ALT (aka  -)!!! too
     ##   maybe later  CARDS_NONE_LEFT too - why? why not?
     if [',', '-', ';', :CARDS_SEP_ALT].include?( tokens[-1].type)
        ## continue/stay in PROP_RE mode
        ##  todo/check - auto-add PROP_CONT token or such
        ##                to help parser with possible NEWLINE
        ##                  conflicts  - why? why not?
     else
        ## switch back to top-level mode!!
        _trace( "LEAVE PROP_RE MODE, BACK TO TOP_LEVEL/RE" )
        @re = RE
        ## note - auto-add PROP_END (<PROP_END>)
        tokens << Token.virtual(:PROP_END, lineno: lineno)
     end
   end
=end



  ##########
  ## note - auto-add end token
  ##     inside multi-line token format that is,  prop_cont or goal_cont
  if is_prop_cont? || is_goal_cont?
      ## do NOT add end token; continue
      _trace( "auto-continue - is_prop_cont? #{is_prop_cont?}, is_goal_cont? #{is_goal_cont?}" )
  else
      tokens << Token.virtual(:END, lineno: lineno)
  end


  [tokens,errors]
end


end ## class Lexer
end ## module Fbtxt
