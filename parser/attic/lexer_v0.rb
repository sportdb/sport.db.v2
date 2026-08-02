
  ###
  ##  todo/fix -   use LangHelper or such
  ##   e.g.     class Lexer
  ##                include LangHelper
  ##            end
  ##
  ##  merge back Lang into Lexer - why? why not?
  ## keep "old" access to checking for group, round & friends
  ##    for now for compatibility
  def is_group?( text )  Lang.is_group?( text ); end
  def is_round?( text )  Lang.is_round?( text ); end


##
##  replace "escaped" newline with non-newline char e.g. '↵'
LINE_CONTINUATION_RE = %r{
                           \\[ ]* \n
                        }x



   ##
   ## e.g. used in (multi-line) TableNote
   ##  1.SOUTH KOREA   6  5  1  0 22- 1 16  [0-0]
   ##  2.LEBANON       6  3  1  2 11- 8 10  [0-2, 0-0]
   ##  3.Turkmenistan  6  3  0  3  8-11  9  [3-1]
   ##  4.Sri Lanka     6  0  0  6  2-23  0  [0-1]
   ##  -.North Korea   [withdrew after playing 5 matches due to safety concerns in
   ##                   connection with the Covid-19 pandemic; all results annulled]
   ##
   ##  note - no longer used for now
   ##     enclose multi-line notes in []
   ##         removes need for line continuation for now

##
##   txt = txt.gsub( LINE_CONTINUATION_RE ) do |_|
##            puts " [debug] preproc line continuation"
##              ## todo/check: replace with two spaces insead of ↵ - why? why not?
##               '↵'
##         end







##
##  todo/fix - add a command line switch/option for auto-format fixes !!!
   ##  quick hack - remove later
   ##    auto-convert "old" legacy round markers (»)
   txt = txt.gsub( %r{^ [ ]*
                          »
                        (?= [ ]+)  ## require one trailing space for now!!
                        }ix ) do |_|
                     puts "!! WARN - auto-fix format; replacing old (alternate/legacy) round marker (»)"
                        '▪'
                    end


###  16.00 => 16:00
##     todo/check - use space for positive lookbehind & ahead
##                      (instead of \b) - why? why not?
##  note - check for/exclude 12.12.  date in match
##             use negative lookahead
##   check for 12.12.94
##      use   positive lookbehind   !!!
##               must be space, comma or begin-of-line [ ,]|^
##    or use negative lookbehind
##               must NOT be dot
   txt = txt.gsub(  %r{
                        ## check NEGATIVE lookbehind
                         (?<! [.])  ## do NOT match 12.94 in 12.12.94
                          \b
                        (?<h>\d{1,2})
                           \.
                        (?<m>\d{2})
                          \b
                        (?! [.] )   ## do NOT match 12.12.
                        }ix ) do |_|
                           m = $~   ## is $LAST_MATCH_DATA
                        puts "!! WARN - auto-fix format; replacing old (alternate/legacy) time format #{m[0]}"
                           "#{m[:h]}:#{m[:m]}"   ## '\1:\2'
                        end
