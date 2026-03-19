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
   '../fbtxt-rsssf',
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

        log << [filename, "OK"]
      end
   end


   puts
   puts "log - #{log.size} file(s):"
   pp log
end



DEFAULT =  parse_names( <<TXT )
   main.txt
   chat.txt
   chat2.txt
   chat3.txt
   dates.txt
   formats.txt

   ### check goal formats
   goals.txt
   goals_alt.txt
   goals_compat.txt

   ### check more
   header.txt
   home_away.txt
   note.txt
   ord.txt
   score.txt
   status.txt
   table.txt
   country.txt
   year.txt
   tty.txt

   todos_complete.txt

   quick.txt

   ##  todos.txt
   ##  penalties.txt  -- fix
   ##  defs.txt  -- fix
TXT



WORLDCUP = parse_names( <<TXT )
   worldcup/1930--uruguay/cup.txt
   worldcup/1934--italy/cup.txt
   worldcup/1938--france/cup.txt

   worldcup/1950--brazil/cup.txt
   worldcup/1954--switzerland/cup.txt
   worldcup/1958--sweden/cup.txt
   worldcup/1958--sweden/cup.txt
   worldcup/1962--chile/cup.txt
   worldcup/1966--england/cup.txt
   worldcup/1970--mexico/cup.txt
   worldcup/1974--west-germany/cup.txt
   worldcup/1978--argentina/cup.txt
   worldcup/1982--spain/cup.txt

   worldcup/1986--mexico/cup.txt
   worldcup/1986--mexico/cup_finals.txt

   worldcup/1990--italy/cup.txt
   worldcup/1990--italy/cup_finals.txt

   worldcup/1994--usa/cup.txt
   worldcup/1994--usa/cup_finals.txt

   worldcup/1998--france/cup.txt
   worldcup/1998--france/cup_finals.txt

   worldcup/2002--south-korea-n-japan/cup.txt
   worldcup/2002--south-korea-n-japan/cup_finals.txt

   worldcup/2006--germany/cup.txt
   worldcup/2006--germany/cup_finals.txt

   worldcup/2010--south-africa/cup.txt
   worldcup/2010--south-africa/cup_finals.txt

   worldcup/2014--brazil/cup.txt
   worldcup/2014--brazil/cup_finals.txt

   worldcup/2018--russia/cup.txt
   worldcup/2018--russia/cup_finals.txt

   worldcup/2022--qatar/cup.txt
   worldcup/2022--qatar/cup_finals.txt

   worldcup/2026--usa/cup.txt
   worldcup/2026--usa/cup_finals.txt
TXT


WORLDCUP2 = parse_names( <<TXT )  
   ##########
   ## check some planetworldcup samples
   worldcup/planetworldcup/wc10.txt
   worldcup/planetworldcup/wc14.txt
   worldcup/planetworldcup/wc30.txt

   worldcup/planetworldcup/wc94qualification.txt

   ##############
   ## check some rsssf samples
   worldcup/rsssf/30full.txt
   worldcup/rsssf/34f.txt
   worldcup/rsssf/38f.txt
   worldcup/rsssf/2014f.txt
   worldcup/rsssf/2022f.txt
   worldcup/rsssf/worldcup.txt
   
   worldcup/rsssf/2022q.txt
TXT


EURO = parse_names( <<TXT )
    euro/rsssf/60e.txt
    euro/rsssf/64e.txt
    euro/rsssf/68e.txt
    euro/rsssf/72e.txt
    euro/rsssf/2024e.txt
    euro/rsssf/eurochamp.txt
TXT


AUSTRIA =  parse_names( <<TXT )

  ##############
  #  austriascoccer.at
  austria/austriasoccer.at/20240922rapiaust0.txt
  austria/austriasoccer.at/20250330rapifc_r0.txt
  austria/austriasoccer.at/aktuell.txt
  austria/austriasoccer.at/cup_2025_26.txt
  austria/austriasoccer.at/o1__bundesliga__2025_26.txt
  austria/austriasoccer.at/vorschau.txt

  ####
  #  rapidarchiv.at
  austria/rapidarchiv.at/2025-26.txt

  #####
  #  rsssf
  austria/rsssf/oost01.txt
  austria/rsssf/oost01_cup.txt
  austria/rsssf/oost2025.txt
  austria/rsssf/oost2025_cup.txt
TXT


ENGLAND =  parse_names( <<TXT )   
  england/rsssf/eng2020-facup.txt
  england/rsssf/eng2020-leaguecup.txt
  england/rsssf/eng2024-playoffs.txt
  england/rsssf/eng2024-playoffs_details.txt
  england/rsssf/eng2024-playoffs_v2.txt
  england/rsssf/eng2024-premierleague.txt
  england/rsssf/eng2025-premierleague.txt
  england/rsssf/engcup1872.txt
  england/rsssf/engcup1873.txt
TXT


RSSSF = parse_names( <<TXT )
   86full.patch.txt
   2014f.patch.txt
TXT



if __FILE__ == $0

  args = ARGV

  if args.size == 0  
    args = DEFAULT 
  elsif args.size == 1 && (args[0] == 'worldcup' || args[0] == 'wc')
    args = WORLDCUP
  elsif args.size == 1 && (args[0] == 'worldcup2' || args[0] == 'wc2')
    args = WORLDCUP2
  elsif args.size == 1 && (args[0] == 'euro')
    args = EURO
  elsif args.size == 1 && (args[0] == 'austria' || args[0] == 'at')
    args = AUSTRIA
  elsif args.size == 1 && (args[0] == 'england' || args[0] == 'eng')
    args = ENGLAND
  elsif args.size == 1 && args[0] == 'rsssf'
    args = RSSSF
  end

  fbtree( args )
  puts "bye" 
end