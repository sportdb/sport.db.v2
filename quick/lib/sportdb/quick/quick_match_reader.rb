
module Fbtxt
class Document
   include Debuggable


def self.read( path )
  ##  note - use read_text from cocos - why? why not?
  txt = read_text( path )
  parse( txt )
end

def self.parse( txt )
    new( txt )
end




  attr_reader :title    ## e.g.  league name (England | Premier League 2026/27) or such
  attr_reader :matches

  attr_reader :teams
  attr_reader :groups
  attr_reader :rounds

  attr_reader :errors
  def errors?() @errors.size > 0; end

  ##
  ##  keep/store a reference to (source) txt - why? why not?
  def initialize( txt, start: nil )
    _parse( txt, start: start )
  end



  ##  try to find season in heading
  ##  e.g. Österr. Bundesliga 2015/16  or 2015-16
  ##       World Cup 2018 or  2018 World Cup etc.
  SEASON_IN_HEADING_RE =  %r{
                  \b
              (?<season>
                  \d{4}
                 (?: [\/-]
                     \d{1,4} )?       ## optional 2nd year in season
                )
                  \b
              }x


  def _parse( txt, start: nil )
    ## note: every (new) read call - resets errors list to empty
    @title   = nil     ## or use '? or use '' - why? why not?
    @matches = []

    @teams   = []
    @groups  = []
    @rounds  = []

    @errors  = []


    parser = SportDb::Parser.new( txt )   ## use own parser instance (not shared) - why? why not?
    tree, errors = parser.parse_with_errors

    @errors = errors

## note - source file MUST always start with heading 1 for now

##
## !! (QUICK) PARSE ERROR - source MUST start with Heading1; got 34 nodes:
## [<BlankLine>,
##  <BlankLine>,
## <Heading1 World Cup 1930>,

      ## remove leading BlankLines if any!!
      while tree[0].is_a? RaccMatchParser::BlankLine
          tree.shift  ## remove (leading) blank line from parse tree
      end


    ## try to get league and season
    if tree[0].is_a? RaccMatchParser::Heading1
         @title = tree[0].text

         if (m = SEASON_IN_HEADING_RE.match( @title ))
           season = Season.parse( m[:season] )   ## convert (str) to season obj!!!
           start = if season.year?
                     Date.new( season.start_year, 1, 1 )
                   else
                     Date.new( season.start_year, 7, 1 )
                   end
         else
           puts "!! (DOCUMENT) WARN - no season found in Heading1 >#{@title}<"
         end
    else
        ### report error - source MUST start with heading 1
       puts "!! (DOCUMENT) WARN - source SHOULD start with Heading1; got #{tree.size} nodes:"
       pp tree
    end



    ############
    ### "walk" tree to get structs (matches/teams/etc.)
    conv = SportDb::MatchTree.new( tree, start: start )

    teams, matches, rounds, groups = conv.convert


      ## auto-add "upstream" errors from parser
      ## @errors += parser.errors  if parser.errors?

      if debug?
        puts ">>> #{teams.size} teams:"
        pp teams
        puts ">>> #{groups.size} groups:"
        pp groups
        puts ">>> #{rounds.size} rounds:"
        pp rounds
        puts ">>> #{matches.size} matches:"
        ## pp matches
      end


      @matches = matches

      @teams    = teams
      @groups   = groups
      @rounds   = rounds

      self
end # method _parse

end # class Document
end # module Fbtxt
