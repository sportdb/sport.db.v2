####
#  to run use:
#    $ ruby ./main_goals.rb         (in /fbtxt)


##
##  check goal lines 

$LOAD_PATH.unshift( '../lib' )
require 'sportdb/parser'



txt = <<-TXT


        (Franck Ribéry 77, Ivica Olić 90+2;
             Wayne Rooney 2)
        (Franck Ribéry 77 Ivica Olić 90+2;
             Wayne Rooney 2)

        (Darron Gibson 3, Nani 7,41;
                Ivica Olić 43, Arjen Robben 74)
   
        (Theo Walcott 69, Cesc Fàbregas 85pen;
               Zlatan Ibrahimović 46,59)

               (Lionel Messi 21,37,42,88; Nicklas Bendtner 18)

                  (Diego Milito 35,70)

####
## try style with no minutes (optional count)                  

       (Theo Walcott, Cesc Fàbregas (p); Zlatan Ibrahimović (2))
       (Theo Walcott, Cesc Fàbregas (pen.); Zlatan Ibrahimović (2))
       (Theo Walcott  Cesc Fàbregas (p); Zlatan Ibrahimović (2))
       (Theo Walcott (p) Cesc Fàbregas; Zlatan Ibrahimović (2))

             (Lionel Messi (4); Nicklas Bendtner)
            (Lionel Messi (4/p); Nicklas Bendtner)
            (Lionel Messi (4/2p); Nicklas Bendtner)
           (Lionel Messi (4/2 pen.); Nicklas Bendtner)

            (Diego Milito (2))
            (Diego Milito (og))
            (Diego Milito (2og))
             (Diego Milito (2 o.g.))

            (Lionel Messi (4); N.N.)
            (Lionel Messi (4); N.N. (2))


###
#  allow mix'n'match for now  (that is, 
#  1) goal scorers with minutes
#  2) goal scorers w/o minutes
#  3) goal scorers w/o minutes with count e.g. (2) or (2/p) or (p), (og), etc.
   (Theo Walcott 69, Cesc Fàbregas 85p; Zlatan Ibrahimović (2))
      (Theo Walcott, Cesc Fàbregas (p); Zlatan Ibrahimović 46,59)
      (Theo Walcott, Cesc Fàbregas; Zlatan Ibrahimović)
      (Theo Walcott  Cesc Fàbregas; Zlatan Ibrahimović)

      ## note - commas (,) and semicolons (;) require no spaces
      (Theo Walcott,Cesc Fàbregas;Zlatan Ibrahimović)
      (Theo Walcott 69,Cesc Fàbregas 85p;Zlatan Ibrahimović (2))
      (Theo Walcott,Cesc Fàbregas (p);Zlatan Ibrahimović 46,59)
   

################
##  add question mark (?) for n/a, unknown - why? why not? 
#    -  use N.N. (1) as alternative - why? why not?
#   samples:
#                  (Lionel Messi 21,37,42,?)
#                  (Lionel Messi 21,?,42,?)
#                  (Lionel Messi ?,?,?,?)
#                  (Lionel Messi 21,37,42,88; Nicklas Bendtner ?)
#                  (Lionel Messi (4); ? (1))  
#                  (Lionel Messi (4); ? (2))  


##
## try alternate dash (-) separator !!!

(Metzger 83 - Krämer 29, 88, Cichy 33, Rahn 37)
(Metzger  - Krämer (2), Cichy, Rahn)

(Brunnenmeier 17 - Gerwien 74)
(Brunnenmeier - Gerwien)

(Schämer 40p - Neumann 38p)
(Schämer 40 p - Neumann 38 p)



###
#  try "inline" style

Werder      3-2 Dortmund    (Soya 34, Schütz 36, Klöckner 50; Konietzka 1, 90)
Werder      3-2 Dortmund    (Soya 34, Schütz 36, Klöckner 50; 
                             Konietzka 1, 90)


Hertha      1-1 Nürnberg    (Schimmöller 63p; Morlock 40)
Münster     1-1 Hamburger   (Dörr 70; Dörfel 86)
Frankfurt   1-1 K'lautern   (Schämer 40p; Neumann 38p)
Karlsruher  1-4 Meidericher (Metzger 83 - Krämer 29, 88, Cichy 33, Rahn 37)
S'brücken   0-2 1. FC Köln  (Overath 22, C.Müller 43)
TSV 1860    1-1 B'schweig   (Brunnenmeier 17 - Gerwien 74)
Schalke     2-0 Stuttgart   (Koslowski 37, Gerhardt 42)

S'brücken   v 1. FC Köln  0-2  (Overath 22, C.Müller 43)
TSV 1860    v B'schweig   1-1  (Brunnenmeier 17 - Gerwien 74)
Schalke     v Stuttgart   2-0  (Koslowski 37, Gerhardt 42)


TXT


  parser = RaccMatchParser.new( txt, debug: true )
  tree = parser.parse
  pp tree

  if parser.errors?
    puts "-- #{parser.errors.size} parse error(s):"
    pp parser.errors
  else
    puts "--  OK - no parse errors found"
  end
  


puts "bye"