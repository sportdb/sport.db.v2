############
#  to run use:
#    $ ruby mkpages/mkeng.rb

#
# same as:
#   $  ruby mkpages/mkpages.rb --outdir=./_site/england --rootdir=/sports/openfootball/england --baseurl=https://github.com/openfootball/england


ARGV = [
  '--rootdir=/sports/openfootball/england',
  '--outdir=./_site/england',
  '--repo=openfootball/england',
]


require_relative 'mkpages'



puts "bye"