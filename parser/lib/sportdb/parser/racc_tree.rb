
####
#   RaccMatchParser support machinery (incl. node classes/abstract syntax tree)

class RaccMatchParser

RefereeLine = Struct.new( :name, :country ) do 
  def pretty_print( printer )
    printer.text( "<RefereeLine " )
    printer.text( self.name )
    printer.text( " (#{self.country})" )  if self.country
    printer.text( ">" )
  end
end

AttendanceLine = Struct.new( :att ) do 
  def pretty_print( printer )
    printer.text( "<AttendanceLine #{self.att}>" )
  end
end



PenaltiesLine = Struct.new( :penalties ) do   
  def pretty_print( printer )
    printer.text( "<PenaltiesLine " )
    printer.text( self.penalties.pretty_inspect )
    printer.text( ">" )
  end
end

Penalty = Struct.new( :name, :score, :note ) do
  def to_s
    buf = String.new
    buf << "#{self.score} "   if self.score
    buf <<  self.name
    buf << " (#{self.note})"    if self.note 
    buf
  end

  def pretty_print( printer )
    printer.text( to_s )
  end  
end




##  find a better name for player (use bookings?) - note - red/yellow card for trainer possible
CardsLine = Struct.new( :type, :bookings ) do   
  def pretty_print( printer )
    printer.text( "<CardsLine " )
    printer.text( self.type )
    printer.text( " bookings=" + self.bookings.pretty_inspect )
    printer.text( ">" )
  end
end

Booking = Struct.new( :name, :minute ) do
  def to_s
    buf = String.new
    buf << "#{self.name}"
    buf << " #{self.minute.to_s}"   if self.minute
    buf
  end

  def pretty_print( printer )
    printer.text( to_s )
  end  
end



LineupLine = Struct.new( :team, :lineup, :coach ) do
  def pretty_print( printer )
    printer.text( "<LineupLine " )
    printer.text( self.team )
    printer.text( " lineup=" + self.lineup.pretty_inspect )
    printer.text( " coach=" + self.coach )   if self.coach
    printer.text( ">" )
  end
end


Lineup     = Struct.new( :name, :card, :sub ) do
  def pretty_print( printer )
    buf = String.new
    buf <<  self.name 
    buf << " card=" + self.card.pretty_inspect    if card
    buf << " sub=" + self.sub.pretty_inspect      if sub
    printer.text( buf ) 
  end
end


Card       = Struct.new( :name, :minute ) do
  def to_s
    buf = String.new
    buf << "#{self.name}"
    buf << " #{self.minute.to_s}"   if self.minute
    buf
  end

  def pretty_print( printer )
    printer.text( to_s )
  end  
end


Sub        = Struct.new( :minute, :sub )  do
  def pretty_print( printer )
    buf = String.new 
    buf << "("    ## note - possibly recursive (thus, let minute go first/print first/upfront)
    buf << "#{self.minute.to_s} "   if self.minute  
    buf << "#{self.sub.pretty_inspect}" 
    buf << ")"
    printer.text( buf ) 
  end
end



GroupDef   = Struct.new( :name, :teams ) do
  def pretty_print( printer )
    printer.text( "<GroupDef " )
    printer.text( self.name )
    printer.text( " teams=" + self.teams.pretty_inspect )
    printer.text( ">" )
  end
end


RoundDef   = Struct.new( :name, :date, :duration )  do
  def pretty_print( printer )
    printer.text( "<RoundDef " )
    printer.text( self.name )
    printer.text( " date=" + self.date.pretty_inspect ) if self.date
    printer.text( " duration=" + self.duration.pretty_inspect ) if self.duration
    printer.text( ">" )
  end
end

DateHeader = Struct.new( :date, :year ) do
  def pretty_print( printer )
    printer.text( "<DateHeader " )
    printer.text( "#{self.date.pretty_inspect}" )  if self.date
    printer.text( "#{self.year.pretty_inspect}" )  if self.year
    printer.text( ">")
  end
end

DateHeaderLegs = Struct.new( :date1, :date2 ) do
  def pretty_print( printer )
    printer.text( "<DateHeaderLegs " )
    printer.text( "leg1=#{self.date1.pretty_inspect}" )
    printer.text( " leg2=#{self.date2.pretty_inspect}" )
    printer.text( ">")
  end
end



RoundOutline = Struct.new( :outline, :level ) do
  def pretty_print( printer )
    printer.text( "<RoundOutline #{self.outline}, level=#{self.level}>" )
  end
end


NoteLine = Struct.new( :text ) do
  def pretty_print( printer )
    printer.text( "<NoteLine #{self.text}>" )
  end
end

NotaBene = Struct.new( :text ) do
  def pretty_print( printer )
    printer.text( "<NotaBene #{self.text}>" )
  end
end


##  todo/check - rename TableHeading to TableHeader - why? why not?
TableHeading = Struct.new( :text ) do
  def pretty_print( printer )
    printer.text( "<TableHeading #{self.text}>" )
  end
end

##  todo/check - rename TableDivider to TableRule/TableRuler/TableLine - why? why not?
TableDivider = Struct.new( :text ) do
  def pretty_print( printer )
    printer.text( "<TableDivider #{self.text}>" )
  end
end

TableLine = Struct.new( :text ) do
  def pretty_print( printer )
    printer.text( "<TableLine #{self.text}>" )
  end
end

TableNote = Struct.new( :text ) do
  def pretty_print( printer )
    printer.text( "<TableNote #{self.text}>" )
  end
end



## todo/check - use a generic Heading instead of Heading1/2/3 - why? why not?
Heading1 = Struct.new( :text ) do
  def pretty_print( printer )
    printer.text( "<Heading1 #{self.text}>" )
  end
end

Heading2 = Struct.new( :text ) do
  def pretty_print( printer )
    printer.text( "<Heading2 #{self.text}>" )
  end
end

Heading3 = Struct.new( :text ) do
  def pretty_print( printer )
    printer.text( "<Heading3 #{self.text}>" )
  end
end



MatchLineBye   = Struct.new( :team, :note ) do
 def pretty_print( printer )
    printer.text( "<MatchLineBye " )
    printer.text( "#{self.team} bye")
    printer.text( " note=#{self.note.pretty_inspect}" )  if self.note
    printer.text( ">" )
  end  
end

MatchLineWalkover   = Struct.new( :team1, :team2, :note ) do
 def pretty_print( printer )
    printer.text( "<MatchLineWalkover " )
    printer.text( "#{self.team1} w/o #{self.team2}")
    printer.text( " note=#{self.note.pretty_inspect}" )  if self.note
    printer.text( ">" )
  end  
end

MatchLineLegs   = Struct.new( :team1, :team2, 
                              :score )  do   ## change to geos - why? why not?
 def pretty_print( printer )
    printer.text( "<MatchLineLegs " )
    printer.text( "#{self.team1} v #{self.team2}")
    printer.breakable

    members.zip(values) do |name, value|
      next if [:team1, :team2].include?( name )
      next if value.nil?
      
      printer.text( "#{name}=#{value.pretty_inspect}" )
    end    

    printer.text( ">" )
  end  
end


#
#  note: use two status attributes for now
#         1) inline_status and 2) (note_)status
#              for now  e.g.  A abd. B     vs   A  v B [abadoned] 
#                             A 3-0 awd B  vs   A  3-0 B [awarded]
#   note - BOTH might be present at the same time


MatchLine   = Struct.new( :header,
                          :num, :date, :time, :time_local,
                          :team1, :team2, 
                          :score,
                          :status,  :status_inline,
                          :geo,
                          :note,
                          :att )  do   ## change to geos - why? why not?

  def pretty_print( printer )
    printer.text( "<MatchLine " )
    printer.text( "#{self.team1} v #{self.team2}")
    printer.breakable

    members.zip(values) do |name, value|
      next if [:team1, :team2].include?( name )
      next if value.nil?
      
      printer.text( "#{name}=#{value.pretty_inspect}" )
    end    

    printer.text( ">" )
  end  

end


GoalLine    = Struct.new( :goals1, :goals2 ) do
  def pretty_print( printer )
    printer.text( "<GoalLine " )
    printer.text( "goals1=" + self.goals1.pretty_inspect + "," )
    printer.breakable
    printer.text( "goals2=" + self.goals2.pretty_inspect + ">" )
  end  
end


###
##  change/rename Goal to GoalScorer  - why? why not?

Goal        = Struct.new( :player, :minutes, :count ) do
  def to_s
    buf = String.new
    buf << "#{self.player}"
    if count
       buf << (" " + count.pretty_inspect + ",")
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

  def pretty_print( printer )
    printer.text( to_s )
  end  

end


## check - use a different name e.g. GoalLineScore or such - why? why not?
GoalLineAlt = Struct.new( :goals ) do
  def pretty_print( printer )
    printer.text( "<GoalLineAlt " )
    printer.text( "goals=" + self.goals.pretty_inspect + ">" )
  end  
end


##
##   score and player REQUIRED
##   note - (goal) minute is optional
##          if no minute goal type is optional e.g. "standalone" (p), (og), etc.

GoalAlt   = Struct.new( :score, :player, :minute, :goal_type ) do
  def to_s
    buf = String.new
    buf << "#{self.score[0]}-#{self.score[1]}"  
    buf << " #{self.player}"
    buf << " #{self.minute}"     if self.minute
    buf << " #{self.goal_type}"  if self.goal_type
    buf
  end

  def pretty_print( printer )
    printer.text( to_s )
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
    def to_s
      buf = String.new
      buf << "#{self.m}"
      buf << "'"
      buf << "+#{self.offset}"  if self.offset 
      buf << " (og)"   if self.og
      buf << " (pen)"  if self.pen
      buf << " (f)"  if self.freekick
      buf << " (h)"  if self.header
      buf << " (#{self.secs} secs)"   if self.secs
      buf
    end
 
    def pretty_print( printer ) 
       printer.text( to_s ) 
    end  

    ### quick hack:
    ### split struct into  Minute+GoalType structs
    def to_minute
        Minute.new( m:      self.m, 
                    offset: self.offset,
                    secs:   self.secs )
    end

    def to_goal_type
        if self.og || self.pen || self.header || self.freekick   
          GoalType.new( og:       self.og, 
                        pen:      self.pen, 
                        header:   self.header,
                        freekick: self.freekick )
        else
           nil   ## note - return nil; if no goal type present!!
        end
    end
end


GoalType  = Struct.new( :og, :pen, :header, :freekick )  do
    def to_s
      buf = String.new
      buf << "(og)"   if self.og
      buf << "(pen)"  if self.pen
      buf << "(f)"    if self.freekick
      buf << "(h)"    if self.header
      buf
    end
 
    def pretty_print( printer ) 
       printer.text( to_s ) 
    end  
end


Minute      = Struct.new( :m, :offset, :secs )  do
    def to_s
      buf = String.new
      buf << "#{self.m}"
      buf << "'"
      buf << "+#{self.offset}"      if self.offset 
      buf << "/#{self.secs} secs"   if self.secs
      buf
    end
 
    def pretty_print( printer ) 
       printer.text( to_s ) 
    end  
end

end  # class RaccMatchParser