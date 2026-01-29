###
#  to run use
#     ruby test/test_parse_goals.rb


require_relative 'helper'

class TestParseGoals < Minitest::Test

TEST = <<-TXT

  (Batshuayi 90')
  (Batshuayi 90)

  (R. Lukaku 16' Batshuayi 90')          
  (R. Lukaku 16 Batshuayi 90)          
  (R. Lukaku 16, Batshuayi 90)          
  (R. Lukaku 16, 
   Batshuayi 90)          

  (R. Lukaku 45'+3 Batshuayi 90')          
  (R. Lukaku 45+3 Batshuayi 90)          
  (R. Lukaku 45+3, Batshuayi 90)          
  (R. Lukaku 45+3, 
   Batshuayi 90)          
   
TXT


MatchLine = RaccMatchParser::MatchLine

GoalLine  = RaccMatchParser::GoalLine
Goal      = RaccMatchParser::Goal
Minute    = RaccMatchParser::Minute     #  Struct.new( :m, :offset, :og, :pen )  



EXP_TREE = [
   GoalLine.new( goals1: [Goal.new( player: 'Batshuayi', minutes: [Minute.new(m:90)])],
                 goals2: []),
   GoalLine.new( goals1: [Goal.new( player: 'Batshuayi', minutes: [Minute.new(m:90)])],
                 goals2: []),

    GoalLine.new( goals1: [Goal.new( player: 'R. Lukaku', minutes: [Minute.new(m:16)]),
                           Goal.new( player: 'Batshuayi', minutes: [Minute.new(m:90)])],
                  goals2: []),
    GoalLine.new( goals1: [Goal.new( player: 'R. Lukaku', minutes: [Minute.new(m:16)]),
                           Goal.new( player: 'Batshuayi', minutes: [Minute.new(m:90)])],
                  goals2: []),
    GoalLine.new( goals1: [Goal.new( player: 'R. Lukaku', minutes: [Minute.new(m:16)]),
                           Goal.new( player: 'Batshuayi', minutes: [Minute.new(m:90)])],
                  goals2: []),
    GoalLine.new( goals1: [Goal.new( player: 'R. Lukaku', minutes: [Minute.new(m:16)]),
                           Goal.new( player: 'Batshuayi', minutes: [Minute.new(m:90)])],
                  goals2: []),

    GoalLine.new( goals1: [Goal.new( player: 'R. Lukaku', minutes: [Minute.new(m:45,offset:3)]),
                           Goal.new( player: 'Batshuayi', minutes: [Minute.new(m:90)])],
                  goals2: []),
    GoalLine.new( goals1: [Goal.new( player: 'R. Lukaku', minutes: [Minute.new(m:45,offset:3)]),
                           Goal.new( player: 'Batshuayi', minutes: [Minute.new(m:90)])],
                  goals2: []),
    GoalLine.new( goals1: [Goal.new( player: 'R. Lukaku', minutes: [Minute.new(m:45,offset:3)]),
                           Goal.new( player: 'Batshuayi', minutes: [Minute.new(m:90)])],
                  goals2: []),
    GoalLine.new( goals1: [Goal.new( player: 'R. Lukaku', minutes: [Minute.new(m:45,offset:3)]),
                           Goal.new( player: 'Batshuayi', minutes: [Minute.new(m:90)])],
                  goals2: []),
]


def test_parse
  parser = RaccMatchParser.new( TEST, debug: true )
  tree = parser.parse
  pp tree

  if parser.errors?
    puts "-- #{parser.errors.size} parse error(s):"
    pp parser.errors
  else
    puts "--  OK - no parse errors found"
  end

  assert_equal EXP_TREE, tree
end

end # class TestParseGoals


__END__

>,
 <GoalLine goals1=[R. Lukaku 16' 45'+3, Batshuayi 90']
, goals2=[]
>,
 <GoalLine goals1=[R. Lukaku 16' 45'+3, Batshuayi 90']
, goals2=[]
>,
 <GoalLine goals1=[E. Hazard 6' (pen) 51', R. Lukaku 16' 45'+3, Batshuayi 90']
, goals2=[Bronn 18', Khazri 90'+3]
>,
 <GoalLine goals1=[E. Hazard 6' (pen) 51', R. Lukaku 16' 45'+3, Batshuayi 90']
, goals2=[Bronn 18', Khazri 90'+3]
>,
 <GoalLine goals1=[E. Hazard 6' (pen) 51', R. Lukaku 16' 45'+3, Batshuayi 90']
, goals2=[Bronn 18', Khazri 90'+3]
>,
 <GoalLine goals1=[E. Hazard 6' (pen) 51', R. Lukaku 16' 45'+3, Batshuayi 90']
, goals2=[Bronn 18', Khazri 90'+3]
>,
 <GoalLine goals1=[E. Hazard 6' (pen) 51', R. Lukaku 16' 45'+3, Batshuayi 90']
, goals2=[Bronn 18', Khazri 90'+3]
>,
 <GoalLine goals1=[R. Lukaku 16', Batshuayi 90']
, goals2=[]
>,
 <GoalLine goals1=[R. Lukaku 16' 45'+3, Batshuayi 90']
, goals2=[]
>,
 <GoalLine goals1=[E. Hazard 6' (pen) 51', R. Lukaku 16' 45'+3, Batshuayi 90']
, goals2=[Bronn 18', Khazri 90'+3]
>,
 <GoalLine goals1=[E. Hazard, R. Lukaku, Batshuayi]
, goals2=[Bronn, Khazri]
>,
 <GoalLine goals1=[R. Lukaku, Batshuayi]
, goals2=[]
>,