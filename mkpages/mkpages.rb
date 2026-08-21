############
#  to run use:
#   $ ruby mkpages/mkpages.rb

##
###  generate web site
##      - web pages in .html from .txt



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
require 'fbtxt/document'


$LOAD_PATH.unshift( "#{File.dirname(__dir__)}/fbtok/lib" )
require 'fbtok'   ### pulls-in  Fbtxt::Pathspec.find()




require_relative 'mkpages/page'

require_relative 'mkpages/build_page'
require_relative 'mkpages/build_index'
require_relative 'mkpages/build_site'


=begin
require_relative 'mkpages/build_codes'
require_relative 'mkpages/build_updates'
require_relative 'mkpages/build_links'
require_relative 'mkpages/meta'      ## parse_meta  --in html-style comment header


require_relative 'mkpages/page_toc'     ## table of contents (toc)
=end

require_relative 'mkpages/page_banner'
require_relative 'mkpages/page_layout'   ## aka master page layout/template
require_relative 'mkpages/page_style'



require_relative 'mkpages/main'




Pages.main     ### auto-start main for now - why? why not?


puts "bye"
