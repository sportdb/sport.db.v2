$LOAD_PATH.unshift( '../parser/lib' )
require 'sportdb/parser'



OPENFOOTBALL_PATH = '../../../openfootball'


rootdir = "#{OPENFOOTBALL_PATH}/worldcup/min"





files = Dir.glob( "#{rootdir}/**/*.txt" )

pp files
puts "  #{files.size} file(s)"


log = []
files.each_with_index do |file,i|

##    puts rootdir
##      puts file
## ../../../openfootball/worldcup/min
## ../../../openfootball/worldcup/min/1930.txt
    ## get relative name to root
      name_relative =  file[ (rootdir.size+1)..-1 ]
     
     puts "==> [#{i+1}/#{files.size}]  #{name_relative} (in #{rootdir})..."


      txt = read_text( file )
      
      parser = RaccMatchParser.new( txt, debug: false )
      tree = parser.parse
      ## pp tree

      if parser.errors?
        puts "-- #{parser.errors.size} parse error(s):"
        pp parser.errors

        log << [name_relative, "!! - #{parser.errors.size} parse error(s)", parser.errors]
      else
        puts "--  OK - no parse errors found"

        log << [name_relative, "OK"]
      end
end


puts
puts "log - #{log.size} file(s) in (#{rootdir}):"
pp log


puts "bye"