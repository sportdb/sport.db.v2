####
#  to run use:
#    $ ruby ./fbtree.rb         (in /fbtxt)

$LOAD_PATH.unshift( '../lib' )
require 'sportdb/parser'




##
## note - use File.file? instead of File.exist? 
##            (checks if file exists AND file is a file NOT a directory)


def find_file( name, path: )
    return name    if File.file?( name )

    path.each do |dir|
        filepath = File.join( dir, name )
        return filepath   if File.file?(  filepath )
    end

    puts "!! ERROR - file <#{name}> not found; looking in path: #{path.inspect}"
    exit 1
end


def parse_names( txt )
   names = []
   txt.each_line do |line|
       line = line.strip
       next if line.empty? || line.start_with?('#')

       names << line
   end
   names
end





PATH = [
   '../fbtxt-samples',
   '../../../../openfootball', 
]

def fbtree( args, path: PATH )
   log = []

   args.each_with_index do |name,i|
      puts "==> #{i+1}/#{args.size} #{name}..."

      filename = find_file( name, path: path )

      txt = read_text( filename )


      parser = RaccMatchParser.new( txt, debug: true )
      tree = parser.parse
      pp tree

      if parser.errors?
        puts "-- #{parser.errors.size} parse error(s):"
        pp parser.errors

        log << [filename, "!! - #{parser.errors.size} parse error(s)", parser.errors]
      else
        puts "--  OK - no parse errors found"

        log << [filename, "OK - no parse errors found"]
      end
   end


   puts
   puts "log - #{log.size} file(s):"
   pp log
end



DEFAULT =  parse_names( <<TXT )
   chat.txt
   dates.txt
   formats.txt

   ### check goal formats
   goals.txt
   goals_alt.txt
   goals_compat.txt
TXT

WORLDCUP = parse_names( <<TXT )
   worldcup/2026--usa/cup.txt
   worldcup/2026--usa/cup_finals.txt

   ##########
   ## check some planetworldcup samples
   worldcup/planetworldcup/wc10.txt
   worldcup/planetworldcup/wc14.txt
   worldcup/planetworldcup/wc30.txt
   worldcup/planetworldcup/wc94qualification.txt

   ##############
   ## check some rsssf samples
   worldcup/rsssf/2014f.txt
   worldcup/rsssf/2022f.txt
   worldcup/rsssf/30full.txt
   worldcup/rsssf/34f.txt
   worldcup/rsssf/38f.txt
   
   ## worldcup/rsssf/2022q.txt
TXT


if __FILE__ == $0

  args = ARGV

  if args.size == 0  
    args = DEFAULT 
  elsif args.size == 1 && (args[0] == 'worldcup' || args[0] == 'wc')
    args = WORLDCUP
  end

  fbtree( args )
  puts "bye" 
end