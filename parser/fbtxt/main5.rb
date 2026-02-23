####
#  to run use:
#    $ ruby ./main5.rb  (in /fbtxt)



$LOAD_PATH.unshift( '../lib' )
require 'sportdb/parser'




txt = <<-TXT

Sat Jun 3
  Republic of St. Pauli - Gibraltar  1-2   @ Hamburg, Germany
 
  Northern Cyprus - Zanzibar  0-0   @ Hamburg, Germany    [Northern Cyprus wins on penalties]
   
  
  (Wirtz 0' Musiala, Havertz 45+1' (pen) Wu Xi 54' Sun Ke 68'; 
     Rüdiger 87' (og))



### try
###   Copa América 1979 @ https://www.rsssf.org/tables/79safull.html
###
###  todo - support 08.08.1979 and 1979.08.08 too ???


08.08.1979  @ San Cristóbal, Pueblo Nuevo   att: 14000 
  VEN - CHI   1-1 (0-0)

## 1-0 Carvajal 70',  1-1 Peredo 81'

##   César Pagano PER 

VEN: Vega - Contreras, Castro, Vidal, Campos - Mendoza, Páez, Sánchez - 
     Peña (Santana), Carvajal, Hernández (Castillo)
CHI: Osbén - González, Valenzuela, Soto, Escobar - Rivas (Quiroz), Dubó, Neira - 
     Yáñez, Peredo, Véliz




02.08.79  @ Río de Janeiro, Maracaná   att: 130000 
  BRA v ARG  2-1 (1-1) 

## Edison Pérez PER 

BRA: Leão - Toninho, Amaral, Edinho, Pedrinho - Carpeggiani, Zenon (Batista), Tita -
     Palinha (Juan), Zico, Zé Sergio 
ARG: Vidallé - Barbas, Van Tuyne, Passarella, Bordón - Gáspari, Larraquy, Gaitán (López 46') -
     Coscia, Maradona, Díaz (Castro 62')


################     
## try alt goal line style
##   to be done!!!

(1-0 Zico 2', 1-1 Coscia 29', 2-1 Tita 54')

## try with (og), (pen) and multi-line
(1-0 Zico 2' (pen), 1-1 Coscia 45+1' (og), 
 2-1 Tita 54')


## try without minutes
(1-0 Zico  1-1 Coscia  2-1 Tita)


## make possible - FIX/FIX/FIX/TODO/TODO/TODO - why? why not?
#   --- move (og) (pen) to parse tree  og, pen as boolean flags - why? why not?
(1-0 Zico  1-1 Coscia (pen)  2-1 Tita (og)) 


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

