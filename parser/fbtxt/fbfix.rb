####
#  to run use:
#    $ ruby ./fbfix.rb         (in /fbtxt)


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
   '../fbtxt-fix',
]



A_NAME_RE = %r{
              <a
                [ ]+
                name
                [ ]*=[ ]*
                   "[^"]+?"    ## string
                [ ]*
               >}ix


##
##  3:2 (1:0)   => 3-1 (1-0)

SCORE_DE_RE = %r{  \b 
                    (\d{1,2}) : (\d{1,2}) 
                   \b  
                 }ix
SCORE_DE_REPLACE =  '\1-\2'             


##
##  (16.00)   => 16:00
TIME_DE_RE =  %r{   \( (\d{1,2})
                          .\
                       (\d{2})  \)  
                }ix
TIME_DE_REPLACE = '\1:\2'



##
##  47+   =>  45+2
##  47'+  =>  45'+2
##  123+  =>  120+3
MINUTE_RE = %r{
                  \b
                    (?<value>\d{1,3})
                    (?<marker>')?
                    \+
                    ## negative lookahead - no number e.g. 42+3
                    (?! [0-9])
               }ix



def autofix( txt )

## html entities
  html_entities = [
    ['&ntilde;', 'ñ'], 
    ['&nitlde;', 'ñ'],   ## support typo variant of &ntilde;
   ['&atilde;', 'ã'],
   ['&aelig;',  'æ'],
   ['&oslash;',  'ø'],
   ['&ouml;',    'ö'],
   ['&Ouml;',    'Ö'],
   ['&uuml;',    'ü']
  ]


  html_entities.each do |find, replace|
    txt = txt.gsub( find, replace )
  end

   


  html_tags = [
      [ %r{<h1>}i, '=' ],   [%r{</h1>}i, '' ],
      [ %r{<h2>}i, '==' ],  [%r{</h2>}i, '' ],
      [ %r{<hr>}i, '---' ], 
      [ %r{<b>}i, '' ], [ %r{</b>}i, '' ],   ## remove enclosing b(old)
      [ %r{<pre>}i, '' ],
      [ %r{<p>}i, '' ],
      [ A_NAME_RE, '' ],    ## remove anchors e.g. <a name="">
  ]

  html_tags.each do |find, replace|
    txt = txt.gsub( find, replace )
  end


  ###########
  ##  score & friends

  ### 1:0 (0:0)  =>  1-0 (0-0)
  txt = txt.gsub( SCORE_DE_RE, SCORE_DE_REPLACE )
  ###  [aet]  => (aet)
  txt = txt.gsub( '[aet]', '(aet)' )
 
  ####################
  ### date & time
  ##  15- 6-14   =>  15/6/14 
  txt = txt.gsub( %r{\b
                          (\d{1,2}) - [ ]*
                          (\d{1,2}) -
                          (\d{2})
                      \b
  }ix,  '\1/\2/\3')

  

  ##  (16.00)   => 16:00
  txt = txt.gsub( TIME_DE_RE, TIME_DE_REPLACE )
  

   ## (c)  => [c]   captain in line-up
   ## (c - ...) => [c] (
   ##    e.g. (c - 58 Völler)  => [c] (58 Völler)
   ##         (c - 46 Futre)   => [c] (46 Futre)

   txt = txt.gsub( '(c)', '[c]')
   txt = txt.gsub( '(c - ', '[c] (')


  ## todo/check - auto-add word boundary (\b) - why? why not?
  ## use command-line flag e.g.  cities = mx (mexico), br (brazil)
  ##   todo/fix: split into cities_mx, cities_br, etc.
  cities_re = 
     %r{ 
           ## check positive lookbehind
           ##    note - only works with FIXED WIDTH PATTERNS!!
           ##    (simple) time 16:00
           ##    or date
             (?<= 
                            \d [ ] |
                            \d [ ]{2}
      ##         (?:  
      ##          (?: \b \d{1,2}:\d{2} [ ]+ )
      ##              |   
      ##           (?: \b \d{1,2}/\d{1,2}/\d{2} [ ]+ )
      ##          )
              )
          \b
          (?<city>
            ## mx (mexico)
            Nezahualcoyotl  |
            Queretaro       |
            Guadalajara     | 
            Monterrey       | 
            Mexico [ ] City |
            Leon            | León  |         
            Puebla          | 
            Toluca          |
            Irapuato        |

            ### br (brazil)
             São [ ] Paulo  |
             Natal          |
             Fortaleza      |
             Manaus         |
             Brasília       | 
             Recife         |
             Salvador       |
             Cuiabá         |
             Porto [ ] Alegre        |
             Rio [ ] de [ ] Janeiro  |
             Curitiba                |
             Belo [ ] Horizonte       ## note - last entry MUST not have a pipe (|)!!
          )
          \b
          ## check optional trailing spaces
          (?<spaces> [ ]* )?
      }ix


# note-  use sub only - replace only 1st match - max. one per line!!
##  e.g.  fix for
##    Leon, Estadio Sergio Leon         =>  @ Leon, Estadio Sergio Leon
##     Irapuato, Estadio Irapuato       =>  @ Irapuato, Estadio Irapuato
##
##  note - make sure geo is separated by two spaces, thus, add extra space at the end on replace!!!
##    e.g.     15/6/14 @ Rio de Janeiro  Argentina     2-1 Bosnia-Herzegovina
##             21/6/14 @ Belo Horizonte  Argentina     1-0 Iran
##
   newtxt = "" 
   txt.each_line do |line|  
      newtxt << line.sub( cities_re ) do |_|
           ## note - sub passes in string (!) NOT matchdata in arg (_)
           m = $~   ## is $LAST_MATCH_DATA
           
           spaces = m[:spaces]   ## note - m[:spaces] is empty "" if no match!!!
           spaces = '  ' if spaces.length == 1
           
           "@ #{m[:city]}#{spaces}"
      end
   end
   txt = newtxt


   txt = txt.gsub( MINUTE_RE ) do |_|
           ## note - sub passes in string (!) NOT matchdata in arg (_)
           m = $~   ## is $LAST_MATCH_DATA
           value = m[:value].to_i(10)

           values =    if value < 90        # assume 1st half (45+xx)
                           [45, value - 45]
                       elsif value < 105    # assume 2nd half (90+xx)
                           [90, value - 90]
                       elsif value < 120    # assume extra time, 1nd half (105+xx)
                           [105, value - 105]
                       else                 # assume extra time, 2nd half (120+xx)
                           [120, value - 120]
                       end

            "#{values[0]}#{m[:marker]}+#{values[1]}"            
        end  


###
##
##
   rounds_re = %r{
      ^
        ## ignore leading
           =* [ ]*
         (
           First [ ] phase            |
           Second [ ] round           |
           Group [ ] [a-h]            |
           1/8 [ ] finals             |
           Quarter-?finals            |
           Semi-?finals               |
           Third [ ] place [ ] match  |
           Final        ## note - last entry MUST NOT HAVE a pipe (|)
         )
        ## ignore trailing   
         [ ]*  
      $
   }ix


   txt = txt.gsub( rounds_re, '▪ \1') 
   

  txt
end



def fbfix( args, path: PATH )
   log = []

   args.each_with_index do |name,i|
      puts "==> #{i+1}/#{args.size} #{name}..."

      filename = find_file( name, path: path )

      txt = read_text( filename )

      dirname  = File.dirname( filename )
      basename = File.basename( filename, File.extname( filename ) )
      extname  = File.extname( filename )

      ## change outfile  - add .autofix
      outfile = File.join(  dirname, "#{basename}.fixme#{extname}" )
      

      newtxt = autofix( txt )

      write_text( outfile, newtxt )
   end
end


if __FILE__ == $0

  args = ARGV


  fbfix( args )
  puts "bye" 
end