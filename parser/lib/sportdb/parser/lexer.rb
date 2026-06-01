
module SportDb
class Lexer



def log( msg )
   ## append msg to ./logs.txt
   ##     use ./errors.txt - why? why not?
   ##
   ##  change to ./logs_lexer.txt or such - why? why not?
   ##    auto-add/prepend  [Lexer] and timestamp!!!  to msg - why? why not?
   File.open( './logs.txt', 'a:utf-8' ) do |f|
     f.write( msg )
     f.write( "\n" )
   end
end


def _trace( *args )
  if debug?
    print "[DEBUG] Lexer -- "
    args.each { |arg| puts args }
  end
end

def _warn( *args )
  print "!! [WARN] Lexer -- "
  args.each { |arg| puts args }
end

def _info( *args )
  print "[INFO] Lexer -- "
  args.each { |arg| puts args }
end


def debug?()  @debug == true; end





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

        ##  fix-fix-fix-fix  - change to line.rstrip  (keep leading spaces) for indent!!
        ## line = line.rstrip   ## note - MUST remove/strip trailing newline (spaces optional)!!!
        line = line.strip   ## note - strip leading AND trailing whitespaces
                            ## note - trailing whitespace may incl. \n or \r\n!!!



        next  if line.start_with?('#')   ###  skip comments

        line = line.sub( /#.*/, '' ).strip   ###  cut-off end-of line comments too


        ####
        #  support __END__ marker to cut-off input
        break if line.strip == '__END__'



        ## auto-fixes line-by-line (e.g. check for tabs, smart quotes, etc.)
        line = _prep_line( line )


        _trace( "line #{lineno}: >#{line}<" )


        ######
        ### special case for empty line (aka BLANK)
        if line.empty?
           ## note - blank always resets parser mode to std/top-level!!!
           @re = RE
           tokens_by_line << [[:BLANK, '<|BLANK|>']]
        elsif (m = HEADING_RE.match(line))
           ## note - heading always resets parser mode to std/top-level!!!
           @re = RE
           _trace( 'HEADING' )
           ## note - derive heading level from no of (leading) markers
           ##             e.g. = is 1, == is 2, == is 3, etc.
           heading_level = m[:heading_marker].size
           tokens_by_line << [[:"H#{heading_level}", m[:heading]]]
        elsif (m = NOTA_BENE_RE.match(line))
           ## note - nota bene always resets parser mode to std/top-level!!!
           @re = RE
           tokens_by_line << [[:NOTA_BENE, m[:nota_bene]]]
       elsif @re == RE && (m = TABLE_RE.match(line))
            @re = TABLE_MORE_RE  ## switch into table mode
            if m[:table_heading]
              tokens_by_line << [[:TABLE_HEADING, m[:table_heading]]]
            else  ## assume table (line) e.g. m[:table]
              tokens_by_line << [[:TABLE_LINE, line]]
            end
        elsif @re == TABLE_MORE_RE
            ### todo/fix - check if no match and report/add error!!
            ##        for now (ummatched) line gets auto-added as table line!!!
            ##
            ##   note - MUST be followed by blank line (or nota bene/heading)
            ##            to switch back into to top-level!!!!
            m = TABLE_MORE_RE.match(line)
            if m[:table_note]
              tokens_by_line << [[:TABLE_NOTE, m[:table_note]]]
            elsif m[:table_divider]
              tokens_by_line << [[:TABLE_DIVIDER, m[:table_divider]]]
            else  ## assume table (line) e.g. m[:table]
              tokens_by_line << [[:TABLE_LINE, line]]
            end
        else

          more_tokens, more_errors = _tokenize_line( line, lineno )

          tokens_by_line  << more_tokens
          errors          += more_errors
        end
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
               date = buf.next[1]
               time = buf.next[1]
               ## puts "DATETIME:"
               ## pp date, time
               ##  note:  time value is { time: {} } or
               ##                       { time: {}, time_local {} }
               val =  [date[0] + ' ' + time[0],  ## concat string of two tokens
                        { date: date[1] }.merge( time[1] )
                      ]
               nodes << [:DATETIME, val]
         ### support  date time with comma too - why? why not?
         elsif buf.match?( :DATE, :',', :TIME )
               date  = buf.next[1]
               _    = buf.next  ## ignore comma
               time = buf.next[1]
               ## puts "DATETIME:"
               ## pp date, time
               val =  [date[0] + ', ' + time[0],  ## concat string of two tokens
                        { date: date[1] }.merge( time[1] )
                      ]
               nodes << [:DATETIME, val]
         elsif buf.match?( :GOAL_MINUTE, :',', :GOAL_MINUTE )
             ## note - only advance by two tokens!
             ##     allows more :GOAL_MINUTE sequences!! e.g. 12,13,14 etc!!!
             ##
             ## help parser with comma shift/reduce conflict
             ##   change ',' to GOAL_MINUTE_SEP !!!
             nodes << buf.next   ## pass through goal_minute
             _ = buf.next  ## eat-up goal_minute_sep a.k.a. comma (,)
                           ##   and replace with dedicated sep(arator)
             nodes << [:GOAL_MINUTE_SEP,"<|GOAL_MINUTE_SEP|>"]
         elsif buf.match?( :',', :INLINE_ATTENDANCE )
             ## note  - allow optional comma before inline attendance
             ## help parser with comma shift/reduce conflict
             ##   change ',' to INLINE_ATTENDANCE_SEP !!!
             nodes << [:INLINE_ATTENDANCE_SEP, "<|INLINE_ATTENDANCE_SEP|>"]
             _ = buf.next  ## eat-up inline_attendance_sep a.k.a. comma (,)
                           ##   and replace with dedicated sep(arator)
             nodes << buf.next   ## pass through inline_attendance
          else
             ## pass through
             nodes << buf.next
          end
    end  # loop
    nodes
  end  # map tokens_by_line




    ## flatten tokens
    tokens = []
    tokens_by_line.each do |tok|

        if debug?
           pp tok
        end

         tokens  += tok
         ## auto-add newlines  (unless BLANK!!)
         tokens  << [:NEWLINE, "\n"]   unless tok[0] && tok[0][0] == :BLANK
    end

    [tokens,errors]
end   # method tokenize_with_errors



end  # class Lexer
end # module SportDb
