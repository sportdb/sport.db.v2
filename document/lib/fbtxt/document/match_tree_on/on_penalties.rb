module Fbtxt
class MatchTree


   ## check - use on_penalties_line ???
  def on_penalties( node )
    _trace( "on penalties: >#{node}<" )

    ## get last match
    match = @matches[-1]


    ##   PenaltiesLine = Struct.new( :penalties )
    ##   Penalty       = Struct.new( :name, :score, :note )

    recs = []

    node.penalties.each do |pen|
       recs << Penalty.new(
                       name:  pen.name,
                       score: pen.score,
                       note:  pen.note )
    end


     match.penalties = recs
  end


end ## class MatchTree
end ##  module Fbtxt
