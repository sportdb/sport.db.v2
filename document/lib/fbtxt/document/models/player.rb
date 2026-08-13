
module Fbtxt
  module Model


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