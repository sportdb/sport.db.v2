
module Fbtxt
  module Model


class Coach  ## rename to/use Official - why? why not?
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
end  # class Coach


end # module Model
end # module Fbtxt
