##
##  to run use:
##   $ ruby mkworldcup2026.rb        (in /genjson)

require_relative 'helper'




config_2026 = [
  ['2026/worldcup.json',                ['worldcup/2026--usa/cup.txt',   'worldcup/2026--usa/cup_finals.txt']],
  ['2026/worldcup.quali_playoffs.json', ['worldcup/2026--usa/quali_playoffs.txt']],
]


indir = OPENFOOTBALL_PATH
outdir =   "#{OPENFOOTBALL_PATH}/worldcup.json"
## outdir = './tmp-worldcup'

config = config_2026


genjson( config, outdir: outdir,
                 indir: indir)


puts "bye"