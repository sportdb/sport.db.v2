module SportDb
class MatchTree

class Group
      attr_reader :name, :teams

      def initialize( name:,
                      teams: )
        @name   = name
        @teams  = teams
      end

      def pretty_print( printer )
        buf = String.new
        buf << "<Group #{@name} "
        buf << @teams.pretty_print_inspect
        buf << ">"

        printer.text( buf )
      end
end  # class Group


end # class MatchTree
end # module SportDb
