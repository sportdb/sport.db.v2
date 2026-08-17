module Fbtxt
class MatchTree


  def on_coach( node )
    _trace( "on coach(es): >#{node}<" )


   ## note - support multiple coaches
   ##
   ##  CoachLine = Struct.new( :coaches )
   ##  Coach = Struct.new( :name, :country )

   ### note - for now gets auto-added
   ##                   to last lineup
   ##   (add to grammar  - coach_prop MUST follow lineup_prop !!)


   ####
   ##  fix-fix-fix
   ##   - use Coach.build( node - CoachProp )

    recs = []
    node.coaches.each do |coach|
        recs << Coach.new( name: coach.name, country: coach.country )
    end

     @last_lineup.coaches = recs
  end


end ## class MatchTree
end ##  module Fbtxt
