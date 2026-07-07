
module Fbtxt
class Lexer


def log( msg )
   ## append msg to ./logs.txt
   ##     use ./errors.txt - why? why not?
   ##
   ##  change to ./logs_lexer.txt or such - why? why not?
   ##    auto-add/prepend  [Lexer] and timestamp!!!  to msg - why? why not?
   File.open( './logs.txt', 'a:utf-8' ) do |f|
     f.write( "[Lexer] " + msg )
     f.write( "\n" )
   end
end


end   # class Lexer
end   # module Fbtxt
