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
                           (?:    ## optional weekday
                              (?<wday>
                                  Mon|Mo|
                                  Tue|Tu|
                                  Wed|We|
                                  Thu|Th|
                                  Fri|Fr|
                                  Sat|Sa|
                                  Sun|Su)
                              [ ]+
                            )?
                           (?<month>
                               Jan|
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
                             [/ ]     ## allow space ( ) or slash (/)
                           (?<day> \d{1,2})       
                        \] 
            }ix
            

DATE_MMM_DD_RE = %r{     \b
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
                           \b                               
            }ix

DATE_MMM_DD_REPLACE = '\1 \2'            




##
## todo/fix - add more round / matchday options!!!


## note use q (downcase) for no-escapes in string (e.g. \d vs \\d etc)
GROUPS = %q{(?:
              Group [ ] [A-Z1-9]
 
              ## note - last entry MUST NOT HAVE a pipe (|)
              ##       make sure to use [ ] for space!!
            )}

ROUNDS = %q{(?:
              Matchday [ ] \d{1,2}  
               | 
              Group [ ] [A-Z1-9] [ ] play-?off
                |
              First [ ] phase    |
              Second [ ] round           
                |
              Round [ ] of [ ] (?: 8 | 16 | 32 )
               |
              1/8 [ ] finals
               |
              Quarter-?finals? 
               |
              Semi-?finals?
               |
              Third [ -] place [ ] (?: match | play-?off ) |
              Match [ ] for [ ] third [ ] place 
               |
              Finals?

              ## note - last entry MUST NOT HAVE a pipe (|)
              ##       make sure to use [ ] for space!!
         )}


  ROUND_MARKER_RE =

def autofix( txt )

   ## convert "old" legacy round markers (») 
   txt = txt.gsub( %r{^ [ ]*
                          »
                        (?= [ ]+)  ## require one trailing space for now!!
                        }ix,   
                        '▪' )


   rounds_re = %r{
      ^
           [ ]*   ## ignore leading spaces
             (#{ROUNDS} | #{GROUPS})
       
           ## check POSITIVE lookahead
            (?= 
               [ ]*  ## ignore trailing spaces
                (?:
                  \#+ [^\r\n]+?    ## ignore optional inline-comment
                 )?
                 $
            )
   }ix

   txt = txt.gsub( rounds_re, '▪ \1') 


##
##  e.g.
##    Matchday 1 | ...
##    etc. 
##   note - do NOT include GROUPS e.g. Group A, Group 1, etc.
   round_defs_re = %r{
      ^
        [ ]* ## ignore leading spaces
          (#{ROUNDS})           
         
          ## check POSITIVE lookahead
         (?= 
             [ ]*  ## ignore trailing spaces 
              \|  
         )
   }ix

      txt = txt.gsub( round_defs_re, '▪ \1') 



   ##  16.00  =>  16:00
   txt = txt.gsub( TIME_RE, TIME_REPLACE )

   ##  [Sat Sep/12]  =>  Sat Sep 12
   ##  [Sat Sep 12]  =>  Sat Sep 12 
   ##  [Sep/12]      =>  Sep 12
   ##  [Sep 12]      =>  Sep 12
   txt = txt.gsub( DATE_WDAY_MMM_DD_RE ) do |_|
               ## note - sub passes in string (!) NOT matchdata in arg (_)
               m = $~   ## is $LAST_MATCH_DATA
     
               if m[:wday]
                  "#{m[:wday]} #{m[:month]} #{m[:day]}"
               else
                   "#{m[:month]} #{m[:day]}"
               end
           end 

  ## Sep/12   =>  Sep 12
  txt = txt.gsub( DATE_MMM_DD_RE, DATE_MMM_DD_REPLACE )

   
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
      ##   note extname (already) starts with dot (.) e.g. .txt
      outfile = File.join(  dirname, "#{basename}.v2#{extname}" )
      
      newtxt = autofix( txt )

      write_text( outfile, newtxt )
   end
end


if __FILE__ == $0

  args = ARGV


  fbi2ii( args )
  puts "bye" 
end