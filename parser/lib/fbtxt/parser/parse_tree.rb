
####
#   Parser support machinery (incl. node classes/abstract syntax tree)


module Fbtxt
  class Parser


GroupDef   = Struct.new( :name, :teams ) do

  def as_json(*)
    ["<GroupDef>", { 'name'   => name.as_json,
                     'teams'  => teams.as_json }
    ]
  end

  def pretty_print( q )
    q.group( 4, '<GroupDef ', '>' ) do        ##  group( indent, open, close)
      q.text( name )
      q.text( " teams=" )
      q.pp( teams )
    end
  end
end  # GroupDef



##
## note -   for now exclusive really
##                    either date OR duration
RoundDef   = Struct.new( :name, :date, :duration )  do

  def as_json(*)
    h = { 'name' => name.as_json }

    h['date']     = date.as_json      if date
    h['duration'] = duration.as_json  if duration

    ["<RoundDef>", h]
  end

  def pretty_print( q )
    q.group( 4, '<RoundDef ', '>' ) do
      q.text( name )
      if date
        q.text( " date=")
        q.pp( date )
      end
      if duration
        q.text( " duration=")
        q.pp( duration )
      end
    end
  end

end  # RoundDef


##
## note -   for now exclusive really
##                    either date OR year
DateHeader = Struct.new( :date, :year ) do

  def as_json(*)
    h = {}
    h['date']   = date.as_json     if date
    h['year']   = year.as_json     if year

    ['<DateHeader>', h]
  end


  def pretty_print( q )
    q.group( 4, '<DateHeader ', '>' ) do
      q.pp( date )  if date
      q.pp( year )  if year
    end
  end
end   # DateHeader



DateHeaderLegs = Struct.new( :date1, :date2 ) do

  def as_json(*)
    ['<DateHeaderLegs>', { 'leg1' => date1.as_json,
                           'leg2' => date2.as_json,
                         }
    ]
  end

  def pretty_print( q )
    q.group( 4, '<DateHeaderLegs ', '>' ) do
      q.text( "leg1=" )
      q.pp( date1 )
      q.text( " leg2=" )
      q.pp( date2 )
    end
  end
end   # DateHeaderLegs



RoundOutline = Struct.new( :outline, :level ) do
  def as_json(*)
    ['<RoundOutline>', { 'outline' => outline.as_json,
                         'level'   => level.as_json, }
    ]
  end

  def pretty_print( q )
    q.group( 4, '<RoundOutline ', '>' ) do
       q.text( outline )
       q.text( " level=#{level}" )
    end
  end
end  # RoundOutline





class BlankLine
  def as_json(*)
    ['<BlankLine>']
  end

  def pretty_print( q )
    q.text( "<BlankLine>" )
  end
end  # BlankLine



NoteLine = Struct.new( :text ) do
  def as_json(*)
    ['<NoteLine>', { 'text' => text.as_json } ]
  end
  def pretty_print( q )
    q.group( 4, '<NoteLine ', '>' ) do
      q.text( text )
    end
  end
end  # NoteLine


NotaBene = Struct.new( :text ) do
  def as_json(*)
    ['<NotaBene>', { 'text' => text.as_json } ]
  end
  def pretty_print( q )
    q.group( 4, '<NotaBene ', '>' ) do
      q.text( text )
    end
  end
end  # NotaBene





## todo/check - use a generic Heading instead of Heading1/2/3 - why? why not?
Heading1 = Struct.new( :text ) do
  def as_json(*)
    ['<Heading1>', { 'text' => text.as_json }]
  end

  def pretty_print( q )
    q.group( 4, '<Heading1 ', '>' ) do
      q.text( text )
    end
  end
end # Heading1

Heading2 = Struct.new( :text ) do
  def as_json(*)
    ['<Heading2>', { 'text' => text.as_json }]
  end

  def pretty_print( q )
    q.group( 4, '<Heading2 ', '>' ) do
      q.text( text )
    end
  end
end  #  Heading2

Heading3 = Struct.new( :text ) do
  def as_json(*)
    ['<Heading3>', { 'text' => text.as_json }]
  end

  def pretty_print( q )
    q.group( 4, '<Heading3 ', '>' ) do
      q.text( text )
    end
  end
end  # Heading3


  end   # class Parser
end   # module Fbtxt
