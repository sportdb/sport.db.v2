####
#  to run use:
#    $ ruby sandbox/test_goal_counts.rb


$LOAD_PATH.unshift( './lib' )
require 'sportdb/parser'




txt =<<TXT


NB: Wales, Poland and Portugal qualified

NB: 5th placed team qualify for playoff against AFC 5th placed team (Australia)

NB: Senegal, Cameroon, Ghana, Morocco and Tunisia qualified


NB: the first stage also served as qualifying stage for the 2023 Asian Cup
     (with the losers being eliminated)

NB: the second stage also served as qualifying stage for the 2023 Asian Cup
    (with the group winners and five best runners-up qualifying for the final tournament and the
    other teams entering the qualifying tournament at various stages (remaining runners-up, third
    placed teams, fourth placed teams and three best fifth placed teams at group stage, 
    the others entering a playoff round)


NB: annulled results against North Korea between square brackets  

TXT


  txt.gsub( SportDb::Lexer::PREPROC_NOTA_BENE_RE ) do |m| 
    puts "!! match:"
    puts m
    m = m.gsub( "\n", '↵' )
    puts m

    m
  end


puts "bye"