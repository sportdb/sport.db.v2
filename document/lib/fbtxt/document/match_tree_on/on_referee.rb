module Fbtxt
class MatchTree


  def on_referee( node )
    _trace( "on referee(s): >#{node}<" )

    ## get last match
    match = @matches[-1]

   ## support multiple referees (incl. assistant refs etc.)
   ##  RefereeLine = Struct.new( :referees )
   ##  Referee = Struct.new( :name, :country )

    recs = []
    node.referees.each do |ref|
        recs << Referee.new( name: ref.name, country: ref.country )
    end

     match.referees = recs
  end


end ## class MatchTree
end ##  module Fbtxt
