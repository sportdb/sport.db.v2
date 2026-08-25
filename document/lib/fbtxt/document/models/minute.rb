module Fbtxt
 module Model


class Minute

    attr_reader :m, :offset, :secs

    def initialize( m:, offset: nil, secs: nil )

      raise ArgumentError, "(integer) number or ?,?? string expected for minute; " +
                           "got >#{m}< #{m.class.name}"  unless m.is_a?(Integer) ||
                                                                (m.is_a?(String) && m == '?' || m == '??')

      @m      = m
      @offset = offset
      @secs   = secs
    end

    ## todo/check - rename offset to injury/stoppage (time) or such - why? why not?
=begin
Alternative naming conventions
here are the three best ways to rename it
 - stoppage:       Short, clean, and highly readable in a class context
                       Minute.new(m: 90, stoppage: 4).
 - stoppage_time:  Highly explicit if you want zero ambiguity.
 - added_time:     Another officially recognized term that reads very naturally.
=end


    def as_json(*) to_s; end

    def to_s
      buf = String.new
      buf << "#{m}"
      ### note - do NOT autoadd minute quote for now
      ##    make it an option e.g.  to_s( :quote) or such - why? why not?
      ### buf << "'"
      buf << "+#{offset}"      if offset
      buf << "/#{secs} secs"   if secs
      buf
    end

    def pretty_print( q )
       q.text( to_s )
    end


    include Comparable   ## note - auto-adds <, <=, ==, >=, >, and between?
    def <=>(other)
       return nil unless other.is_a?(Minute)

       ## returns -1/0/1
        ## -- note - check for unknowns e.g. ?? or such
        ##       quick hack - for now assume everything but a number is unknown!!!
       res =   (m.is_a?(Integer) ? m : 999) <=> (other.m.is_a?(Integer) ? other.m : 999)
       res =  (offset||0) <=> (other.offset||0)   if res == 0
       res
    end
end  # class Minute


end # module Model
end # module Fbtxt
