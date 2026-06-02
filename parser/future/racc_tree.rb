


## todo/check - find a better name for hruler - divider?  or ??? - why? why not?
class HRuler   ## h(orizontal) ruler (for breaks; new scopes)
  def pretty_print( printer )
    printer.text( "<HRuler>" )
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
