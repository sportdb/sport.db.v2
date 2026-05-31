$LOAD_PATH.unshift( '../lib' )
require 'sportdb/parser'



##
##  parse_names vs parse_data
##    names returns a single array with strings
##         parse data return a array of array with strings
##
##  check with dates if reuse possible?
##    uses same read/parse??
##     try to find common ground for reuse!!!


##
##  naming -  or use parse_strings?
##    read_lines/parse_lines already in use
##          returns array (unfilterd - comments, blanks) AND incl. newline!!!

def parse_names( txt )
   names = []
   txt.each_line do |line|
       line = line.strip
       next if line.empty? || line.start_with?('#')

       names << line
   end
   names
end
