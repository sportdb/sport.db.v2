
module Fbtxt
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

      def pretty_print( q )
        ## todo/check - how to display/format key - use () or not - why? why not?
        q.group( 4, '<Round', '>') do        ##  group( indent, open, close)
           q.text( " AUTO" )    if @auto
           q.text( " #{@name}" )
           if @start_date
             q.text( " : #{@start_date}" )
             q.text( " - #{@end_date}" )   if @start_date != @end_date
           end
        end
      end
end  # class Round


end # class MatchTree
end # module Fbtxt