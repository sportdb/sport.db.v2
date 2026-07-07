module Fbtxt
class MatchTree


  def on_group_def( node )
    _trace( "on group def: >#{node}<" )

   ## e.g
   ##  [:group_def, "Group A"],
   ##   [:team, "Germany"],
   ##   [:team, "Scotland"],
   ##   [:team, "Hungary"],
   ##   [:team, "Switzerland"]

    node.teams.each do |team|
          @teams[ team ] += 1
    end

    group = Group.new( name:  node.name,
                       teams: node.teams )

    @groups[ node.name ] = group
  end


end ## class MatchTree
end ##  module Fbtxt
