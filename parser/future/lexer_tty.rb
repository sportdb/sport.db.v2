module SportDb
class Lexer


########
##   experimental teletype mode 
##    only space, A-Z and 0-9 allowed
IS_TTY_LINE_RE = %r{  \A  
                       ## note - use NEGATIVE lookahead to exclude blank lines
                         (?! [ ]*\z)

                          [A-Z0-9 ]+
                      \z
                  }x


TTY_SPACES_RE = %r{ (?<spaces> [ ]{2,}) |
                    (?<space>  [ ])
                  }x
TTY_NUM_RE    = %r{   \b  (?<num> \d+ ) \b 
                  }x

##
##  note - TEXT for now allows    A, 1A, A1, A1A, A1 B1 C1, 
##                                A1AA1 2B22 3C33
##    - single space only for concat
##       text segments MUST NOT be all numbers e.g. 1, 11, etc.                  
TTY_TEXT_RE   = %r{   \b (?<text>                         
                           (?:
                              [A-Z]  ## MUST start with letter  
                                |
                               [0-9]+[A-Z]   ## or numbers followed by letter 
                             )
                             [0-9A-Z]*
                             (?:
                                 ### allow move segements separated
                                 ##     by single space
                                  [ ]
                                 (?: 
                                     [A-Z]  ## MUST start with letter  
                                      |
                                     [0-9]+[A-Z]   ## or numbers followed by letter 
                                  )
                                 [0-9A-Z]*
                             )*
                          )
                          \b   
                  }x 


TTY_RE = Regexp.union(
                TTY_SPACES_RE,
                TTY_TEXT_RE,
                TTY_NUM_RE,
                ##  fix add ANY_RE,  
)


def _tokenize_tty_line( line )
   line = line.strip

   tokens = []
   
   ## track last offsets - to report error on no match
   ##   or no match in end of string
   offsets = [0,0]
   pos = 0
   m = nil   
 

  while m = TTY_RE.match( line, pos )
    offsets = [m.begin(0), m.end(0)]

    if offsets[0] != pos
      ## match NOT starting at start/begin position!!!
      ##  report parse error!!!
      msg =  "!! WARN - tokenize (tty) error - skipping >#{line[pos..(offsets[0]-1)]}< @#{offsets[0]},#{offsets[1]} in line >#{line}<"
      puts msg
      log( msg )
    end

    pos = offsets[1]

    t =  if m[:spaces] || m[:space] 
               nil    ## skip spaces
          elsif m[:text]
            [:TTY_TEXT, m[:text]]
          elsif m[:num]
            [:TTY_NUM, m[:num].to_i(10)] 
          else
              ## report error/raise expection
              puts "!!! TTY TOKENIZE ERROR - no match found"
              nil 
          end
     
    tokens << t    if t
  end

  ## check if no match in end of string
  if offsets[1] != line.size
      msg =  "!! WARN - tokenize (tty) error - skipping >#{line[offsets[1]..-1]}< @#{offsets[1]},#{line.size} in line >#{line}<"
      puts msg
      log( msg )
  end

  tokens
end

end  # class Lexer
end # module SportDb

