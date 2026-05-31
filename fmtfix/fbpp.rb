####
#  to run use:
#    $ ruby ./fbpp.rb         (in /fbtxt)

#  (try to) pretty print (pp)  


require 'cocos'


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
   '../fbtxt-v0',
]



## add pretty print date
##   - auto-add wday (Mon,Tue, etc.)
##   -   change date format from  9 Aug to Aug 9
##   -   must check / have  year in heading first (e.g.  =World Cup 2018=  ) !!
##   -  only check for date (starting line) !!



def autofix( txt )

   
  txt
end



def fbpp( args, path: PATH )
   log = []

   args.each_with_index do |name,i|
      puts "==> #{i+1}/#{args.size} #{name}..."

      filename = find_file( name, path: path )

      txt = read_text( filename )

      dirname  = File.dirname( filename )
      basename = File.basename( filename, File.extname( filename ) )
      extname  = File.extname( filename )

      ## change outfile  - add .pp
      ##   note extname (already) starts with dot (.) e.g. .txt
      outfile = File.join(  dirname, "#{basename}.pp#{extname}" )
      
      newtxt = autofix( txt )

      write_text( outfile, newtxt )
   end
end


if __FILE__ == $0

  args = ARGV


  fbpp( args )
  puts "bye" 
end