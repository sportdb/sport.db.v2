####
#  to run use:
#    $ ruby ./fbi2ii.rb         (in /fbtxt)

#  (try to) convert v1 (i) to v2 (ii) format


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


###  16.00 => 16:00
##     todo/check - use space for positive lookbehind & ahead
##                      (instead of \b) - why? why not?
##  note - check for/exclude 12.12.  date in match
##             use negative lookahead
TIME_RE = %r{  \b
                   (\d{1,2})
                      \.
                  (\d{2})
                    \b
                 (?! [.] )   ## do NOT match 12.12.  
            }ix
TIME_REPLACE = '\1:\2'

DATE_WDAY_MMM_DD_RE = %r{ \[
                           (Mon|Tue|Wed|Thu|Fri|Sat|Sun)
                            [ ]+
                           (Jan|
                            Feb|
                            March|Mar|
                            April|Apr|
                            May|
                            June|Jun|
                            July|Jul|
                            Aug|
                            Sept|Sep|
                            Oct|
                            Nov|
                            Dec)
                            /
                           (\d{1,2})       
                        \] 
            }ix
DATE_WDAY_MMM_DD_REPLACE = '\1 \2 \3'            



def autofix( txt )

   ##  16.00  =>  16:00
   txt = txt.gsub( TIME_RE, TIME_REPLACE )

   ##  [Sat Sep/12]  =>  Sat Sep 12
   txt = txt.gsub( DATE_WDAY_MMM_DD_RE, DATE_WDAY_MMM_DD_REPLACE )
  

###
##
##
   rounds_re = %r{
      ^
        ## ignore leading spaces
          [ ]*
         (
            Matchday [ ] \d{1,2}  
             ## note - last entry MUST NOT HAVE a pipe (|)
         )
        ## ignore trailing spaces   
         [ ]*  
      $
   }ix

   txt = txt.gsub( rounds_re, '▪ \1') 
   

  txt
end



def fbi2ii( args, path: PATH )
   log = []

   args.each_with_index do |name,i|
      puts "==> #{i+1}/#{args.size} #{name}..."

      filename = find_file( name, path: path )

      txt = read_text( filename )

      dirname  = File.dirname( filename )
      basename = File.basename( filename, File.extname( filename ) )
      extname  = File.extname( filename )

      ## change outfile  - add .v2
      outfile = File.join(  dirname, "#{basename}.v2.#{extname}" )
      
      newtxt = autofix( txt )

      write_text( outfile, newtxt )
   end
end


if __FILE__ == $0

  args = ARGV


  fbi2ii( args )
  puts "bye" 
end