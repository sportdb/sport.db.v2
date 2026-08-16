###
#  to run use
#    $ ruby test/test_geo_names.rb


require_relative 'helper'

class TestGeoNames < Minitest::Test



#  todo/fix  replace with read_data() from cocos - why? why not?
###           use/add upstream generic read_names (or read_list ??) - why? why not?
def self.prepare( txt )
   names = []
   txt.each_line do |line|
       # strip comments
        line = line.strip   ## note - strip leading AND trailing whitespaces
                            ## note - trailing whitespace may incl. \n or \r\n!!!

        next if line.start_with?('#')   ###  skip comments

        line = line.sub( /#.*/, '' ).strip   ###  cut-off end-of line comments too

        next if line.empty?   ### skip blank lines

        names << line
   end
   names
end


VALID_GEOS = prepare(<<TXT)

Newcastle upon Tyne

## check for extended geo names
##    e.g. Dublin (Dalymount Park)

Dublin (Dalymount Park)
Ost-Berlin (Walter-Ulbricht)
Paris (Parc des Princes)
Bucuresti (23 August)
Athinai (OAKA - Maroussi)

#####
## try with   _-_ and _/_ in geo

Stade de la Beaujoire - Louis Fonteneau
St. James' Park

TXT



def test_geos
   VALID_GEOS.each do |geo|
      m =  Fbtxt::Lexer._parse_geo( geo )
      if m
         puts "OK >#{geo}<"
         assert true
      else
         puts "!! >#{geo}<"
         assert false, "is_geo (regex) match failed for >#{geo}<"
      end
  end
end

end  # class TestGeoNames
