####
#  more team names
#
#  to run use:
#    $ ruby sandbox/test_text_more.rb


$LOAD_PATH.unshift( './lib' )
require 'sportdb/parser'


TEXT_RE = SportDb::Lexer::TEXT_RE


teams = [## try team names from at (austria)
 "Waldhausen-OÖ/G.",      # SG Waldhausen/Gloxwald (OÖ)
 "Kirschlag/Waldv.",

 "St.Oswald",
 "St.Egyden",
 "St.Andrä/W.",
 "St.Georgen/Y.",

  "Röschitz/S./R.",
  "Weissenbach/K./A.II",

  "Brunn/Wild",
 "Pleißing/W.",
 "Kirchberg/We.",
 "Natschbach-L.",
 "Hochneuk.",
 "Hüttendorf/P.",
 "Au/L.",
 "Hof/L.",
 "Brunn/Geb.II",
 "Traisen/St.Veit",
 "Hohenberg/St.Ae.",
 "Purkersdorf/P. II",
 "Klausen-L./A.",
 "Bad Vöslau/K II",
 "HW Wr. Neustadt",
 "Ad. Neustadt",
 "Poysbrunn-F./O.",
 "BW Linz/Kleinm.",
 "Ardagger/N.II",
 "LAC-Inter",
 "Purkersdorf/Pr.I",
 "Mauer-Öhling",
 "B.Fischau-Brunn",
 "Klein-Neusiedl",
 "Scheiblinkgk.II",
 "Waldhausen/NÖ",

 "1980 Wien",
 "Stein 1. FCU",
]


teams.each do |team|
  puts "==> #{team}"
  m=TEXT_RE.match( team )
  print "  "
  pp m

  if m.nil? || team != m[0]
     puts "!! team NOT matching"
  end
end


puts "bye"