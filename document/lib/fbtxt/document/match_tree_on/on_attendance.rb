module Fbtxt
class MatchTree

  def on_attendance( node )
    _trace( "on attn: >#{node}<" )

    ## get last match
    match = @matches[-1]

    att = node.att
    match.update( att: att )
  end



end ## class MatchTree
end ##  module Fbtxt
