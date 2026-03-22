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


def parse_names( txt )
   names = []
   txt.each_line do |line|
       line = line.strip
       next if line.empty? || line.start_with?('#')

       names << line
   end
   names
end
