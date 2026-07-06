

    elsif node.is_a? RaccMatchParser::MatchLineWalkover
          on_match_line_walkover( node )





 def on_match_line_walkover( node )
    logger.debug( "on match (w/o): >#{node}<" )

    ## note - w/o (walkover) records NO date/time or ground (or score etc.)
    ##                 for now only team1/team2 and match status!!
    ##                  plus inherited round/group

    status = 'walkover'   ## use w/o - why? why not?

    team1 = node.team1
    team2 = node.team2

    @teams[ team1 ] += 1
    @teams[ team2 ] += 1


    group =  nil
    group =  @last_group  if @last_group

    round = nil
    round =  @last_round  if @last_round

    @matches << Match.new( team1:    team1,  ## note: for now always use mapping value e.g. rec (NOT string e.g. team1.name)
                           team2:    team2,  ## note: for now always use mapping value e.g. rec (NOT string e.g. team2.name)
                           round:    round ? round.name : nil,  ## note: for now always use string (assume unique canonical name for event)
                           group:    group ? group.name : nil,  ## note: for now always use string (assume unique canonical name for event)
                           status:   status )
    ### todo: cache team lookups in hash?
  end
