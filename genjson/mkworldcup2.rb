##
##  to run use:
##   $ ruby mkworldcup2.rb        (in /genjson)

require_relative 'helper'



indir = OPENFOOTBALL_PATH


### note - use a command-line switch/arg to toggle outdir!!
args = ARGV
outdir =  if args[0] && ['u', 'up', '-u', '--up'].include?( args[0].downcase )
              "#{OPENFOOTBALL_PATH}/worldcup.json"
           else
             './tmp-worldcup3'
           end


config =
[
  ['1930/worldcup.json', ['worldcup/1930--uruguay/cup.txt']],
  ['1934/worldcup.json', ['worldcup/1934--italy/cup.txt']],
  ['1938/worldcup.json', ['worldcup/1938--france/cup.txt']],

  ['1950/worldcup.json', ['worldcup/1950--brazil/cup.txt']],
  ['1954/worldcup.json', ['worldcup/1954--switzerland/cup.txt']],
  ['1958/worldcup.json', ['worldcup/1958--sweden/cup.txt']],
  ['1962/worldcup.json', ['worldcup/1962--chile/cup.txt']],
  ['1966/worldcup.json', ['worldcup/1966--england/cup.txt']],
  ['1970/worldcup.json', ['worldcup/1970--mexico/cup.txt']],
  ['1974/worldcup.json', ['worldcup/1974--west_germany/cup.txt']],
  ['1978/worldcup.json', ['worldcup/1978--argentina/cup.txt']],
  ['1982/worldcup.json', ['worldcup/1982--spain/cup.txt']],
  ['1986/worldcup.json', ['worldcup/1986--mexico/cup.txt', 'worldcup/1986--mexico/cup_finals.txt']],
  ['1990/worldcup.json', ['worldcup/1990--italy/cup.txt', 'worldcup/1990--italy/cup_finals.txt']],
  ['1994/worldcup.json', ['worldcup/1994--usa/cup.txt', 'worldcup/1994--usa/cup_finals.txt']],
  ['1998/worldcup.json', ['worldcup/1998--france/cup.txt', 'worldcup/1998--france/cup_finals.txt']],
  ['2002/worldcup.json', ['worldcup/2002--south_korea-n-japan/cup.txt', 'worldcup/2002--south_korea-n-japan/cup_finals.txt']],
  ['2006/worldcup.json', ['worldcup/2006--germany/cup.txt', 'worldcup/2006--germany/cup_finals.txt']],
  ['2010/worldcup.json', ['worldcup/2010--south_africa/cup.txt', 'worldcup/2010--south_africa/cup_finals.txt']],

  ['2014/worldcup.json', ['worldcup/2014--brazil/cup.txt', 'worldcup/2014--brazil/cup_finals.txt']],
  ['2018/worldcup.json', ['worldcup/2018--russia/cup.txt', 'worldcup/2018--russia/cup_finals.txt']],

  ['2022/worldcup.json',  ['worldcup/2022--qatar/cup.txt', 'worldcup/2022--qatar/cup_finals.txt']],
  ['2026/worldcup.json',  ['worldcup/2026--canada-usa-mexico/cup.txt',   'worldcup/2026--canada-usa-mexico/cup_finals.txt']],

  #########
  ## bonus - add quali
  ['2026/worldcup.quali_playoffs.json', ['worldcup/2026--canada-usa-mexico/quali_playoffs.txt']],

  ###########
  ## add/try full versions
  ['1930/worldcup-full.json',['worldcup/more/1930_full.txt']],
  ['1934/worldcup-full.json',['worldcup/more/1934_full.txt']],
  ['1938/worldcup-full.json',['worldcup/more/1938_full.txt']],
  ['1950/worldcup-full.json',['worldcup/more/1950_full.txt']],
  ['1954/worldcup-full.json',['worldcup/more/1954_full.txt']],
  ['1958/worldcup-full.json',['worldcup/more/1958_full.txt']],
  ['1962/worldcup-full.json',['worldcup/more/1962_full.txt']],
  ['1966/worldcup-full.json',['worldcup/more/1966_full.txt']],
  ['1970/worldcup-full.json',['worldcup/more/1970_full.txt']],
  ['1974/worldcup-full.json',['worldcup/more/1974_full.txt']],
  ['1978/worldcup-full.json',['worldcup/more/1978_full.txt']],
  ['1982/worldcup-full.json',['worldcup/more/1982_full.txt']],
  ['1986/worldcup-full.json',['worldcup/more/1986_full.txt']],
  ['1990/worldcup-full.json',['worldcup/more/1990_full.txt']],
  ['1994/worldcup-full.json',['worldcup/more/1994_full.txt']],
  ['1998/worldcup-full.json',['worldcup/more/1998_full.txt']],
  ['2002/worldcup-full.json',['worldcup/more/2002_full.txt']],
  ['2006/worldcup-full.json',['worldcup/more/2006_full.txt']],
  ['2010/worldcup-full.json',['worldcup/more/2010_full.txt']],
  ['2014/worldcup-full.json',['worldcup/more/2014_full.txt']],
  ['2018/worldcup-full.json',['worldcup/more/2018_full.txt']],
  ['2022/worldcup-full.json', ['worldcup/more/2022_full.txt']],
  ['2026/worldcup-full.json', ['worldcup/more/2026_full.txt']],
]


##
## todo/check
##   use
##    Export do |config|
##        config.outdir =
##        config.indir  =
##    end
##  -or-
##   Export.outdir =
##   Export.indir  =     -- why? why not?


Fbtxt::Export.genjson( config, outdir: outdir,
                               indir: indir)


puts "bye"