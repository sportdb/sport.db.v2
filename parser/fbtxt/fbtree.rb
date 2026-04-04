####
#  to run use:
#    $ ruby ./fbtree.rb         (in /fbtxt)

require_relative 'helper'



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

      ## txt = read_text( filename )
      txt = read_blocktxt( filename ).text  

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
 
   penalties.txt
   referees.txt
   lineups.txt
   
   todos_complete.txt

   quick.txt

   ##  todos.txt
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

   worldcup/2026--usa/quali_playoffs.txt
TXT


WORLDCUP2 = parse_names( <<TXT )
   ###
   ## check samples in /more
   worldcup/more/1930.txt
   worldcup/more/1934.txt
   worldcup/more/1938.txt
   worldcup/more/1950.txt   
   worldcup/more/1954.txt
   worldcup/more/1958.txt
   worldcup/more/1962.txt
   worldcup/more/1966.txt
   worldcup/more/1970.txt
   worldcup/more/1974.txt
   worldcup/more/1978.txt
   worldcup/more/1982.txt
   worldcup/more/1986.txt
   worldcup/more/1990.txt
   worldcup/more/1994.txt
   worldcup/more/1998.txt
   worldcup/more/2002.txt
   worldcup/more/2006.txt
   worldcup/more/2010.txt
   worldcup/more/2014.txt
   worldcup/more/2018.txt
   worldcup/more/2022.txt   

###
#  check full too
   worldcup/more/1930_full.txt
   worldcup/more/1934_full.txt
   worldcup/more/1938_full.txt
   worldcup/more/1950_full.txt   
   worldcup/more/1954_full.txt
   worldcup/more/1958_full.txt
   worldcup/more/1962_full.txt
   worldcup/more/1966_full.txt
   worldcup/more/1970_full.txt
   worldcup/more/1974_full.txt
   worldcup/more/1978_full.txt
   worldcup/more/1982_full.txt
   worldcup/more/1986_full.txt
   worldcup/more/1990_full.txt
   worldcup/more/1994_full.txt
   worldcup/more/1998_full.txt
   worldcup/more/2002_full.txt
   worldcup/more/2006_full.txt
   worldcup/more/2010_full.txt
   worldcup/more/2014_full.txt
   worldcup/more/2018_full.txt
   worldcup/more/2022_full.txt   
TXT


WORLDCUP2MIN = parse_names( <<TXT )
   ###
   ## check samples in /min
   worldcup/min/1930.txt
   worldcup/min/1934.txt
   worldcup/min/1938.txt
   worldcup/min/1950.txt   
   worldcup/min/1954.txt
   worldcup/min/1958.txt
   worldcup/min/1962.txt
   worldcup/min/1966.txt
   worldcup/min/1970.txt
   worldcup/min/1974.txt
   worldcup/min/1978.txt
   worldcup/min/1982.txt
   worldcup/min/1986.txt
   worldcup/min/1990.txt
   worldcup/min/1994.txt
   worldcup/min/1998.txt
   worldcup/min/2002.txt
   worldcup/min/2006.txt
   worldcup/min/2010.txt
   worldcup/min/2014.txt
   worldcup/min/2018.txt
   worldcup/min/2022.txt   
TXT




WORLDCUP3 = parse_names( <<TXT )  
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


SPEC = parse_names( <<TXT )
    spec/samples/1960_euro_quali.txt
    spec/samples/2024-25_austria.txt
    spec/samples/2024_copa_libertadores.txt
    spec/samples/2024_euro.txt
    spec/samples/2025_club_worldcup.txt
TXT



if __FILE__ == $0

  args = ARGV

  if args.size == 0  
    args = DEFAULT 
  elsif args.size == 1 && (args[0] == 'worldcup' || args[0] == 'wc')
    args = WORLDCUP
  elsif args.size == 1 && (args[0] == 'worldcup2' || args[0] == 'wc2')
    args = WORLDCUP2
  elsif args.size == 1 && (['worldcup2min','wc2min', 'wc2m', 
                            'wcmin', 'wcm'].include?(args[0]))
    args = WORLDCUP2MIN
  elsif args.size == 1 && (args[0] == 'worldcup3' || args[0] == 'wc3')
    args = WORLDCUP3
  elsif args.size == 1 && args[0] == 'euro'
    args = EURO
  elsif args.size == 1 && (args[0] == 'austria' || args[0] == 'at')
    args = AUSTRIA
  elsif args.size == 1 && (args[0] == 'england' || args[0] == 'eng')
    args = ENGLAND
  elsif args.size == 1 && (args[0] == 'spec' || args[0] == 'specs')
    args = SPEC
  elsif args.size == 1 && args[0] == 'rsssf'
    args = RSSSF
  end

  fbtree( args )
  puts "bye" 
end