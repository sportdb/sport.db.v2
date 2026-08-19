############
#  to run use:
#    $ ruby mkpages/mkworldcup.rb



ARGV = [
  '--baseurl=https://github.com/openfootball/worldcup',
  '--rootdir=/sports/openfootball/worldcup',
  '--outdir=./_site/worldcup',
]


require_relative 'mkpages'



puts "bye"