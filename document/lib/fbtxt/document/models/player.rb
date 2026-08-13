
module Fbtxt
  module Model



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
    ## fix-fix-fix
    ##   add pos(ition) e.g. GK,DF,MF,FW


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


end # module Model
end # module Fbtxt