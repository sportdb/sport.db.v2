module Fbtxt
class MatchTree


   ##
   ##  fix - move "upstream to lineup"  - why? why not?
   ##       - rename each_lineup?
   ##
   def _each_player( lineup, &blk )
     lineup.each do |item|
        blk.call(item)
        ## plus (walk) recursive sub(stitution)s
        current = item
        while current && current.sub
            blk.call( current.sub.sub )
            current = current.sub.sub
        end
     end
   end

   ## change to _collect_inline_bookings/cards - why? why not?
   def _collect_bookings( lineup )
      recs  = []

## Lineup     = Struct.new( :name, :captain, :cards, :sub )
## Card       = Struct.new( :name, :minute )
      _each_player( lineup ) do |item|
          if item.cards.is_a?(Array) && item.cards.size > 0
              item.cards.each do |card|
                 recs << EventCard.new(
                              ## fix/fix/fix change to card.type upstream - why? why not?
                                    type:   card.name,
                                    name:   item.name,
                                    minute: card.minute )

              end
           end
         end


## note - (auto-)sort by minute if present
   recs = recs.sort do |l,r|
                    if l.minute && r.minute
                            ## note - minute is obj!! (Fbtxt::Minute!!)
                            l.minute <=> r.minute
                    else
                       0   ## keep as is (no minutes available)
                    end
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

    ## todo/fix-fix-fix  add formation here too - why? why not?

    match.lineup  <<   Lineup.build( lineup )

    match.bookings ||=[]
    match.bookings << _collect_bookings( lineup )
  end


end ## class MatchTree
end ##  module Fbtxt
