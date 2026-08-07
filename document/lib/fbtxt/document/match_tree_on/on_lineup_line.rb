module Fbtxt
class MatchTree


   def _collect_subs( lineup )
      recs = []

      lineup.each do |item|
           if item.sub
              recs << EventSub.new( off:  item.name,
                                    on:   item.sub.sub.name,
                                    minute: item.sub.minute )
               ## note - for now only check one recursive level "by hand"
               if item.sub.sub.sub
                  recs << EventSub.new( off: item.sub.sub.name,
                                        on:  item.sub.sub.sub.sub.name,
                                        minute: item.sub.sub.sub.minute )
               end
           end
      end

      recs
    end


   def _collect_bench( lineup )
      recs = []

      lineup.each do |item|
           if item.sub
              recs << Player.new( name:    item.sub.sub.name,
                                  captain: item.sub.sub.captain )
               ## note - for now only check one recursive level "by hand"
               if item.sub.sub.sub
                  recs << Player.new( name:    item.sub.sub.sub.sub.name,
                                       captain: item.sub.sub.sub.sub.captain )
               end
           end
      end
      recs
   end

   def _collect_lineup( lineup )
    recs = []
    lineup.each do |item|
 ##       puts " lineup.each item:"
 ##       pp item
        recs << Player.new( name:    item.name,
                            captain: item.captain )
    end
    recs
   end


  def on_lineup_line( node )
    _trace( "on lineup: >#{node}<" )

    ## get last match
    match = @matches[-1]

    ## collect players
    team_name = node.team
    lineup    = node.lineup

    ## note -
    ##  lineup - uses nested array format
    ##    for formation
    ##
    ##  quick & dirty hack - flatten for now
    ##    refine later
    lineup = lineup.flatten

##  LineupLine = Struct.new( :team, :lineup, :formation, :coach ) do
##  Lineup     = Struct.new( :name, :captain, :cards, :sub ) do
##   Sub        = Struct.new( :minute, :sub )  do

    ## todo/check if team name match
    ##  warn if no match

    match.lineup ||= []
    match.lineup << _collect_lineup( lineup )

    match.bench ||=[]
    match.bench << _collect_bench( lineup )

    match.subs ||=[]
    match.subs << _collect_subs( lineup )
  end


end ## class MatchTree
end ##  module Fbtxt
