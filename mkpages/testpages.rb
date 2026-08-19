############
#  to run use:
#   $ ruby mkpages/testpages.rb


##
##  check for gem setup
##    script should load local gem versions !!!


require 'cocos'

require 'pathname'
## auto-add upstream in cocos - why? why not?
##      (for use of  Pathname#relative_path_to)


#  quick hack - always auto-add latest lexer if present for now
#    note - instead  of ../   use absolute path with
#                 File.dirname(__dir__)

$LOAD_PATH.unshift( "#{File.dirname(__dir__)}/lexer/lib" )
$LOAD_PATH.unshift( "#{File.dirname(__dir__)}/parser/lib" )
$LOAD_PATH.unshift( "#{File.dirname(__dir__)}/document/lib" )

puts "--> load path:"
pp $LOAD_PATH

puts "--> before  require fbtxt/document"
require 'fbtxt/document'
puts "--> after  require fbtxt/document"



require 'fbtok'   ### pulls-in  Fbtxt::Pathspec.find()


puts "bye"
