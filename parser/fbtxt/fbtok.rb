####
#  to run use:
#    $ ruby ./fbtok.rb         (in /fbtxt)

$LOAD_PATH.unshift( '../lib' )
require 'sportdb/parser'




##
## note - use File.file? instead of File.exist? 
##            (checks if file exists AND file is a file NOT a directory)


def find_file( name, path: )
    return name    if File.file?( name )

    path.each do |dir|
        filepath = File.join( dir, name )
        return filepath   if File.file?(  filepath )
    end

    puts "!! ERROR - file <#{name}> not found; looking in path: #{path.inspect}"
    exit 1
end



PATH = [
   '../fbtxt-samples',
   '../fbtxt-rsssf',
   '../../../../openfootball', 
]


def fbtok( args, path: PATH )
   log = []

   args.each_with_index do |name,i|
      puts "==> #{i+1}/#{args.size} #{name}..."

      filename = find_file( name, path: path )

      txt = read_text( filename )

     
     lexer = SportDb::Lexer.new( txt, debug: true )
     tokens, errors = lexer.tokenize_with_errors
     pp tokens

     if errors.size > 0
       puts "!! #{errors.size} tokenize error(s):"
       pp errors
    
      log << [filename, "!! - #{errors.size} tokenize error(s)", errors]
      else
       puts "--  OK - no tokenize errors found"
 
       log << [filename, "OK"]
     end
   end


   puts
   puts "log - #{log.size} file(s):"
   pp log
end



if __FILE__ == $0

  args = ARGV
  fbtok( args )
  puts "bye" 
end