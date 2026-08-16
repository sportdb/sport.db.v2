
module Fbtxt

class LexerResult
   attr_reader :tokens, :errors
   def initialize( tokens, errors=[] )
       @tokens, @errors = tokens, errors
   end

   def ok?()  @errors.size == 0; end
   def nok?() !ok?; end
end  # class LexerResult



class Lexer
  include Debuggable     ## auto-adds debug?, _trace, _info, etc.


def initialize( txt )
   raise ArgumentError, "text as string expected for lexer; got #{txt.class}"  unless txt.is_a?(String)

   @txt   = txt
end



##
##  check if lexer is in prop(erty) mode
##      note - property lines auto-continue
##     and break on blank or another property line
##     note - follow-up line/match  MUST
##        add  PROP_END token to last line!!!
def is_prop_cont?    ## use prop_mode? or such - why? why not?
   @re == PROP_LINEUP_RE     ||
   @re == PROP_CARDS_RE      ||
   @re == PROP_PENALTIES_RE  ||
   @re == PROP_ATTENDANCE_RE ||
   @re == PROP_REFEREE_RE    ||
   @re == PROP_COACH_RE
end

##
##  auto-continue
##    ends on closing-parenthesis `)`
def is_goal_cont?
   @re == GOAL_RE          ||
   @re == GOAL_ALT_RE      ||
   @re == GOAL_COMPAT_RE
end




def tokenize_with_errors( flatten: true )

    tokens_by_line = []   ## note: add tokens line-by-line (flatten later)
    errors         = []   ## keep a list of errors - why? why not?


    txt = _prep_doc( @txt )



    ####
    ## quick hack - keep re state/mode between tokenize calls!!!
    @re  ||= RE     ## note - switch between RE & INSIDE_RE

    lineno = 0
    txt.each_line do |line|
        lineno += 1

        ## todo - "inlined virtual/collapsed/folded newlines"
        ##   check for "↵" !!!
        ##   and add to lineno


        ## note - KEEP leading spaces for indent
        ##         use rstrip (NOT left/leading & right/trainling strip) only!!
        ## note -   remove/strip trailing newline (and optional spaces)!!!
        ##          trailing whitespace may incl. \n or \r\n!!!
        line = line.rstrip


        ###  skip comments
        ##      todo/check - change to blank line
        ##                     to keep lineno (closer to orginal) - why? why not?
        next  if line.match?(/\A  [ ]* ## optional leading space(s)
                                   \#
                                    /x )

        ##  strip (inline) end-of-line comments (from line)
        ##    check/discuss: make - inline comment require trailing space
        ##                      e.g.   #1 vs # 1   - why? why not?
        line = line.sub( /   [ ]*      ## (eat-up) optional leading space(s) too - why? why not?
                              \#{1,}.*?
                             \z
                            /x, '' )


        #  support __END__ marker to cut-off input
        break if line.match?( /\A [ ]*   ## optional leading space(s)
                                   __END__
                                 \z
                               /x )



        ## auto-fixes line-by-line (e.g. check for tabs, smart quotes, etc.)
        line = _prep_line( line )


        _trace( "line #{lineno}: >#{line}<" )


        ######
        ### special case for empty line (aka BLANK)
        if line.empty?
            ## finish prop (if in prop mode)
            tokens_by_line[-1] << Token.virtual(:PROP_END)   if is_prop_cont?

           ## note - blank always resets parser mode to std/top-level!!!
           @re = RE
           tokens_by_line << [Token.virtual(:BLANK, lineno: lineno)]
        elsif (m = HEADING_RE.match(line))
            ## finish prop (if in prop mode)
            tokens_by_line[-1] << Token.virtual(:PROP_END)   if is_prop_cont?

           ## note - heading always resets parser mode to std/top-level!!!
           @re = RE
           _trace( 'HEADING' )
           ## note - derive heading level from no of (leading) markers
           ##             e.g. = is 1, == is 2, == is 3, etc.
           heading_level = m[:heading_marker].size
           tokens_by_line << [Token.new(:"H#{heading_level}", m[:heading], lineno: lineno)]
        elsif (m = NOTA_BENE_RE.match(line))
            ## finish prop (if in prop mode)
            tokens_by_line[-1] << Token.virtual(:PROP_END)   if is_prop_cont?

           ## note - nota bene always resets parser mode to std/top-level!!!
           @re = RE
           tokens_by_line << [Token.new(:NOTA_BENE, m[:nota_bene], lineno: lineno)]
        else

         ## finish prop (if in prop mode) and new prop upcoming!!
         ##
         ##   todo/fix-fix-fix -  add check for and track identation (left-side)
         ##      (i) break if identation is same or less!!!
         ##      (ii) handle "sub" properties too
         if is_prop_cont? && (m = START_WITH_PROP_KEY_RE.match( line ))
            _trace( "LEAVE PROP_RE MODE, BACK TO TOP_LEVEL/RE" )
            @re = RE
            tokens_by_line[-1] << Token.virtual(:PROP_END)
         end

          more_tokens, more_errors = _tokenize_line( line, lineno )

          tokens_by_line  << more_tokens
          errors          += more_errors
        end


        ## output last line from tokens by line in debug mode
        _trace( "  #{tokens_by_line[-1].size} token(s): " + tokens_by_line[-1].pretty_inspect )

    end # each line

    ## finish prop (if in prop mode)
    tokens_by_line[-1] << Token.virtual(:PROP_END)  if is_prop_cont?


    ## note - always switch back to top-level at the end
    @re = RE


   #################
   ##    transform (normalize) tokens (using simple patterns)
   ##      to help along the (racc look ahead 1 - LA1) parser
   tokens_by_line = normalize_tokens( tokens_by_line )
    ## puts "tokens_by_line:"
    ## pp tokens_by_line



    ## flatten tokens
    ##    check - simple use tokens_by_line.flatten - why? why not?
    ##      tip: use flatten(1) !! - flattens exactly one level deep (only)
    if flatten
      tokens = []
      tokens_by_line.each do |tok_line|
         tokens += tok_line
      end

      [tokens,errors]
   else
      [tokens_by_line, errors]
   end
end   # method tokenize


end  # class Lexer
end # module Fbtxt
