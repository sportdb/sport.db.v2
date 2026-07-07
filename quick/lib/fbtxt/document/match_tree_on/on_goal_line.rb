module Fbtxt
class MatchTree


  def on_goal_line( node )
    _trace( "on goal line: >#{node}<" )


     if node.goals[0].is_a?( Array )
       goals1, goals2 = node.goals[0], node.goals[1]
     else
       goals1 = node.goals
       goals2 = []
     end


    pp [goals1,goals2]     if debug?


## special rule
##    if goals 2 empty check if score for team 1 is zero
##                           and team 2 is NOT zero than
##                                make goals1 goald2!!
##   e.g. Norway 0-1  Austria
##                   (Hof 32)

   if goals2.empty? && !goals1.empty?

     match = @matches[-1]

     ##
     ## todo/fix
     ##   move upstream
     ##    use score1_zero? or such - why? why not?
     if (match.score.is_a?(Array) && match.score[0] == 0 ) ||
        (match.score.is_a?(Hash)  && match.score[:et] && match.score[:et][0] == 0) ||
        (match.score.is_a?(Hash)  && match.score[:et].nil? &&
                                     match.score[:ft] && match.score[:ft][0] == 0)
        ## "parallel assignment (or multiple assignment") - swap values in single line
        goals2, goals1 = goals1, goals2
     end
   end



   ##
   ## todo/fix - sort goals by minute (+offset) !!!

    goals = []

    goals1.each do |rec|
      rec.minutes.each do |minute|
        goal = Goal.new(
                  player: rec.player,
                  team:   1,
                  minute:  minute.m,
                  offset:  minute.offset,
                  penalty: minute.pen || false, #  note: pass along/use false NOT nil
                  owngoal: minute.og || false
                )
        goals << goal
      end
    end

    goals2.each do |rec|
      rec.minutes.each do |minute|
        goal = Goal.new(
                  player: rec.player,
                  team:   2,
                  minute:  minute.m,
                  offset:  minute.offset,
                  penalty: minute.pen || false, #  note: pass along/use false NOT nil
                  owngoal: minute.og || false
                )
      goals << goal
      end
    end

    pp goals   if debug?

    ## quick & dirty - auto add goals to last match
    ##   note - for hacky (quick& dirty) multi-line support
    ##     always append for now
    match = @matches[-1]
    match.goals ||= []
    match.goals += goals

    ## todo/fix
    ##   sort by minute
    ##    PLUS auto-fill score1,score2 - why? why not?
  end


end ## class MatchTree
end ##  module Fbtxt
