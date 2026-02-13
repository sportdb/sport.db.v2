#####
## quick match reader for datafiles with league outlines

module SportDb
class QuickMatchReader

  def self.debug=(value) @@debug = value; end
  def self.debug?() @@debug ||= false; end  ## note: default is FALSE
  def debug?()  self.class.debug?; end



  def self.read( path )   ## use - rename to read_file or from_file etc. - why? why not?
    txt = File.open( path, 'r:utf-8' ) {|f| f.read }
    parse( txt )
  end

  def self.parse( txt )
    new( txt ).parse
  end


  include Logging

  def initialize( txt )
    @errors = []
    @txt    = txt

    @league_name = ''     
    @matches     = []
  end

  attr_reader :errors
  def errors?() @errors.size > 0; end


  ###
  #  helpers get matches & more after parse; all stored in data
  #
  ## change/rename to event - why? why not?
  ##  note - may or may not include season
  def league_name() @league_name; end
  def matches() @matches; end
  

  ##  try to find season in heading
  ##  e.g. Österr. Bundesliga 2015/16  or 2015-16
  ##       World Cup 2018 or  2018 World Cup etc.
  SEASON_IN_HEADING_RE =  %r{
                \b
              (?<season>\d{4}
                 (?:[\/-]\d{1,4})?     ## optional 2nd year in season
                 )\b
                   }x


  def parse
    ## note: every (new) read call - resets errors list to empty
    @errors = []
    
    @league_name = ''     
    @matches     = []
  

    ## note - source file MUST always start with heading 1 for now
    tree   = []
    parser = RaccMatchParser.new( @txt )   ## use own parser instance (not shared) - why? why not?
    tree = parser.parse
   

    if tree[0].is_a? RaccMatchParser::Heading1
         ## try to get league and season
         @league_name = tree[0].text
    else  
        ### report error - source MUST start with heading 1
       puts "!! (QUICK) PARSE ERROR - source MUST start with Heading1; got #{tree.size} nodes:"
       pp tree
       exit
    end

      ## todo/fix
      ##  make season optional
      m = SEASON_IN_HEADING_RE.match( @league_name )
      if m.nil?
        puts "!! (QUICK) PARSE ERROR - no season found in Heading1 >#{@league_name}; sorry"
        exit 
      end
      season = Season.parse( m[:season] )   ## convert (str) to season obj!!!
      start =  if season.year?
                  Date.new( season.start_year, 1, 1 )
                else
                  Date.new( season.start_year, 7, 1 )
                end


    ############
    ### "walk" tree to get structs (matches/teams/etc.)
    conv = MatchTree.new( tree, start: start )
    
    auto_conf_teams, matches, rounds, groups = conv.convert


      ## auto-add "upstream" errors from parser
      ## @errors += parser.errors  if parser.errors?

      if debug?
        puts ">>> #{auto_conf_teams.size} teams:"
        pp auto_conf_teams
        puts ">>> #{matches.size} matches:"
        ## pp matches
        puts ">>> #{rounds.size} rounds:"
        pp rounds
        puts ">>> #{groups.size} groups:"
        pp groups
      end


      @matches = matches
      ## note - skip teams, rounds, and groups for now
      @matches
end # method parse

end # class QuickMatchReader
end # module SportDb

