module SportDb
class MatchTree

class Group
      attr_reader :name, :teams

      def initialize( name:,
                      teams: )
        @name   = name
        @teams  = teams
      end

      def pretty_print( q )
        q.group( 4, '<Group', '>') do        ##  group( indent, open, close)
          q.text( " #{@name} " )
          q.pp( @teams )
        end
      end
end  # class Group


end # class MatchTree
end # module SportDb
