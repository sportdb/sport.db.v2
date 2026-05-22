##
##  to run use:
##   $ ruby worldcup.rb        (in /genjson)

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
]


config_2026 = [
  ['2026/worldcup.json',                ['worldcup/2026--usa/cup.txt',   'worldcup/2026--usa/cup_finals.txt']],
  ['2026/worldcup.quali_playoffs.json', ['worldcup/2026--usa/quali_playoffs.txt']],
]


config_more = [
  ['more/1930.json',['worldcup/more/1930.txt']],
  ['more/1934.json',['worldcup/more/1934.txt']],
  ['more/1938.json',['worldcup/more/1938.txt']],
  ['more/1950.json',['worldcup/more/1950.txt']],   
  ['more/1954.json',['worldcup/more/1954.txt']],
  ['more/1958.json',['worldcup/more/1958.txt']],
  ['more/1962.json',['worldcup/more/1962.txt']],
  ['more/1966.json',['worldcup/more/1966.txt']],
  ['more/1970.json',['worldcup/more/1970.txt']],
  ['more/1974.json',['worldcup/more/1974.txt']],
  ['more/1978.json',['worldcup/more/1978.txt']],
  ['more/1982.json',['worldcup/more/1982.txt']],
  ['more/1986.json',['worldcup/more/1986.txt']],
  ['more/1990.json',['worldcup/more/1990.txt']],
  ['more/1994.json',['worldcup/more/1994.txt']],
  ['more/1998.json',['worldcup/more/1998.txt']],
  ['more/2002.json',['worldcup/more/2002.txt']],
  ['more/2006.json',['worldcup/more/2006.txt']],
  ['more/2010.json',['worldcup/more/2010.txt']],
  ['more/2014.json',['worldcup/more/2014.txt']],
  ['more/2018.json',['worldcup/more/2018.txt']],
  ['more/2022.json',['worldcup/more/2022.txt']],   

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


config_min = [
  ['min/1930.json',['worldcup/min/1930.txt']],
  ['min/1934.json',['worldcup/min/1934.txt']],
  ['min/1938.json',['worldcup/min/1938.txt']],
  ['min/1950.json',['worldcup/min/1950.txt']],   
  ['min/1954.json',['worldcup/min/1954.txt']],
  ['min/1958.json',['worldcup/min/1958.txt']],
  ['min/1962.json',['worldcup/min/1962.txt']],
  ['min/1966.json',['worldcup/min/1966.txt']],
  ['min/1970.json',['worldcup/min/1970.txt']],
  ['min/1974.json',['worldcup/min/1974.txt']],
  ['min/1978.json',['worldcup/min/1978.txt']],
  ['min/1982.json',['worldcup/min/1982.txt']],
  ['min/1986.json',['worldcup/min/1986.txt']],
  ['min/1990.json',['worldcup/min/1990.txt']],
  ['min/1994.json',['worldcup/min/1994.txt']],
  ['min/1998.json',['worldcup/min/1998.txt']],
  ['min/2002.json',['worldcup/min/2002.txt']],
  ['min/2006.json',['worldcup/min/2006.txt']],
  ['min/2010.json',['worldcup/min/2010.txt']],
  ['min/2014.json',['worldcup/min/2014.txt']],
  ['min/2018.json',['worldcup/min/2018.txt']],
  ['min/2022.json',['worldcup/min/2022.txt']],   
]



config_rsssf = [
   ['rsssf/30full.json', ['worldcup/rsssf/30full.txt']],
   ['rsssf/34f.json',    ['worldcup/rsssf/34f.txt']],
   ['rsssf/38f.json',    ['worldcup/rsssf/38f.txt']],
    ['rsssf/2014f.json',  ['worldcup/rsssf/2014f.txt']],
    ['rsssf/2022f.json',  ['worldcup/rsssf/2022f.txt']],

    ## ['rsssf/2022q.json',  ['worldcup/rsssf/2022q.txt']],
    ## !! (QUICK) PARSE ERROR - no season found in Heading1 >World Cup Qualifying; sorry
]

config_rsssf_fix = [
 ['rsssf/worldcup.json',  ['worldcup/rsssf/worldcup.txt']],
  ## ! (QUICK) PARSE ERROR - no season found in Heading1 >World Cup Finals; sorry 
]


indir = OPENFOOTBALL_PATH
## outdir =   "#{OPENFOOTBALL_PATH}/worldcup.json"   
outdir = './tmp-worldcup'

config = config_rsssf


genjson( config, outdir: outdir, 
                 indir: indir)


puts "bye"