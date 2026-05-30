####
#  to run use:
#    $ ruby sandbox/test_props.rb


$LOAD_PATH.unshift( './lib' )
require 'sportdb/parser'


PROP_KEY_RE  = SportDb::Lexer::PROP_KEY_RE
PROP_NAME_RE = SportDb::Lexer::PROP_NAME_RE


texts = [## try  teams
          "1.K.: ",
          "Union 1.K.: ",
          "1 FC: ",
          "1.FC: ",
          "1FC: ",
          "K.-H.: ",
          "U.S.A.:",
          "SKN St. Pölten: ",
          "SKN St.Pölten: ",
          "St. Pölten: ",
          "St.Pölten: ",
          "St.Pauli: ",
          "Paris St.-Germain: ",
          "A.C. Milan: ",
          "A.C.Milan: ",
          "1° Mayo: ",
          "1°Mayo: ",
          "Borussia 'gladbach: ",
          "Borussia M'gladbach: ",
          "Real Madrid C.F.: ",
          "Real C.F.: ",
          "C.F.Madrid: ",
          "C.F. Madrid: ",
          "Team U.S.A.: ",
          "U.S.A. Team: ",
          "U.S.A.Team: ",
          "Union 1. FC Stein: ",
          "Union 1.FC Stein: ",
         "Achilles'29 II:  ",
         "  UDI'19/Beter Bed :  ",
         "UDI '19/Beter Bed: ",
         "One/Two: ",        ##=>     [WORD: "One"], [WORD: "Two"]
         "1. FC Köln: ",     ##=>     [NUM+WORD: "1. FC"], [WORD: "Köln"]
         "1 FC Köln : ",     ##=>     [NUM+WORD: "1 FC"], [WORD: "Köln"]
         "1.FC Köln:",
         "A: ",
         "b: ",
         "  c : ",
         "A1: ",             ##=>     [WORD: "A1"]
         "1B: ",             ##=>     [NUM+WORD: "1B"]
         ## generic names:
         "Penalties: ",
         "Penalties:",   ## without space
         ## numbers & dates
         "111: ",
         "1: ",
         "10/11/92: ",
         "Fri Apr 11 18:20 ",
         ]

texts.each do |text|
  puts "==> #{text}"
  m=PROP_KEY_RE.match( text )

  if m
    print "  "
    pp m
  else
    puts "!! prop key NOT matching"
  end
end



texts = [## try teams
         "Achilles'29 II  xxxx",
         "  UDI/Beter Bed  ",
         "  UDI / Beter Bed  ",
         "  UDI/ Beter Bed  ",
         "  UDI /Beter Bed  ",
         "UDI'Beter Bed",
         "UDI' Beter Bed",
         "UDI 'Beter Bed",
         "UDI ' Beter Bed",
         "One/Two ",
         "One-Two ",
         "One - Two ",
         "111 ",
         "FC Köln: ",
         "Stop. ",
         "Frank V. 24'.",
         "Frank V. 24'. ",
         "Frank V.",
         "J.Doe",
         "J. Doe",
         ]


puts
puts "--- prop names:"

texts.each do |text|
  puts "==> #{text}"
  m=PROP_NAME_RE.match( text )

  if m
    print "  "
    pp m
  else
    puts "!! prop name NOT matching"
  end
end


puts "bye"