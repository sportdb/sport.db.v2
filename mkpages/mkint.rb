############
#  to run use:
#    $ ruby mkpages/mkint.rb


ARGV = [
  '--repo=openfootball/internationals',
  '--rootdir=/sports/openfootball/internationals',
  '--outdir=./_site/internationals'
]


require_relative 'mkpages'


puts "bye"