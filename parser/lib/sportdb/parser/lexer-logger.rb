
module SportDb
class Lexer


###
##  fix-fix-fix
##   change @debug to  @@debug classs static variable  - why? why not?

def debug?()  @debug == true; end



def log( msg )
   ## append msg to ./logs.txt
   ##     use ./errors.txt - why? why not?
   ##
   ##  change to ./logs_lexer.txt or such - why? why not?
   ##    auto-add/prepend  [Lexer] and timestamp!!!  to msg - why? why not?
   File.open( './logs.txt', 'a:utf-8' ) do |f|
     f.write( msg )
     f.write( "\n" )
   end
end


def _trace( *args )    ## aka debug level logging
  if debug?
    print "[DEBUG] Lexer -- "
    args.each { |arg| puts args }
  end
end

def _warn( *args )
  print "!! [WARN] Lexer -- "
  args.each { |arg| puts args }
end

def _info( *args )
  print "[INFO] Lexer -- "
  args.each { |arg| puts args }
end



end   # class Lexer
end   # module SportDb
