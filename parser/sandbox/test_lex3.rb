####
#  to run use:
#    $ ruby sandbox/test_lex3.rb  



$LOAD_PATH.unshift( './lib' )
require 'sportdb/parser'


txt = <<TXT


Tue Feb/13
  20.45  Juventus             2-2  Tottenham Hotspur    @ Juventus Stadium, Turin
           (Higuaín 2', 9' (pen.); Kane 35' Eriksen 71')
  20.45  Juventus             2-2  Tottenham Hotspur    @ Juventus Stadium, Turin
           (Higuaín 2', 9'p; Kane 35' Eriksen 71')

  20.45  Basel                0-4  Manchester City      @ St. Jakob-Park, Basel
           (-; Gündoğan 14', 53' B. Silva 18' Agüero 23' (o.g.))
  20.45  Basel                0-4  Manchester City      @ St. Jakob-Park, Basel
           (- ; Gündoğan 14', 90+3'p  B. Silva 18' Agüero 45+2'og)

           
Wed Feb/14
  20.45  Porto                v Liverpool  0-5            @ Estádio do Dragão, Porto
           (-; Mané 25', 53', 85' Salah 29' Firmino 69')
  20.45  Real Madrid          v Paris Saint-Germain  3-1  @ Santiago Bernabéu, Madrid
           (Ronaldo 45' (pen.), 83' Marcelo 86'; 
            Rabiot 33')

  20.45  Porto                v Liverpool  0-5            @ Estádio do Dragão, Porto
           (-; Mané 25, 53, 85 Salah 29 Firmino 69)
  20.45  Real Madrid          v Paris Saint-Germain  3-1  @ Santiago Bernabéu, Madrid
           (Ronaldo 45pen, 83 Marcelo 86;  Rabiot 33)


Tue Feb/20
  20.45  Bayern München       5-0  Beşiktaş             @ Allianz Arena, München
           (Müller 43', 66' Coman 53' Lewandowski 79', 88')
  20.45  Chelsea              1-1  Barcelona            @ Stamford Bridge, London
           (Willian 62'; Messi 75')

##  check for goal scorer line inline (note - NOT ALLOWED for now)
##  20.45  Manchester City      1-2  Liverpool      (Gabriel Jesus 2'; Salah 56' Firmino 77')

TXT

puts txt
puts
     
  lexer = SportDb::Lexer.new( txt, debug: true )
  tokens, errors = lexer.tokenize_with_errors
  pp tokens

  if errors.size > 0
     puts "!! #{errors.size} tokenize error(s):"
     pp errors
  end


puts "bye"

