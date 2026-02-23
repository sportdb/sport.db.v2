####
#  to run use:
#    $ ruby ./main_penalties.rb  (in /fbtxt)



$LOAD_PATH.unshift( '../lib' )
require 'sportdb/parser'



txt = <<-TXT


Penalties:       1-0  Mario Gavranović, 1-1 Paul Pogba, 
                 2-1  Fabian Schär, 2-2 Olivier Giroud,
                 3-2  Manuel Akanji, 3-3 Marcus Thuram, 
                 4-3 Ruben Vargas, 4-4  Presnel Kimpembe, 
                 5-4 Admir Mehmedi,  Kylian Mbappé (save)


Penalties:          0-0 Sergio Busquets (post), 0-1 Mario Gavranović, 
                    1-1 Dani Olmo, 1-1 Fabian Schär (save), 
                    1-1 Rodrigo Hernández "Rodri" (save), 1-1 Manuel Akanji (save), 
                    2-1 Gerard Moreno, 2-1 Ruben Vargas (miss),
                    3-1  Mikel Oyarzabal

Penalties:          Sergio Busquets (post), Mario Gavranović, 
                    Dani Olmo, Fabian Schär (save),  
                    Rodrigo Hernández 'Rodri' (save), Manuel Akanji (save),  
                    Gerard Moreno, Ruben Vargas (miss),
                    Mikel Oyarzabal


Penalty shootout: 0-0 Zinho (held), 0-1 Dudamel; 
                  1-1 Júnior Baiano, 1-2 Gaviria;
                  2-2 Roque Júnior, 2-3 Yepes; 
                  3-3 Rogério, 3-3 Bedoya (post);
                  4-3 Euller, 4-3 Zapata (wide) 

Penalty shootout:     Zinho (held),  0-1 Dudamel; 
                  1-1 Júnior Baiano, 1-2 Gaviria;
                  2-2 Roque Júnior,  2-3 Yepes; 
                  3-3 Rogério,           Bedoya (post);
                  4-3 Euller,            Zapata (wide) 


TXT


   
parser = RaccMatchParser.new( txt, debug: true )
tree, errors = parser.parse_with_errors
pp tree

if errors.size > 0
   puts "!! #{errors.size} parse error(s):"
   pp errors
else
   puts "--  OK - no parse errors found"
end


puts "bye"

