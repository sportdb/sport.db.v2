module Fbtxt
class MatchTree


  def on_goal_line_alt( node )
    _trace( "on goal line (alt): >#{node}<" )

   ## quick & dirty - auto add goals to last match
   ##   note - for hacky (quick& dirty) multi-line support
   ##     always append for now
   match = @matches[-1]


##  GoalLineAlt = Struct.new( :goals )
##
##   score and player REQUIRED
##   note - (goal) minute is optional
##          if no minute goal type is optional e.g. "standalone" (p), (og), etc.
##
##   GoalAlt   = Struct.new( :score, :player, :minute, :goal_type )


    goals = []

    node.goals.each do |rec|
        goal = GoalAlt.new(
                  score:  rec.score,
                  name:   rec.player,
                  minute:  rec.minute,
                  penalty: rec.goal_type ? rec.goal_type.pen : false, #  note: pass along/use false NOT nil
                  owngoal: rec.goal_type ? rec.goal_type.og  : false
                )
        goals << goal
    end


    pp goals   if debug?


    ## todo/fix
    ##    PLUS auto-fill score1,score2 - why? why not?

    ## quick & dirty - auto add goals to last match
    ##   note - for hacky (quick& dirty) multi-line support
    ##     always append for now
    match.goals_alt = goals
  end


end ## class MatchTree
end ##  module Fbtxt
