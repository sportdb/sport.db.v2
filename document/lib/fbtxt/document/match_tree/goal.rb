module Fbtxt
class MatchTree



class Goal  ### nested (non-freestanding) inside match (match is parent)
  attr_reader :team,                ## note - 1|2 expected
              :player,
              :minute,
              :offset,
              :owngoal,            ## true|false
              :penalty             ## true|false

  ## add alias for player => name - why? why not?
  alias_method :name, :player


  def owngoal?() @owngoal==true; end
  def penalty?() @penalty==true; end
  def team1?()   @team == 1; end
  def team2?()   @team == 2; end


  ## note: make score1,score2 optional for now !!!!
  def initialize( team:,
                  player:,
                  minute:,
                  offset:  nil,
                  owngoal: false,
                  penalty: false
                )
    @team    = team     # 1|2
    @player  = player
    @minute  = minute
    @offset  = offset
    @owngoal = owngoal
    @penalty = penalty
  end

  def state
    [@team,
     @player, @minute, @offset, @owngoal, @penalty
     ]
  end

  def ==(o)
    o.class == self.class && o.state == state
  end

  def pretty_print( q )
    q.group( 4, '<Goal', '>') do        ##  group( indent, open, close)
      buf = String.new
      buf << " #{@player} #{@minute}"
      buf << "+#{@offset}"    if @offset && @offset > 0
      buf << "'"
      q.text( buf )

      q.text( "(og)" )  if @owngoal
      q.text( "(p)" )   if @penalty
      q.text( " for #{@team}" )      ### team 1 or 2 - use home/away
    end
  end
end # class Goal


end # class MatchTree
end # module Fbtxt
