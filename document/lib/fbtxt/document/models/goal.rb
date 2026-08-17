module Fbtxt
 module Model


class Goal  ### nested (non-freestanding) inside match (match is parent)

  attr_reader :team,                ## note - 1|2 expected
              :name,
              :minute,
              :owngoal,            ## true|false
              :penalty             ## true|false

  ## add alias for player => name - why? why not?
  ## alias_method :player, :name

  def owngoal?() @owngoal==true; end
  def penalty?() @penalty==true; end
  def team1?()   @team == 1; end
  def team2?()   @team == 2; end


  def initialize( team:,
                  name:,
                  minute:  nil,
                  owngoal: false,
                  penalty: false
                )
    @team    = team     # 1|2
    @name    = name

    ## note - auto-convert to our own Minute format
    ##        is obj/incl. (optional) offset/injury time!!
    @minute =  if minute.is_a?( Parser::Minute )
                        Minute.new( m:      minute.m,
                                    offset: minute.offset,
                                    secs:   minute.secs )
                   else
                    minute
                   end

    @owngoal = owngoal
    @penalty = penalty
  end

  def state
    [@team,
     @name, @minute, @owngoal, @penalty
     ]
  end

  def ==(o)
    o.class == self.class && o.state == state
  end

  def pretty_print( q )
    q.group( 4, '<Goal ', '>') do        ##  group( indent, open, close)
      q.text( name )
      q.text( " #{@minute}" )    if @minute

      q.text( "(og)" )  if @owngoal
      q.text( "(p)" )   if @penalty
      q.text( " for #{@team}" )      ### team 1 or 2 - use home/away
    end
  end


   ### note  - EXCLUDE team 1|2 from serialize
   ##            maybe remove alltogether and split into goals[[],[]] - why? why not?
    def as_json(*)
        h = { 'name'  => name  }

=begin
          ## note - use a string for minutes for now
          ##           allows e.g.  45+2 etc. too
          minute_str  = "#{goal.minute}"
          minute_str += "+#{goal.offset}"   if goal.offset

          node['minute']  = minute_str
=end

        h['minute'] = minute.to_s    if minute

        h['owngoal'] = true         if owngoal?
        h['penalty'] = true         if penalty?

        h
    end


end # class Goal





class GoalAlt  ### nested (non-freestanding) inside match (match is parent)

  attr_reader :score,
              :name,
              :minute,
              :owngoal,            ## true|false
              :penalty             ## true|false

  def owngoal?() @owngoal==true; end
  def penalty?() @penalty==true; end


  def initialize( score:,
                  name:,
                  minute:  nil,
                  owngoal: false,
                  penalty: false
                )
    @score    = score
    @name    = name

    ## note - auto-convert to our own Minute format
    ##        is obj/incl. (optional) offset/injury time!!
    @minute =  if minute.is_a?( Parser::Minute )
                        Minute.new( m:      minute.m,
                                    offset: minute.offset,
                                    secs:   minute.secs )
                   else
                    minute
                   end

    @owngoal = owngoal
    @penalty = penalty
  end

  def state
    [@score,
     @name, @minute, @owngoal, @penalty
     ]
  end

  def ==(o)
    o.class == self.class && o.state == state
  end

  def pretty_print( q )
    q.group( 4, '<GoalAlt ', '>') do        ##  group( indent, open, close)
      q.text( " #{score}" )
      q.text( " #{@name}" )
      q.text( " #{@minute}" )    if @minute

      q.text( "(og)" )  if @owngoal
      q.text( "(p)" )   if @penalty
    end
  end


   ### note  - EXCLUDE team 1|2 from serialize
   ##            maybe remove alltogether and split into goals[[],[]] - why? why not?
    def as_json(*)
        h = { 'score' => score,
              'name'  => name  }

=begin
          ## note - use a string for minutes for now
          ##           allows e.g.  45+2 etc. too
          minute_str  = "#{goal.minute}"
          minute_str += "+#{goal.offset}"   if goal.offset

          node['minute']  = minute_str
=end

        h['minute'] = minute.to_s    if minute

        h['owngoal'] = true         if owngoal?
        h['penalty'] = true         if penalty?

        h
    end


end # class GoalAlt



end # module Model
end # module Fbtxt
