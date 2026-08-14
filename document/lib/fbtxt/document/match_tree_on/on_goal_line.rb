module Fbtxt
class MatchTree


  def on_goal_line( node )
    _trace( "on goal line: >#{node}<" )

     ###
     #  note: goals formats
     #   (i)   [[],[]]   (nested/paired) or
     #   (ii)  []        (flat/undefined)
     ##
     ##   add Array#paired? and
     ##       Array#flat?
     ##    helper methods/checks or such - why? why not?

     if node.goals[0].is_a?( Array )
       goals1, goals2 = node.goals[0], node.goals[1]
     else
       goals1 = node.goals
       goals2 = []
     end


    pp [goals1,goals2]     if debug?


   ## quick & dirty - auto add goals to last match
   ##   note - for hacky (quick& dirty) multi-line support
   ##     always append for now
   match = @matches[-1]


## special rule
##    if goals 2 empty check if score for team 1 is zero
##                           and team 2 is NOT zero than
##                                make goals1 goals2!!
##   e.g. Norway 0-1  Austria
##                   (Hof 32)
   if match.score &&
      goals2.empty? && !goals1.empty?

     ##
     ## todo/fix: move upstream
     ##             use score1_zero? or such - why? why not?
     if (match.score.reported?  && match.score.reported[0] == 0 ) ||
        (match.score.et? && match.score.et[0] == 0) ||
        (match.score.ft? && !match.score.et? && match.score.ft[0] == 0)
        ## "parallel assignment (or multiple assignment") - swap values in single line
        goals2, goals1 = goals1, goals2
     end
   end



    goals = []

    goals1.each do |rec|
      rec.minutes.each do |minute|
        goal = Goal.new(
                  name:   rec.player,
                  team:   1,
                  minute:  minute.to_minute, ## from GoalMinute to Minute!!
                  penalty: minute.pen || false, #  note: pass along/use false NOT nil
                  owngoal: minute.og || false
                )
        goals << goal
      end
    end

    goals2.each do |rec|
      rec.minutes.each do |minute|
        goal = Goal.new(
                  name:   rec.player,
                  team:   2,
                  minute:  minute.to_minute, ## from GoalMinute to Minute!!
                  penalty: minute.pen || false, #  note: pass along/use false NOT nil
                  owngoal: minute.og || false
                )
      goals << goal
      end
    end


    pp goals   if debug?


    ## todo/fix
    ##    PLUS auto-fill score1,score2 - why? why not?

    ## quick & dirty - auto add goals to last match
    ##   note - for hacky (quick& dirty) multi-line support
    ##     always append for now
    match.goals ||= []
    match.goals += goals


    ##   always keep goal list sorted by minute - why? why not?
    ##     - sort only on serialize (as_json) - why? why not?
    match.goals = match.goals.sort do |l,r|
                    if l.minute && r.minute
                            ## note - minute is obj!! (Fbtxt::Minute!!)
                            l.minute <=> r.minute
                    else
                       ## keep as is (no minutes available)
                       0
                    end
               end
  end


end ## class MatchTree
end ##  module Fbtxt
