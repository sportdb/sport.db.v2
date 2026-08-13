module Fbtxt
 module Model


class Minute

    attr_reader :m, :offset, :secs
    ## todo/check - rename offset to injury/stoppage (time) or such - why? why not?

    def initialize( m:, offset: nil, secs: nil )
      @m      = m
      @offset = offset
      @secs   = secs
    end


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
end  # class Minute


end # module Model
end # module Fbtxt
