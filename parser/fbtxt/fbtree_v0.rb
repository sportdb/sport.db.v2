####
#  to run use:
#    $ ruby ./fbtree_v0.rb         (in /fbtxt)

require_relative 'helper'


PATH = [
   '../fbtxt-specs',
   '../fbtxt-samples',
   '../fbtxt-rsssf',
   '../../../../openfootball',
]


def fbtree( args, path: PATH )
   log = []

   args.each_with_index do |name,i|
      puts "==> #{i+1}/#{args.size} #{name}..."

      filename = find_file!( name, path: path )

      txt = read_text( filename )
      ## txt = read_blocktxt( filename ).text

      parser = RaccMatchParser.new( txt, debug: true )
      tree = parser.parse
      pp tree

      if parser.errors?
        puts "-- #{parser.errors.size} parse error(s):"
        pp parser.errors

        log << [filename, "!! - #{parser.errors.size} parse error(s)", parser.errors]
      else
        puts "--  OK - no parse errors found"

        log << [filename, "OK"]
      end
   end


   puts
   puts "log - #{log.size} file(s):"
   pp log
end





if __FILE__ == $0


  filepack = read_filepack( "./filepack.txt" )

  args = ARGV


  if args.size == 0 && filepack.has_key?( 'default' )
    args = filepack[ 'default' ]
  elsif args.size == 1 && filepack.has_key?( args[0] )
    args = filepack[ args[0] ]
  elsif args.size == 1 && File.directory?( args[0] )
    ### special case - check fo directory
    ##   - get all .txt files with glob search
    glob = "#{args[0]}/**/*.txt"
    files = Dir.glob( glob )
    puts "   #{files.size} .txt datafile(s) found using glob >#{glob}<"

    args = files
  end

  fbtree( args )
  puts "bye"
end