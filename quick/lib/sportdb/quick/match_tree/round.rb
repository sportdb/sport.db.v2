
module SportDb
class MatchTree


  class Round
      attr_reader   :name, :start_date, :end_date

      def initialize( name:,
                      start_date: nil,
                      end_date:   nil,
                      auto:       true )
        @name       = name
        @start_date = start_date
        @end_date   = end_date
        @auto       = auto        # auto-created (inline reference/header without proper definition before)
      end

      def pretty_print( printer )
        ## todo/check - how to display/format key - use () or not - why? why not?
        buf = String.new
        buf << "<Round"
        buf << " AUTO"    if @auto
        buf << ": "
        buf << "#{@name}, "
        buf << "#{@start_date}"
        buf << " - #{@end_date}"  if @start_date != @end_date
        buf << ">"

        printer.text( buf )
      end
end  # class Round


end # class MatchTree
end # module SportDb