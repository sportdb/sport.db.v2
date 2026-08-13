
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


end # module Model
end # module Fbtxt
