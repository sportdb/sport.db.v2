##
##  to run use:
##   $ ruby mkworldcup2.rb        (in /genjson)

require_relative 'helper'







config_history = [

  ['1930/worldcup.json', ['worldcup/1930--uruguay/cup.txt']],
  ['1934/worldcup.json', ['worldcup/1934--italy/cup.txt']],
  ['1938/worldcup.json', ['worldcup/1938--france/cup.txt']],

  ['1950/worldcup.json', ['worldcup/1950--brazil/cup.txt']],
  ['1954/worldcup.json', ['worldcup/1954--switzerland/cup.txt']],
  ['1958/worldcup.json', ['worldcup/1958--sweden/cup.txt']],
  ['1962/worldcup.json', ['worldcup/1962--chile/cup.txt']],
  ['1966/worldcup.json', ['worldcup/1966--england/cup.txt']],
  ['1970/worldcup.json', ['worldcup/1970--mexico/cup.txt']],
  ['1974/worldcup.json', ['worldcup/1974--west-germany/cup.txt']],
  ['1978/worldcup.json', ['worldcup/1978--argentina/cup.txt']],
  ['1982/worldcup.json', ['worldcup/1982--spain/cup.txt']],
  ['1986/worldcup.json', ['worldcup/1986--mexico/cup.txt', 'worldcup/1986--mexico/cup_finals.txt']],
  ['1990/worldcup.json', ['worldcup/1990--italy/cup.txt', 'worldcup/1990--italy/cup_finals.txt']],
  ['1994/worldcup.json', ['worldcup/1994--usa/cup.txt', 'worldcup/1994--usa/cup_finals.txt']],
  ['1998/worldcup.json', ['worldcup/1998--france/cup.txt', 'worldcup/1998--france/cup_finals.txt']],
  ['2002/worldcup.json', ['worldcup/2002--south-korea-n-japan/cup.txt', 'worldcup/2002--south-korea-n-japan/cup_finals.txt']],
  ['2006/worldcup.json', ['worldcup/2006--germany/cup.txt', 'worldcup/2006--germany/cup_finals.txt']],
  ['2010/worldcup.json', ['worldcup/2010--south-africa/cup.txt', 'worldcup/2010--south-africa/cup_finals.txt']],

  ['2014/worldcup.json', ['worldcup/2014--brazil/cup.txt', 'worldcup/2014--brazil/cup_finals.txt']],
  ['2018/worldcup.json', ['worldcup/2018--russia/cup.txt', 'worldcup/2018--russia/cup_finals.txt']],
  ['2022/worldcup.json', ['worldcup/2022--qatar/cup.txt', 'worldcup/2022--qatar/cup_finals.txt']],

  ['2026/worldcup.json',                ['worldcup/2026--usa/cup.txt',   'worldcup/2026--usa/cup_finals.txt']],
  ['2026/worldcup.quali_playoffs.json', ['worldcup/2026--usa/quali_playoffs.txt']],
]


config_more = [

 ## add/try full too
  ['more/1930-full.json',['worldcup/more/1930_full.txt']],
  ['more/1934-full.json',['worldcup/more/1934_full.txt']],
  ['more/1938-full.json',['worldcup/more/1938_full.txt']],
  ['more/1950-full.json',['worldcup/more/1950_full.txt']],
  ['more/1954-full.json',['worldcup/more/1954_full.txt']],
  ['more/1958-full.json',['worldcup/more/1958_full.txt']],
  ['more/1962-full.json',['worldcup/more/1962_full.txt']],
  ['more/1966-full.json',['worldcup/more/1966_full.txt']],
  ['more/1970-full.json',['worldcup/more/1970_full.txt']],
  ['more/1974-full.json',['worldcup/more/1974_full.txt']],
  ['more/1978-full.json',['worldcup/more/1978_full.txt']],
  ['more/1982-full.json',['worldcup/more/1982_full.txt']],
  ['more/1986-full.json',['worldcup/more/1986_full.txt']],
  ['more/1990-full.json',['worldcup/more/1990_full.txt']],
  ['more/1994-full.json',['worldcup/more/1994_full.txt']],
  ['more/1998-full.json',['worldcup/more/1998_full.txt']],
  ['more/2002-full.json',['worldcup/more/2002_full.txt']],
  ['more/2006-full.json',['worldcup/more/2006_full.txt']],
  ['more/2010-full.json',['worldcup/more/2010_full.txt']],
  ['more/2014-full.json',['worldcup/more/2014_full.txt']],
  ['more/2018-full.json',['worldcup/more/2018_full.txt']],
  ['more/2022-full.json',['worldcup/more/2022_full.txt']],
]




indir = OPENFOOTBALL_PATH
## outdir =   "#{OPENFOOTBALL_PATH}/worldcup.json"
outdir = './tmp-worldcup2'


config =
[
  ['1930/worldcup.json', ['worldcup/1930--uruguay/cup.txt']],

  ## add/try full versions
  ['1930/worldcup-full.json', ['worldcup/more/1930_full.txt']],
]


genjson( config, outdir: outdir,
                 indir: indir)


puts "bye"