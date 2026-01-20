####
#  to run use:
#    $ ruby sandbox/test_text.rb


$LOAD_PATH.unshift( './lib' )
require 'sportdb/parser'


TEXT_RE = SportDb::Lexer::TEXT_RE


texts = [## try teams
         "Achilles'29 II",
         "UDI'19/Beter Bed",
         "UDI '19/Beter Bed",
         "One/Two",
         "One / Two",
         "V. Köln",    ## note - v and vs only reserved in lower case!!!
         "V Köln",
         "Naval 1° de Maio",
         "1° de Maio",
         "Achilles'29 II v UDI'19/Beter Bed",  ## only match up to v!!!!
         "Qingdao Pijiu (Beer)",    ## note (Beer) assumed as country code!!
         "August 1st (Army Team)",   ## note - invalid country code - no space allowed!!!
         "Austria 2",
         "Dnpro-1",
         "Brighton & A",

         "Cote'd Ivoir",
         "ASC Monts d'Or Chasselay",
         "Grenoble Foot 38",

         ## try rounds
         "2. Aufstieg 1. Phase",
         "2. Aufstieg 2. Phase",
         "2. Aufstieg 3. Phase",
         "Direkter Aufstieg",
         "Direkter Abstieg",
         "Zwischenrunde Gr. B",
         "5. Platz",
         "7. Platz",
         "9. Platz",
         "11. Platz",

         "2. Aufstieg 3.12",

         ## more weird rounds
         "5.-8. Platz Playoffs",
         "9.-12. Platz Playoffs",
         "13.-16. Platz Playoffs",

         ## check special starting with quote
         "'s Gravenwezel-Schilde",
         "'s Gravenwezel",
         "'s",

         ### check break on dash ( - ) or ( / )
         "Final - First Leg",
         "Final- First Leg",
         "Final -First Leg",
         "Final-First Leg",
         "Final / First Leg",
         "Final/ First Leg",
         "Final /First Leg",
         "Final/First Leg",
         "ITA - FRA",



         ## check breaks on date, score etc.
         "Rapid 1-1",
         "Rapid 2:10",
         "Rapid 2h10",
         "Rapid 2",   ## note - ALLOWED - no break
         "Rapid 2'",
         "Rapid 45+1'",
         "Rapid 45+",
         "Rapid v Austria",
         "Rapid vs Austria",

         ## check two space rule
         "Rapid  Austria",
         "Rapid 2  Austria 2",
         "A  B",
         "A B",

         ## check single char
         "A",
         "a",
         ## check codes
         "A1",
         "a2",
         "a3",
         ## check endings - must be alphanum
         "A-",  ## not allowed
         "A&",  ## note - ALLOWED FOR NOW - like strategy& !!
         "A°",  ## note - ALLOWED FOR NOW
         "A'",  ## note - ALLOWED FOR NOW
         "12'",  ## chech minute style number
         "A.",  ## note - ALLOWED FOR NOW
         "12°",
         "11",
         "11  A",
         "1",
         ## test weirdos  - maybe disallow - why? why not?
         "a&&&&&&",
         "a.........",
         "a''''''''''",   
         ## more
         "Park21 Arena",
         "Park21-Arena",
         "Park21/Arena",
         "21.A",
         "21°A",
         "21 A",
         "21A",

         ## group and matchday (fit team name pattern)
         "Group A",
         "Group 1.A",
         "Group 1A",
         "Group A.1",
         "Group A1",
         "Group 1.1",    ## note - NOT ALLOWED - will break on 1.1 !!
         "Matchday 1",
         "1. Round",

         ## check some more
         "U21 Matzlatan",
         "U17 Matzlatan",
         "Bosina & Herz",

         "20.45 Real Madrid",
         ]


texts.each do |text|
  puts "==> #{text}"
  m=TEXT_RE.match( text )
  print "  "
  pp m

  if m.nil? || text != m[0]
     puts "!! text NOT matching"
  end
end


puts "bye"