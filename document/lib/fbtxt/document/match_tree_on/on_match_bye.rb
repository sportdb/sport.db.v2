module Fbtxt
class MatchTree



  def on_match_line_bye( node )
    _trace( "on match (bye): >#{node}<" )

    ## note - bye    records NO date/time or ground (or score etc.)
    ##                 for now only team1/team2 and match status!!
    ##                  plus inherited round/group

    status = 'bye'

    team = node.team

    @teams[ team ] += 1

    group =  nil
    group =  @last_group  if @last_group

    round = nil
    round =  @last_round  if @last_round

    @matches << Match.new( team1:    team,  ## note: for now always use mapping value e.g. rec (NOT string e.g. team1.name)
                           round:    round ? round.name : nil,  ## note: for now always use string (assume unique canonical name for event)
                           group:    group ? group.name : nil,  ## note: for now always use string (assume unique canonical name for event)
                           status:   status )
    ### todo: cache team lookups in hash?
  end



end ## class MatchTree
end ##  module Fbtxt
