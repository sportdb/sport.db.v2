  
  def parse
    ## ...

    # note - GroupHeader is now part of "generic" RoundOutline 
       elsif node.is_a? RaccMatchParser::GroupHeader
          on_group_header( node )
   # note - RoundHeader is now part of "generic" RoundOutline
        elsif node.is_a? RaccMatchParser::RoundHeader
           on_round_header( node )
  end
    

  
  def _prep_lines( lines )   ## todo/check:  add alias preproc_lines or build_lines or prep_lines etc. - why? why not?

    ## todo/fix - rework and make simpler
    ##             no need to double join array of string to txt etc.

    txt =  if lines.is_a?( Array )
               ## join together with newline
                lines.reduce( String.new ) do |mem,line|
                                               mem << line; mem << "\n"; mem
                                           end
             else  ## assume single-all-in-one txt
                lines
             end

    ##  preprocess automagically - why? why not?
    ##   strip lines with comments and empty lines striped / removed
    txt_new = String.new
    txt.each_line do |line|    ## preprocess
       line = line.strip
       next if line.empty? || line.start_with?('#')   ###  skip empty lines and comments
       
       line = line.sub( /#.*/, '' ).strip             ###  cut-off end-of line comments too
       
       txt_new << line
       txt_new << "\n"
    end
    txt_new
  end


  def on_group_header( node )
    logger.debug "on group header: >#{node}<"

    # note: group header resets (last) round  (allows, for example):
    #  e.g.
    #  Group Playoffs/Replays       -- round header
    #    team1 team2                -- match
    #  Group B                      -- group header
    #    team1 team2 - match  (will get new auto-matchday! not last round)
    @last_round     = nil

    name = node.name

    group = @groups[ name ]
    if group.nil?
      puts "!! PARSE ERROR - no group def found for >#{name}<"
      exit 1
    end

    # set group for games
    @last_group = group
  end


    def on_round_header( node )
    logger.debug "on round header: >#{node}<"

    ### note - auto-add names with - for now (use comma)
    ##            why? why not?
    ### check - use ' - ' for separator - why? why not?
    name = node.names.join( ', ' )   
=begin
    ## note: was node.names[0]    ## ignore more names for now
                                  ## fix later - fix more names!!!
=end

   # name = name.sub( ROUND_EXTRA_WORDS_RE, '' )
    # name = name.strip



    round = @rounds[ name ]
    if round.nil?    ## auto-add / create if missing
      ## todo/check: add num (was pos) if present - why? why not?
      round = Import::Round.new( name: name )
      @rounds[ name ] = round
    end

    ## todo/check: if pos match (MUST always match for now)
    @last_round = round
    @last_group = nil   # note: reset group to no group - why? why not?

    ## todo/fix/check
    ##  make round a scope for date(time) - why? why not?
    ##   reset date/time e.g. @last_date = nil !!!!
  end



