#######
# test search (struct convenience) helpers/methods
#
#  use
#    $ ruby sandbox/test_samples.rb
#
#  fix-fix-fix
##   - [ ] add new fbdoc upstream
##            with --json/-j flag for as_json output
##               add flag for dump
##                 --dump ?? /--pp (prettyprint) -x or ???


require_relative 'helper'



SAMPLES_PATH = './samples'

path =  "#{SAMPLES_PATH}/worldcup_2022_final.txt"

doc = Fbtxt::Document.read( path )

puts
puts "  try json for matches:"
data = doc.matches.map {|match| match.as_json }
pp data


puts
puts "---"
pp doc



puts "bye"