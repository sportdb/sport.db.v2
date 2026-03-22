####
#  to run use:
#    $ ruby ./fbtok.rb         (in /fbtxt)

require_relative 'helper'




PATH = [
   '../fbtxt-samples',
   '../fbtxt-rsssf',
   '../../../../openfootball', 
]


WORLD_MORE = parse_names( <<TXT ) 
  world.more/2023-24/de.1.txt
  world.more/2023-24/at.1.txt
TXT





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

  if args.size == 1 && (args[0] == 'world.more' || args[0] == 'worldmore' || args[0] == 'more')
    args = WORLD_MORE
  end

  fbtok( args )
  puts "bye" 
end