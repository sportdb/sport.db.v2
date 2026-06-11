
module SportDb
class Lexer



def initialize( txt, debug: false )
   raise ArgumentError, "text as string expected for lexer; got #{txt.class.name}"  unless txt.is_a?(String)

   @txt   = txt
   @debug = debug
end




def tokenize_with_errors

    tokens_by_line = []   ## note: add tokens line-by-line (flatten later)
    errors         = []   ## keep a list of errors - why? why not?


    txt = _prep_doc( @txt )



    ####
    ## quick hack - keep re state/mode between tokenize calls!!!
    @re  ||= RE     ## note - switch between RE & INSIDE_RE

    lineno = 0
    txt.each_line do |line|
        lineno += 1

        ## todo - "inlined virtual/collapsed/folded newlines"
        ##   check for "↵" !!!
        ##   and add to lineno


        ## note - KEEP leading spaces for indent
        ##         use rstrip (NOT left/leading & right/trainling strip) only!!
        ## note -   remove/strip trailing newline (and optional spaces)!!!
        ##          trailing whitespace may incl. \n or \r\n!!!
        line = line.rstrip


        ###  skip comments
        ##      todo/check - change to blank line
        ##                     to keep lineno (closer to orginal) - why? why not?
        next  if line.match?(/\A  [ ]* ## optional leading space(s)
                                   \#
                                    /x )

        ##  strip (inline) end-of-line comments (from line)
        ##    check/discuss: make - inline comment require trailing space
        ##                      e.g.   #1 vs # 1   - why? why not?
        line = line.sub( /   [ ]*      ## (eat-up) optional leading space(s) too - why? why not?
                              \#{1,}.*?
                             \z
                            /x, '' )


        #  support __END__ marker to cut-off input
        break if line.match?( /\A [ ]*   ## optional leading space(s)
                                   __END__
                                 \z
                               /x )



        ## auto-fixes line-by-line (e.g. check for tabs, smart quotes, etc.)
        line = _prep_line( line )


        _trace( "line #{lineno}: >#{line}<" )


        ######
        ### special case for empty line (aka BLANK)
        if line.empty?
           ## note - blank always resets parser mode to std/top-level!!!
           @re = RE
           tokens_by_line << [Token.virtual(:BLANK, lineno: lineno)]
        elsif (m = HEADING_RE.match(line))
           ## note - heading always resets parser mode to std/top-level!!!
           @re = RE
           _trace( 'HEADING' )
           ## note - derive heading level from no of (leading) markers
           ##             e.g. = is 1, == is 2, == is 3, etc.
           heading_level = m[:heading_marker].size
           tokens_by_line << [Token.new(:"H#{heading_level}", m[:heading], lineno: lineno)]
        elsif (m = NOTA_BENE_RE.match(line))
           ## note - nota bene always resets parser mode to std/top-level!!!
           @re = RE
           tokens_by_line << [Token.new(:NOTA_BENE, m[:nota_bene], lineno: lineno)]
        else

          more_tokens, more_errors = _tokenize_line( line, lineno )

          tokens_by_line  << more_tokens
          errors          += more_errors
        end

       ## output last line from tokens by line in debug mode
        _trace( tokens_by_line[-1].pretty_inspect )

    end # each line




    tokens_by_line = tokens_by_line.map do |tokens|

        #################
        ##    transform tokens (using simple patterns)
        ##      to help along the (racc look ahead 1 - LA1) parser
        nodes = []

        buf = Tokens.new( tokens )
        ## pp buf


    loop do
          break if buf.eos?

          if buf.match?( :DATE, :TIME )   ## merge DATE TIME into DATETIME
               date = buf.next
               time = buf.next
               ## puts "DATETIME:"
               ## pp date, time

               ##  note:  time value is { time: {} } or
               ##                       { time: {}, time_local {} }
               text  = date.text + ' ' + time.text,  ## concat string of two tokens
               value = { date: date.value }.merge( time.value )

               nodes << Token.new(:DATETIME, text,
                                      lineno: date.lineno,
                                      offset: [date.offset[0],
                                               time.offset[1]],
                                      value: value )
          ### support  date time with comma too - why? why not?
          elsif buf.match?( :DATE, ',', :TIME )
               date = buf.next
               _    = buf.next  ## ignore comma
               time = buf.next
               ## puts "DATETIME:"
               ## pp date, time
               text  = date.text + ', ' + time.text  ## concat string of two tokens
               value =  { date: date.value }.merge( time.value )

               nodes << Token.new(:DATETIME, text,
                                      lineno: date.lineno,
                                      offset: [date.offset[0],
                                               time.offset[1]],
                                     value: value )
          elsif buf.match?( :GOAL_MINUTE, ',', :GOAL_MINUTE )
             ## note - only advance by two tokens!
             ##     allows more :GOAL_MINUTE sequences!! e.g. 12,13,14 etc!!!
             ##
             ## help parser with comma shift/reduce conflict
             ##   change ',' to GOAL_MINUTE_SEP !!!
             nodes << buf.next   ## pass through goal_minute
             comma = buf.next  ## eat-up goal_minute_sep a.k.a. comma (,)
                           ##   and replace with dedicated sep(arator)
             nodes << Token.new( :GOAL_MINUTE_SEP,
                                      comma.text,
                                      lineno: comma.lineno,
                                      offset: comma.offset,
                                      value:  comma.value)
          elsif buf.match?( ',', :INLINE_ATTENDANCE )
             ## note  - allow optional comma before inline attendance
             ## help parser with comma shift/reduce conflict
             ##   change ',' to INLINE_ATTENDANCE_SEP !!!
             comma = buf.next  ## eat-up inline_attendance_sep a.k.a. comma (,)
                           ##   and replace with dedicated sep(arator)
             nodes << Token.new(:INLINE_ATTENDANCE_SEP,
                                    comma.text,
                                    lineno: comma.lineno,
                                    offset: comma.offset,
                                    value:  comma.value)
             nodes << buf.next   ## pass through inline_attendance
          else
             ## pass through
             nodes << buf.next
          end
    end  # loop
    nodes
  end  # map tokens_by_line


    ## puts "tokens_by_line:"
    ## pp tokens_by_line


    ## flatten tokens
    tokens = []
    tokens_by_line.each do |tok_line|

        ## if debug?
        ##   pp tok_line
        ## end

         tokens  += tok_line

         ## auto-add newlines  (unless BLANK!!)
         unless tok_line[0] && tok_line[0].type == :BLANK
            ## note - reuse lineno from first token in line
            ##                  use last - why? why not?
            tokens  << Token.newline( lineno: tok_line[0].lineno )
         end
    end

    [tokens,errors]

end   # method tokenize_with_errors



end  # class Lexer
end # module SportDb
