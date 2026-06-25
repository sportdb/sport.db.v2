
class RaccMatchParser


=begin
RefereeLine = Struct.new( :name, :country ) do
  def pretty_print( printer )
    printer.text( "<RefereeLine " )
    printer.text( name )
    printer.text( " (#{country})" )  if country
    printer.text( ">" )
  end
end
=end


## support multiple referees (incl. assistant refs etc.)
RefereeLine = Struct.new( :referees ) do
  def pretty_print( q )
    q.group( 4, '<RefereeLine ', '>') do
      q.pp( referees )
    end
  end
end   # RefereeLine

Referee = Struct.new( :name, :country ) do
  def to_s
    buf = String.new
    buf <<  name
    buf << " (#{country})"    if country
    buf
  end

  def pretty_print( q )
    q.text( to_s )
  end
end  # Referee


AttendanceLine = Struct.new( :att ) do
  def pretty_print( q )
    q.group( 4, '<AttendanceLine ', '>') do
      q.pp( att )
    end
  end
end  # AttendanceLine




PenaltiesLine = Struct.new( :penalties ) do
  def as_json(*)
    ['<PenaltiesLine>', { 'penalties' => penalties.as_json }]
  end

  def pretty_print( q )
    q.group( 4, '< ', '>') do
      q.pp( penalties )
    end
  end
end  # PenaltiesLine


Penalty = Struct.new( :name, :score, :note ) do
  def as_json(*)
   h = { 'name' => name }
   h['score'] =  "#{score[0]}-#{score[1]}"   if score
   h['note']  =  "(#{note})"                 if note

   ## ['<Penalty>', h]
   h   # note - return "inline" json object
  end

  def to_s
    buf = String.new
    buf << "#{score[0]}-#{score[1]} "   if score
    buf <<  name
    buf << " (#{note})"    if note
    buf
  end


  def pretty_print( q )
    q.text( to_s )
  end
end  # Penalty




##  find a better name for player (use bookings?) - note - red/yellow card for trainer possible
CardsLine = Struct.new( :type,
                        :bookings,
                        :bookings1, :bookings2
                         ) do
  def pretty_print( q )
    q.group( 4, '<CardsLine ', '>') do
      q.text( type )
      ## note - either (all-in-one or undetermined) bookings
      ##                               or booking1/bookings2
      if bookings
        q.text( " bookings=" )
        q.pp( bookings )
      else
        q.text( " bookings1=" )
        q.pp( bookings1 )
        q.text( " bookings2=" )
        q.pp( bookings2 )
      end
    end
  end
end  # CardsLine


Booking = Struct.new( :name, :minute ) do
  def to_s
    buf = String.new
    buf << "#{name}"
    buf << " #{minute.to_s}"   if minute
    buf
  end

  def pretty_print( q )
    q.text( to_s )
  end
end  # Booking




##
## change :lineup to :lineups  (e.g. requires array of lineups)
LineupLine = Struct.new( :team, :lineup, :coach ) do
  def as_json(*)
    h = { 'team'    => team.as_json,
          'lineups' => lineup.as_json
        }
    h['coach']  =  coach.as_json               if coach

    ['<LineupLine>', h]
  end

  def pretty_print( q )
    q.group( 4, '<LineupLine ', '>') do
      q.text( team )
      q.text( ' ' )

      ##  todo/fix - check for   "flat" items - no formation
      ##                           or empty lineup (possible?)
      ## add formation e.g. (1-) 3-4-2-1
      formation = lineup.map { |item| item.size }
      ## note - remove first entry (assume it's 1 for goalee!)
      formation.shift
      q.text( formation.join('-'))
      q.text( ' ')

      q.pp( lineup )

      if coach
        q.breakable
        q.text( "coach=" + coach )
      end
    end
  end
end  # LineupLine


Lineup     = Struct.new( :name, :captain, :cards, :sub ) do
  def as_json(*)
    h = { 'name'   => name.as_json }
    h['captain']   =  captain.as_json   if captain
    h['cards']     =  cards.as_json     if cards
    h['sub']       =  sub.as_json       if sub

    ## ['<Lineup>', h]
    h     ## note - return "inline" json object (not tagged array with json object)
  end

  def pretty_print( q )
    q.group( 0, '', '') do    ##  group( indent, open, close)
      q.text( name )
      q.text( ' [c]' )   if captain

      if cards
        q.text( ' ' )
        q.pp( cards )
      end

      if sub
        q.breakable   ## can become either a space or a newline
        q.pp( sub )
      end
    end
  end
end  # Lineup





Card       = Struct.new( :name, :minute ) do
  def as_json(*)  to_s; end

  def to_s
    buf = String.new
    buf << "#{name}"
    buf << " #{minute.to_s}"   if minute
    buf
  end

  def pretty_print( q )
    q.text( to_s )
  end
end



##
##  fix-fix-fix
##    change :sub  to :lineup  - why? why not?

Sub        = Struct.new( :minute, :sub )  do
  def as_json(*)
    h = { 'lineup' => sub.as_json }
    h['minute'] =  minute.as_json       if minute

    ## ['<Sub>', h]
    h  # note - return "inline" json object (not tagged array with json object)
  end

  def pretty_print( q )
    q.group( 0, '(', ')') do
       q.text( "#{minute.to_s} " )   if minute
       q.pp( sub )
    end
  end
end  # Sub


end # class RaccMatchParser
