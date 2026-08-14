###
##  tokenize pipeline (step 2) - normalize tokens
##
##    transform (normalize) tokens (using simple patterns)
##      to help along the (racc look ahead 1 - LA1) parser

module Fbtxt
class Lexer


def normalize_tokens( tokens_by_line )

    tokens_by_line = tokens_by_line.map do |tokens|

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

 tokens_by_line
end

end ## class Lexer
end ## module Fbtxt
