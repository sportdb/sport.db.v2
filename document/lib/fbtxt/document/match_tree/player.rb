
module Fbtxt
class MatchTree



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
        h['minute'] = minute    if minute

        h
    end
end  ## EventSub


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