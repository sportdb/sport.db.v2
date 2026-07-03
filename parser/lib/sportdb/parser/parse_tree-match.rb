module SportDb
  class Parser



MatchLineBye   = Struct.new( :team, :note ) do
  def pretty_print( q )
    q.group( 4, '<MatchLineBye ', '>') do        ##  group( indent, open, close)
      q.text( "#{team} bye")
      if note
        q.text( " note=" )
        q.pp( note )
      end
    end
  end
end  # MatchLineBye




MatchLineLegs   = Struct.new( :team1, :team2,
                              :score )  do
  def pretty_print( q )
    q.group( 4, '<MatchLineLegs ', '>') do        ##  group( indent, open, close)
      q.text( "#{team1} v #{team2}")

      members.zip(values) do |name, value|
        next if [:team1, :team2].include?( name )
        next if value.nil?

        q.breakable
        q.text( "#{name}=" )
        q.pp( value )
      end
    end
  end
end


#
#  note: use two status attributes for now
#         1) inline_status and 2) (note_)status
#              for now  e.g.  A abd. B     vs   A  v B [abadoned]
#                             A 3-0 awd B  vs   A  3-0 B [awarded]
#   note - BOTH might be present at the same time


MatchLine   = Struct.new( :header,  :tty,   ## tty = TELETYPE MODE for teams and score!!
                          :num, :date, :time, :time_local, :year,
                          :team1, :team2,
                          :score,
                          :status,  :status_inline, :status_note,
                          :round_inline_short, :round_inline_big,
                          :geo,
                          :neutral,  ## true/false - NOT -home/away - neutral ground
                          :note,
                          :att )  do   ## change to geos - why? why not?


  def as_json(*)
    h =  { 'team1' => team1.as_json,
           'team2' => team2.as_json,
         }

      members.zip(values) do |name, value|
        next if [:team1, :team2].include?( name )
        next if value.nil?

        h[name.to_s] = value.as_json
      end

    ['<MatchLine>', h]
  end


  def pretty_print( q )
    q.group( 4, '<MatchLine ', '>') do        ##  group( indent, open, close)
      q.text( "#{team1} v #{team2}")

      members.zip(values) do |name, value|
        next if [:team1, :team2].include?( name )
        next if value.nil?

        q.breakable
        q.text( "#{name}=" )
        q.pp( value )
      end
    end
  end

end  #  struct MatchLine



GoalLine    = Struct.new( :goals ) do

  def as_json(*)
    ['<GoalLine>', { 'goals' => goals.as_json }]
  end

  def pretty_print( q )
    q.group( 4, '<GoalLine ', '>') do
      q.text( "goals=" )
      q.pp( goals )
    end
  end
end  # GoalLine



###
##  change/rename Goal to GoalScorer  - why? why not?

Goal        = Struct.new( :player, :minutes, :count ) do

  def as_json(*)
    h = { 'player' => player.as_json }

    h['count']   = count.as_json     if count
    h['minutes'] = minutes.as_json   if minutes && !minutes.empty?

    ## ['<Goal>', h]
    h   # note - return "inline" json object
  end


  def to_s
    buf = String.new
    buf << "#{player}"
    if count
       buf << (" " + count.inspect + ",")
    else
      if minutes.nil? || minutes.empty?
        ## add nothing if no minutes available/present
      else
        buf << " "
        buf << minutes.map { |min| min.to_s }.join(' ')
      end
    end
    buf
  end

  def pretty_print( q )
    q.text( to_s )
  end
end


## check - use a different name e.g. GoalLineScore or such - why? why not?
GoalLineAlt = Struct.new( :goals ) do
  def pretty_print( q )
    q.group( 4, '<GoalLineAlt ', '>') do
      q.text( "goals=" )
      q.pp( goals )
    end
  end
end  # GoalLineAlt


##
##   score and player REQUIRED
##   note - (goal) minute is optional
##          if no minute goal type is optional e.g. "standalone" (p), (og), etc.

GoalAlt   = Struct.new( :score, :player, :minute, :goal_type ) do
  def to_s
    buf = String.new
    buf << "#{score[0]}-#{score[1]}"
    buf << " #{player}"
    buf << " #{minute}"     if minute
    buf << " #{goal_type}"  if goal_type
    buf
  end

  def pretty_print( q )
    q.text( to_s )
  end
end  # GoalAlt



GoalLineCompat = Struct.new( :goals ) do
  def pretty_print( q )
    q.group( 4, '<GoalLineCompat ', '>') do
      q.text( "goals=" )
      q.pp( goals )
    end
  end
end  # GoalLineCompat


##
##   minute and player REQUIRED
##   note - score (e.g. 1-1) is optional
##          goal type is optional e.g. "standalone" (p), (og), etc.

GoalCompat    = Struct.new( :score, :player, :minute, :goal_type ) do
  def to_s
    buf = String.new
    buf << "#{minute}"
    buf << " #{player}"
    buf << " #{goal_type}"             if goal_type
    buf << " #{score[0]}-#{score[1]}"  if score
    buf
  end

  def pretty_print( q )
    q.text( to_s )
  end
end



##   FIX/FIX/FIX
##   split into Minute and
##             GoalMinute  (Minute+GoalType)
##
##  fix - move :og, :pen  to Goal if possible - why? why not?
##  or change to GoalMinute ???
##
##  fix!!! split into GoalMinute and Minute
##            goal_minute incl. :og, :pen, :freekick, :header,
##                     seconds etc.
##
##  GoalMinute = Minute + GoalType !!!

GoalMinute      = Struct.new( :m, :offset, :secs,
                             :og, :pen, :header, :freekick,
                         )  do


    def as_json(*)  to_s; end

    def to_s
      buf = String.new
      buf << "#{m}"
      buf << "'"
      buf << "+#{offset}"  if offset
      buf << "(og)"   if og
      buf << "(p)"  if pen
      buf << "(f)"  if freekick
      buf << "(h)"  if header
      buf << " (#{secs} secs)"   if secs
      buf
    end

    def pretty_print( q )
       q.text( to_s )
    end

    ### quick hack:
    ### split struct into  Minute+GoalType structs
    def to_minute
        Minute.new( m:      m,
                    offset: offset,
                    secs:   secs )
    end

    def to_goal_type
        if og || pen || header || freekick
          GoalType.new( og:       og,
                        pen:      pen,
                        header:   header,
                        freekick: freekick )
        else
           nil   ## note - return nil; if no goal type present!!
        end
    end
end


GoalType  = Struct.new( :og, :pen, :header, :freekick )  do
    def to_s
      buf = String.new
      buf << "(og)"   if og
      buf << "(pen)"  if pen
      buf << "(f)"    if freekick
      buf << "(h)"    if header
      buf
    end

    def pretty_print( q )
       q.text( to_s )
    end
end   # GoalType



Minute      = Struct.new( :m, :offset, :secs )  do
    def as_json(*) to_s; end

    def to_s
      buf = String.new
      buf << "#{m}"
      buf << "'"
      buf << "+#{offset}"      if offset
      buf << "/#{secs} secs"   if secs
      buf
    end

    def pretty_print( q )
       q.text( to_s )
    end
end  # Minute



  end   # class Parser
end   # module SportDb
