####
#  to run use:
#    $ ruby fmtfix/fbi2ii.rb

#  (try to) convert v1 (i) to v2 (ii) format



require 'cocos'
require 'fbtok'   ## use/pull-in   SportDb::Pathspec._find



## our own code
require_relative 'fmtfix/fmtfix'
require_relative 'fmtfix/fix-rounds'
require_relative 'fmtfix/fix-dates'







def fbi2ii( filename, edit: false, ts: )
      txt = read_text( filename )

      newtxt = fmtfix( txt )

      ## check if any changes
      if newtxt != txt
        dirname  = File.dirname( filename )
        basename = File.basename( filename, File.extname( filename ) )
        extname  = File.extname( filename )

        if edit  ## edit inplace
          backupfile = File.join(  dirname, "#{basename}.v#{ts}#{extname}" )
          write_text( backupfile, txt )

          ########################
          ## !!!! DANGER !!!!! - overwrite original inplace with (new) text
          ################
          write_text( filename, newtxt )
        else
          ## change outfile  - add .v2
          ##   note extname (already) starts with dot (.) e.g. .txt
          outfile = File.join(  dirname, "#{basename}.v2#{extname}" )
          write_text( outfile, newtxt)
        end
      else
        puts "  - no changes in file #{filename} -"
      end
end





PATH = [
   '/sports/openfootball',
]



args = ARGV


###
## check for command line options

  opts = {
      edit:  false,    ## edit (sub/change/remove) inplace
  }

parser = OptionParser.new do |parser|
  parser.banner = "Usage: #{$PROGRAM_NAME} [options] DATAFILES and/or DIRS"


  parser.on( "-e", "--edit",
             "edit files inplace (default: #{opts[:edit]})" ) do |edit|
    opts[:edit] = true
  end
end
parser.parse!( args )


  puts "OPTS:"
  p opts
  puts "ARGV:"
  p args


   ##
   # edit inplace extension
   #   use ts (timestamp - vyyyymmdd_hhmmss)
   #    note - use %y last two digits only (e.g. 2026 => 26)
   #     e.g.  "260318_140916"
   ##
   #  note - use same ts for all files passed in via args (kind of a changeset/batch)
    ts = Time.now.utc.strftime("%y%m%d_%H%M%S")


   log = []



   args.each_with_index do |name,i|
      puts "==> #{i+1}/#{args.size} #{name}..."

     if Dir.exist?( name )
        datafiles = SportDb::Pathspec._find( name )
        pp datafiles
        datafiles.each_with_index do |filename, j|
           puts "==> #{i+1}/#{args.size} #{j+1}/#{datafiles.size} #{filename}..."
            fbi2ii( filename, edit: opts[:edit], ts: ts )
        end
      else
        filename = find_file!( name, path: PATH )
        fbi2ii( filename, edit: opts[:edit], ts: ts )
      end
   end



puts "bye"
