require 'cocos'

txt = read_text( "./quick.txt" )



pp txt

fix = "        St-Aubin Guérande v Revel"

pp fix


##
##  note:  e is decomposed   !!!!  - will break lexer!!!
##   e (101)
##   ́  (769)
##   vs
##     é (233)

fix.each_char do |char|
                 puts "#{char} (#{char.ord})"
end

fix = fix.unicode_normalize(:nfc)

fix.each_char do |char|
                 puts "#{char} (#{char.ord})"
end


=begin
S (83)
t (116)
- (45)
A (65)
u (117)
b (98)
i (105)
n (110)
  (32)
G (71)
u (117)
e (101)
́ (769)
=end



puts "bye"