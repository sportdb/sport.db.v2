
module Fbtxt
class MatchTree


class EventCard    ### use EventBooking - why? why not?
    attr_reader :type
    attr_reader :name
    attr_reader :minute

    def initialize( type:, name:, minute: nil )
        @type   = type
        @name   = name
        @minute = minute
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
        @minute   = minute
    end

    def as_json(*)
        h = { 'on'  => name_on,
              'off' => name_off }
        h['minute'] = minute.to_s    if minute

        h
    end
end  ## EventSub



class Referee  ## rename to/use Official - why? why not?
    attr_reader :name, :country

    def initialize( name:, country: nil )
        @name    = name
        @country = country
    end

    def as_json(*)
        h = { 'name' => name }
        h['country'] = country    if country

        h
    end
end  # class Referee



class Player

    attr_reader :name
    ## add pos(ition) e.g. GK,DF,MF,FW

    def initialize( name:, captain: false )
        @name    = name
        @captain = captain
    end

    def captain?() @captain; end



    def as_json(*)
        h = { 'name' => name }
        h['captain'] = true    if captain?

        h
    end
end # class Player


end # class MatchTree
end # module Fbtxt