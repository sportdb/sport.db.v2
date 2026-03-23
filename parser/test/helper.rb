## minitest setup
require 'minitest/autorun'


## our own code
$LOAD_PATH.unshift( './lib' )
require 'sportdb/parser'



########
## add shortcut helpers
class Minitest::Test
  
  MatchLine = RaccMatchParser::MatchLine

  GoalLine    = RaccMatchParser::GoalLine
  Goal        = RaccMatchParser::Goal
  GoalMinute  = RaccMatchParser::GoalMinute
  Minute      = RaccMatchParser::Minute     #  Struct.new( :m, :offset )  

  BlankLine  = RaccMatchParser::BlankLine

  Heading1  = RaccMatchParser::Heading1
  Heading2  = RaccMatchParser::Heading2
  Heading3  = RaccMatchParser::Heading3

  RoundOutline  = RaccMatchParser::RoundOutline



  ### helper to flatten _2x, etc.
  def _flatten_exp( ary )
     exp = []
     ary.each do |item|
          if item.is_a?(Array)   ## e.g. _2x, etc.
            exp += item
          else
            exp << item
          end
     end
     exp
  end


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

    ## note - remove BlankLine nodes from tree!!
    ##             maybe add blank: true or such as an option
    tree = tree.reject { |node| node.is_a?(BlankLine) }


    tree   ## return parse tree
  end



  def read_n_assert_tests( path )

     tests =  read_blocktxt( path )
    
     tests.each_with_index do |(txt, exp_txt),i|


        ## skip sections w/o (without) expected parse tree
        if exp_txt.nil?
             puts "NOTE - #{path} [#{i+1}/#{tests.size}]  -  skipping test (assertions) for parse tree"
             next
        else

         ## note - (i) convert exp in text to parse tree !!
         exp_tree = eval( "[ #{exp_txt} ]" )     # note - wrap inside array!!!
         exp_tree = _flatten_exp( exp_tree )

          puts
          puts "==> #{path} [#{i+1}/#{tests.size}] parsing..."
          tree = parse_matches( txt )
    
          puts "-- #{path} [#{i+1}/#{tests.size}]  -  test (assertions) for parse tree:"
          pp exp_tree
    
          assert_equal exp_tree, tree
          puts "    OK - parse trees equal / match"
        end
     end
  end

  

  def _2x( node )  [node, node.clone];  end
  def _3x( node )  [node, node.clone, node.clone];  end
  def _4x( node )  [node, node.clone, node.clone, node.clone];  end
  def _5x( node )  [node, node.clone, node.clone, node.clone, node.clone];  end
  def _6x( node )  [node, node.clone, node.clone, node.clone, node.clone,
                         node.clone];  end
  def _7x( node )  [node, node.clone, node.clone, node.clone, node.clone,
                         node.clone, node.clone];  end
  def _8x( node )  [node, node.clone, node.clone, node.clone, node.clone,
                          node.clone, node.clone, node.clone];  end
  def _9x( node )  [node, node.clone, node.clone, node.clone, node.clone,
                          node.clone, node.clone, node.clone, node.clone];  end
  def _10x( node )  [node, node.clone, node.clone, node.clone, node.clone,
                          node.clone, node.clone, node.clone, node.clone, node.clone];  end
  def _11x( node )  [node, node.clone, node.clone, node.clone, node.clone,
                          node.clone, node.clone, node.clone, node.clone, node.clone,
                          node.clone];  end
  def _12x( node )  [node, node.clone, node.clone, node.clone, node.clone,
                          node.clone, node.clone, node.clone, node.clone, node.clone,
                          node.clone, node.clone];  end
  
end  # class Minitest::Test  


