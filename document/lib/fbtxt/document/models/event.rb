
module Fbtxt
  module Model


##############
## e.g.
##    'Y',  Player, 44
##    'YR', Player, 45+2

class EventCard    ### use EventBooking - why? why not?
    attr_reader :type
    attr_reader :name
    attr_reader :minute

    def initialize( type:, name:, minute: nil )
        @type   = type
        @name   = name

        ## note - auto-convert to our own Minute format
        @minute =  if minute.is_a?( RaccMatchParser::Minute )
                        Minute.new( m:      minute.m,
                                    offset: minute.offset,
                                    secs:   minute.secs )
                   else
                    minute
                   end
    end


    def as_json(*)
        h = { 'type' => type,
              'name' => name }
        h['minute'] = minute.to_s    if minute

        h
    end
end  # class EventCard


class EventSub   ## use just Sub or ??

    attr_reader :name_on    ## use on only - why? why not?
    attr_reader :name_off   ## use off only
    attr_reader :minute

    def initialize( on:, off:, minute: nil )
        @name_on  = on
        @name_off = off

        ## note - auto-convert to our own Minute format
        @minute =  if minute.is_a?( RaccMatchParser::Minute )
                        Minute.new( m:      minute.m,
                                    offset: minute.offset,
                                    secs:   minute.secs )
                   else
                    minute
                   end
    end

    def as_json(*)
        h = { 'on'  => name_on,
              'off' => name_off }
        h['minute'] = minute.to_s    if minute

        h
    end
end  ## EventSub


end # module Model
end # module Fbtxt
