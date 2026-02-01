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



###
# Minute  --  Struct.new( :m, :offset, :og, :pen )  

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
  tree = parse_matches( TEST )
  assert_equal EXP_TREE, tree
end

end # class TestParseGoals

