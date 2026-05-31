####
#  to run use:
#    $ ruby sandbox/test_props.rb


$LOAD_PATH.unshift( './lib' )
require 'sportdb/parser'


PROP_KEY_RE  = SportDb::Lexer::PROP_KEY_RE
PROP_NAME_RE = SportDb::Lexer::PROP_NAME_RE



texts = [## try  teams
          "1A 1A: ",             ## [NUMALPHA: "1A"], [NUMALPHA: "1A"]
          "1.K.: ",              ## [NUM: "1."], [WORD: "K."]
          "Union 1.K.: ",        ## [WORD: "Union"], [NUM: "1."], [WORD: "K."]
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
          "FC St.Pauli: ",
          "Paris St.-Germain: ",
          "A.C. Milan: ",
          "A.C.Milan: ",
          "1° Mayo: ",
          "1°Mayo: ",
          "21°Mayo: ",
          "21° Mayo: ",
          "21.Mayo: ",
          "21. Mayo: ",
          "Borussia 'gladbach: ",
          "Borussia M'gladbach: ",
          "Borussia M'Gladbach: ",
          "D' La Santa: ",
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
         "Brighton & Hove Albion F.C.: ",
         "Brighton&Hove Albion FC: ",
         "Brighton&Hove: ",
         "A: ",
         "b: ",
         "  c : ",
         "A1: ",             ##=>     [WORD: "A1"]
         "1B: ",             ##=>     [NUMALPHA: "1B"]
         ## nore names
         "St. Patrick's: ",
         "St.Patrick's: ",
         "St.Gallen: ",
         "Lausanne-Sport: ",
         "Union Saint-Gilloise: ",
         "Sint-Truiden: ",
         "FC Blau-Weiß Linz: ",
         "Bodö/Glimt: ",
         "SV Stripfing/Weiden: ",
         "Kapfenberg 1919: ",
         "Grazer AK 1902: ",
         "Bayer 04 Leverkusen: ",
         "1.FSV Mainz 05: ",
         "1.FC Heidenheim 1846: ",
         ## generic names:
         "Penalties: ",
         "Penalties:",   ## without space

         ################################
         ## numbers & dates
         "111: ",                    ## number only
         "1: ",                      ## number only
         "10/11/92: ",               ## numbers only
         "Fri Apr 11 18:20 ",        ##     colon (:)  requires trailing space rule!!!
         "5.-6. Playoff: ",          ## starting number MUST be follow by word !!
         "1/8 Final: ",              ## starting number MUST be follow by word !!
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