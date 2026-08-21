############
#  to run use:
#    $ ruby mkpages/mkat.rb


##
## note:  get github repo via env (in github action setting) e.g.
##    GITHUB_REPOSITORY=openfootball/england
##   later add branch too (might be master/main or other)!!!
##
##  GITHUB_REF_TYPE=branch   &&
##  GITHUB_REF_NAME=master
##    check if branch is available "standalone" ??

ARGV = [
 ## '--baseurl=https://github.com/openfootball/austria',
  '--repo=openfootball/austria',
  '--rootdir=/sports/openfootball/austria',
  '--outdir=./_site/austria'
]


require_relative 'mkpages'


puts "bye"