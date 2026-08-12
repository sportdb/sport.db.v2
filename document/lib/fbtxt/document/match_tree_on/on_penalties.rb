module Fbtxt
class MatchTree


   ## check - use on_penalties_line ???
  def on_penalties( node )
    _trace( "on penalties: >#{node}<" )

    ## get last match
    match = @matches[-1]


    ##   PenaltiesLine = Struct.new( :penalties )
    ##   Penalty       = Struct.new( :name, :score, :note )

        #####
         ##  note
         ##     (i)  []          -  single line (no separator)
         ##     (ii) [[],[]]     -  nested team1/team2 (separator required)


    recs = nil

    if node.penalties.is_a?(Array) && node.penalties.size == 2 &&
       node.penalties[0].is_a?(Array) && node.penalties[1].is_a?(Array)

       ## use zip to make (flattend) sequence - why? why not?
       ##  we do NOT know who really started (picked via coin toss!!)
       ##    keep nested arrays for now
         recs = [[],[]]

         node.penalties.each_with_index.each do |pens,i|
            pens.each do |pen|
              recs[i]  << Penalty.new(
                            name:  pen.name,
                            score: pen.score,
                            note:  pen.note )
            end
        end
    else
      ## assume chronological sequence
      recs = []
      node.penalties.each do |pen|
         recs << Penalty.new(
                       name:  pen.name,
                       score: pen.score,
                       note:  pen.note )
      end
    end


     match.penalties = recs
  end


end ## class MatchTree
end ##  module Fbtxt
