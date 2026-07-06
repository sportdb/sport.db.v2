## "generic" outline readers, documents & more
##
##  todo/check - move outline reader upstream to cocos - why? why not?
##       use  read_outline(), parse_outline()  - why? why not?
require_relative 'quick/outline_reader'
require_relative 'quick/outline'

require_relative 'quick/quick_league_outline'


require 'logutils'
module SportDb
   ## logging machinery shortcut; use LogUtils for now
  Logging = LogUtils::Logging
end
