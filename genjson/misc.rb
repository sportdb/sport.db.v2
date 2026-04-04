##
##  to run use:
##   $ ruby genjson.rb        (in /genjson)

require_relative 'helper'




indir = OPENFOOTBALL_PATH
## outdir =   "#{OPENFOOTBALL_PATH}/worldcup.json"   
## outdir =   "#{OPENFOOTBALL_PATH}/euro.json"   
outdir = './tmp-misc'


config = [
  ['2020/euro.json', ['euro/2021--europe/euro.txt']],
  ['2024/euro.json', ['euro/2024--germany/euro.txt']],    
  ['2028/euro.json', ['euro/2028--united_kingdom-ireland/euro.txt']],    
]


config = [
  ['2025/clubworldcup.json', ['club-worldcup/2025/clubworldcup.txt']],
]




genjson( config,   indir: indir, 
                   outdir: outdir)


puts "bye"