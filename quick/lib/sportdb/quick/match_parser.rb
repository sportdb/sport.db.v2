module SportDb

class MatchParser    ## simple match parser for team match schedules

  def self.debug=(value) @@debug = value; end
  def self.debug?() @@debug ||= false; end  ## note: default is FALSE
  def debug?()  self.class.debug?; end

  include Logging         ## e.g. logger#debug, logger#info, etc.



  def self.parse( txt, start: )
    ##   todo/check - add teams: option like start:  why? why not?
    parser = new( txt, start: start )
    parser.parse
  end

  def initialize( txt, start: )  
    @txt     = txt
    @start   = start

    @errors = []
  end


  attr_reader :errors
  def errors?() @errors.size > 0; end

  def parse
    ## note: every (new) read call - resets errors list to empty
    @errors = []
    @warns  = []    ## track list of warnings (unmatched lines)  too - why? why not?

         if debug?
           puts "lines:"
           pp @txt
         end

=begin
          t, error_messages  =  @parser.parse_with_errors( line )


           if error_messages.size > 0
              ## add to "global" error list
              ##   make a triplet tuple (file / msg / line text)
              error_messages.each do |msg|
                  @errors << [ '<file>',  ## add filename here
                               msg,
                               line
                             ]
              end
           end

           pp t   if debug?

           @tree << t
=end

     parser = RaccMatchParser.new( @txt )   ## use own parser instance (not shared) - why? why not?
     tree = parser.parse
     ## pp @tree

    ## report parse errors here - why? why not?



    ## note - team keys are names and values are "internal" stats e.g. usage count!!
    ##                      and NOT team/club/nat_team structs!!
    ## returns [@teams.keys, @matches, @rounds.values, @groups.values]
     conv = MatchTree.new( tree, start: @start )
     conv.convert
  end # method parse
end # class MatchParser
end # module SportDb

