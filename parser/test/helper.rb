## minitest setup
require 'minitest/autorun'


## our own code
$LOAD_PATH.unshift( './lib' )
require 'sportdb/parser'



########
## add shortcut helpers
class Minitest::Test
  
  MatchLine = RaccMatchParser::MatchLine

  GoalLine  = RaccMatchParser::GoalLine
  Goal      = RaccMatchParser::Goal
  Minute    = RaccMatchParser::Minute     #  Struct.new( :m, :offset, :og, :pen )  


  def parse_matches( txt )
    parser = RaccMatchParser.new( txt, debug: true )
    tree = parser.parse
    pp tree

    if parser.errors?
      puts "-- #{parser.errors.size} parse error(s):"
      pp parser.errors
    else
      puts "--  OK - no parse errors found"
    end
    
    tree   ## return parse tree
  end


  
end  # class Minitest::Test  


