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



  ### helper to flatten _2x, etc.
  def self._flatten_exp( ary )
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



  def self.parse_tests( txt )

     tests = []   ## note - holds [txt,exp] pairs


    ##
    #  quick support for  __END__
     txt = txt.sub( %r{ ^
                          [ ]* __END__ [ ]*
                            .*?
                         \z   ## note - until end-of-string/file !!!
                      }mx, 
                     '' )

      
    ## split by "---"
    sections = txt.split(   %r{^
                                 [ ]* --- [ ]*
                              $}x )

 
    sections.each_with_index do |sect,i|
       ## puts ">>> start #{i+1}"
       ## pp sect
       ## puts "<<< end #{i+1}"

      ## split by "  => "
      txt, exp = sect.split( %r{^
                                [ ]* => [ ]*
                              $}x )

      ## puts
      ## puts "txt:"
      ## pp txt
      ## puts "=>"
      ## puts "exp:"
      ## pp exp
      exp = eval( "[ #{exp} ]" )     # note - wrap inside array!!!
      exp = _flatten_exp( exp )
      ## pp exp
  
      tests << [txt,exp]
    end
    tests
  end

  def self.read_tests( path ) parse_tests( read_text( path )); end  



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
     tests = self.class.read_tests( path )
     tests.each do |txt, exp_tree|
        tree = parse_matches( txt )
        assert_equal exp_tree, tree
     end
  end

  

  def self._2x( node )  [node, node.clone];  end
  def self._3x( node )  [node, node.clone, node.clone];  end
  def self._4x( node )  [node, node.clone, node.clone, node.clone];  end
  def self._5x( node )  [node, node.clone, node.clone, node.clone, node.clone];  end
  def self._6x( node )  [node, node.clone, node.clone, node.clone, node.clone,
                         node.clone];  end
  def self._7x( node )  [node, node.clone, node.clone, node.clone, node.clone,
                         node.clone, node.clone];  end
  def self._8x( node )  [node, node.clone, node.clone, node.clone, node.clone,
                          node.clone, node.clone, node.clone];  end
  def self._9x( node )  [node, node.clone, node.clone, node.clone, node.clone,
                          node.clone, node.clone, node.clone, node.clone];  end
  def self._10x( node )  [node, node.clone, node.clone, node.clone, node.clone,
                          node.clone, node.clone, node.clone, node.clone, node.clone];  end
  def self._11x( node )  [node, node.clone, node.clone, node.clone, node.clone,
                          node.clone, node.clone, node.clone, node.clone, node.clone,
                          node.clone];  end
  def self._12x( node )  [node, node.clone, node.clone, node.clone, node.clone,
                          node.clone, node.clone, node.clone, node.clone, node.clone,
                          node.clone, node.clone];  end
  
end  # class Minitest::Test  


