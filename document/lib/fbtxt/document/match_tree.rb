module Fbtxt


##############################
## simple (match) parse tree to structs walker/handler/converter
class MatchTree
  include Debuggable


  include Models      ## e.g. Fbtxt::Model(s)
                      ##      Match,Round,Group,Goal,etc.


  ##
  ##  note: allow start(_date) nil
  ##          if in use (start: nil) years expected on first date!!!

  def initialize( tree, start: nil )
    @tree    = tree
    @start   = start

    @errors = []
  end

  attr_reader :errors
  def errors?() @errors.size > 0; end



  def convert
    ## note: every (new) read call - resets errors list to empty
    @errors = []
    @warns  = []    ## track list of warnings (unmatched lines)  too - why? why not?

    ### todo/fix - FIX/FIX
    ##     check start year from first date
    ##    for now (auto-)update - @start with every date that incl. a year!!!
    @last_year    = nil
    @last_date    = nil
    @last_time    = nil

    ## todo/fix - use stack push/pop in the future - why? why not?
    @last_round   = nil  ##  merge - "top-level" - Round struct
    @last_round_name1  = nil  ## level 1 - string
    @last_round_name2  = nil  ## level 2 - string
    @last_round_name3  = nil  ## level 3 - string

    @last_group   = nil


    @teams   = Hash.new(0)   ## track counts (only) for now for (interal) team stats - why? why not?
    @rounds  = {}
    @groups  = {}
    @matches = []


    @tree.each do |node|
       if node.is_a? RaccMatchParser::RoundDef
        ## todo/fix:  add round definition (w begin n end date)
        ## todo: do not patch rounds with definition (already assume begin/end date is good)
        ##  -- how to deal with matches that get rescheduled/postponed?
          on_round_def( node )
        elsif node.is_a? RaccMatchParser::GroupDef  ## NB: group goes after round (round may contain group marker too)
        ### todo: add pipe (|) marker (required)
          on_group_def( node )
      elsif node.is_a? RaccMatchParser::RoundOutline
          on_round_outline( node )
      elsif node.is_a? RaccMatchParser::DateHeader
          on_date_header( node )
      elsif node.is_a? RaccMatchParser::MatchLine
          on_match_line( node )
      elsif node.is_a? RaccMatchParser::MatchLineBye
          on_match_line_bye( node )
      elsif node.is_a? RaccMatchParser::GoalLine
          on_goal_line( node )
      elsif node.is_a? RaccMatchParser::PenaltiesLine
           on_penalties( node )
      elsif node.is_a? RaccMatchParser::LineupLine
          on_lineup_line( node )
      elsif node.is_a? RaccMatchParser::CardsLine
          on_cards_line( node )
      elsif node.is_a? RaccMatchParser::RefereeLine
           on_referee_line( node )
      elsif node.is_a?( RaccMatchParser::Heading1 ) ||
            node.is_a?( RaccMatchParser::Heading2 ) ||
            node.is_a?( RaccMatchParser::Heading3 )
          ###  skip headings (1/2/3) for now
      elsif node.is_a? RaccMatchParser::BlankLine
          ### skip for now; do nothing
      else
        ## report error
        msg = "!! WARN - unknown node (parse tree type) - #{node.class.name}"
        puts msg
        pp node

        log( msg )
        log( node.pretty_inspect )
      end
    end  # tree.each

    ## note - team keys are names and values are "internal" stats e.g. usage count!!
    ##                      and NOT team/club/nat_team structs!!
    [@teams.keys, @matches, @rounds.values, @groups.values]
  end # method convert


end # class MatchTree
end # module Fbtxt
