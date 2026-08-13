module Fbtxt
 module Model

class Penalty

  ## todo
  ##  - add attr_reader :team     ## note - 1|2 expected  - why? why not?


    attr_reader :name
    attr_reader :score
    attr_reader :note

    def initialize( name:, score: nil, note: nil )
        @name    = name
        @score   = score
        @note    = note
    end


    ## add alias for name => player - why? why not?
    ##  alias_method :player, :name


    def as_json(*)
        h = { 'name'  => name }
        h['score'] = score     if score.is_a?(Array) && !score.empty?
        h['note']  = note      if note

        h
    end
end  ## Penalty

end # module Model
end # module Fbtxt
