
module SportDb
class LexerMin


###  a quick minimal lexer version
###       no goal lines, 
###       no props, etc.

MONTH_MAP = Lexer::MONTH_MAP
DAY_MAP   = Lexer::DAY_MAP

## todo/fix - add  REs here to remove Lexer:: inline!!!
##  e.g.   RE = Lexer::RE  etc.
RE               = Lexer::RE
HEADING_RE       = Lexer::HEADING_RE
ROUND_OUTLINE_RE = Lexer::ROUND_OUTLINE_RE
GEO_RE           = Lexer::GEO_RE



def log( msg )
   ## append msg to ./logs.txt
   ##     use ./errors.txt - why? why not?
   File.open( './logs.txt', 'a:utf-8' ) do |f|
     f.write( msg )
     f.write( "\n" )
   end
end




def debug?()  @debug == true; end

def initialize( lines, debug: false )
   raise ArgumentError, "(string) text expected for lexer; got #{lines.class.name}"  unless lines.is_a?(String)
  
   @debug = debug
   @txt   = lines
end



def tokenize_with_errors
    tokens_by_line = []   ## note: add tokens line-by-line (flatten later)
    errors         = []   ## keep a list of errors - why? why not?
  
    ##  preprocess automagically - why? why not?
    ##   strip lines with comments and empty lines striped / removed
    ##      keep empty lines? why? why not?
    ##      keep leading spaces (indent) - why?
    ##
    ##  note - KEEP empty lines (get turned into BLANK token!!!!)

    @txt.each_line do |line|
        ## line = line.rstrip   ## note - MUST remove/strip trailing newline (spaces optional)!!!
        line = line.strip   ## note - strip leading AND trailing whitespaces
                            ## note - trailing whitespace may incl. \n or \r\n!!!

        next if line.start_with?('#')   ###  skip comments
       
        line = line.sub( /#.*/, '' ).strip   ###  cut-off end-of line comments too
       

        more_tokens, more_errors = _tokenize_line( line )
        
        tokens_by_line  << more_tokens   
        errors          += more_errors
    end # each line


    tokens_by_line = tokens_by_line.map do |tokens|
        #############
        ## pass 1
        ##   replace all text with team token in level 1 format
        ##     note: in level 2 - text maybe  group, round or team!!! 
        tokens = tokens.map do |t|        
                    if t[0] == :TEXT
                       text = t[1]
                       t = [:TEAM, text]
                    end
                   t
                 end


        #################
        ## pass 2                  
        ##    transform tokens (using simple patterns) 
        ##      to help along the (racc look ahead 1 - LA1) parser       
        nodes = []

        buf = Tokens.new( tokens )
        ## pp buf


    loop do
          break if buf.eos?

          if buf.match?( :DATE, :TIME )   ## merge DATE TIME into DATETIME
               date = buf.next[1]
               time = buf.next[1]
               ## puts "DATETIME:"
               ## pp date, time
               val =  [date[0] + ' ' + time[0],  ## concat string of two tokens
                        { date: date[1], time: time[1] }
                      ]
               nodes << [:DATETIME, val]
          else
             ## pass through
             nodes << buf.next
          end
    end  # loop
    nodes  
  end  # map tokens_by_line



    ## flatten tokens
    tokens = []
    tokens_by_line.each do |tok|

         if debug?
           pp tok
         end

         tokens  += tok 
         ## auto-add newlines  (unless BLANK!!)
         tokens  << [:NEWLINE, "\n"]   unless tok[0][0] == :BLANK
    end

    [tokens,errors]
end   # method tokenize_with_errors



 

def _tokenize_line( line )
  tokens = []
  errors = []   ## keep a list of errors - why? why not?

  puts "line: >#{line}<"    if debug?

  ### special case for empty line (aka BLANK)
  if line.empty?
       ## note - blank always resets parser mode to std/top-level!!!
      @re = RE

      tokens << [:BLANK, '<|BLANK|>']
      return [tokens, errors]
  end


  pos = 0
  ## track last offsets - to report error on no match
  ##   or no match in end of string
  offsets = [0,0]
  m = nil


  ####
  ## quick hack - keep re state/mode between tokenize calls!!!
  @re  ||= RE     ## note - switch between RE & INSIDE_RE


  if @re == RE  ## top-level
    ### check for modes once (per line) here to speed-up parsing
    ###   for now goals only possible for start of line!!
    ###        fix - remove optional [] - why? why not?  
  
    if (m = HEADING_RE.match(line))
      puts "   HEADING"  if debug?
      ## note - derive heading level from no of (leading) markers
      ##             e.g. = is 1, == is 2, == is 3, etc.
      heading_level = m[:heading_marker].size 
      tokens << [:"H#{heading_level}", m[:heading]]

      ## note - eats-up line for now (change later to only eat-up marker e.g. »|>>)
      offsets = [m.begin(0), m.end(0)]
      pos = offsets[1]    ## update pos
    elsif (m = ROUND_OUTLINE_RE.match( line ))
      puts "   ROUND_OUTLINE"  if debug?

      tokens << [:ROUND_OUTLINE, m[:round_outline]]

      ## note - eats-up line for now (change later to only eat-up marker e.g. »|>>)
      offsets = [m.begin(0), m.end(0)]
      pos = offsets[1]    ## update pos
    end
  end



  old_pos = -1   ## allows to backtrack to old pos (used in geo)

  while m = @re.match( line, pos )
    # if debug?
    #  pp m
    #  puts "pos: #{pos}"
    # end
    offsets = [m.begin(0), m.end(0)]

    if offsets[0] != pos
      ## match NOT starting at start/begin position!!!
      ##  report parse error!!!
      msg =  "!! WARN - parse error (tokenize) - skipping >#{line[pos..(offsets[0]-1)]}< @#{offsets[0]},#{offsets[1]} in line >#{line}<"
      puts msg

      errors << "parse error (tokenize) - skipping >#{line[pos..(offsets[0]-1)]}< @#{offsets[0]},#{offsets[1]} in line >#{line}<"
      log( msg )
    end


    ##
    ## todo/fix - also check if possible
    ##   if no match but not yet end off string!!!!
    ##    report skipped text run too!!!

    old_pos = pos
    pos     = offsets[1]

#    pp offsets   if debug?

    ##
    ## note: racc requires pairs e.g. [:TOKEN, VAL]
    ##         for VAL use "text" or ["text", { opts }]  array

  t = if @re == GEO_RE
         ### note - possibly end inline geo on [ (and others?? in the future
         if m[:space] || m[:spaces]
            nil    ## skip space(s)
         elsif m[:text]
            [:GEO, m[:text]]   ## keep pos - why? why not?
         elsif m[:timezone]
            [:TIMEZONE, m[:timezone]]
         elsif m[:sym]
            sym = m[:sym]
            ## return symbols "inline" as is - why? why not?
            ## (?<sym>[;,@|\[\]-])
   
            case sym
            when ',' then [:',']
            when '›' then [:',']  ## note - treat geo sep › (unicode) like comma for now!!!
            when '>' then [:',']  ## note - treat geo sep > (ascii) like comma for now!!!
            when '[' then
                 ## get out-off geo mode and backtrack (w/ next)
                 puts "  LEAVE GEO_RE MODE, BACK TO TOP_LEVEL/RE"  if debug?
                 @re = RE
                 pos = old_pos
                 next   ## backtrack (resume new loop step)                 
            else
              puts "!!! TOKENIZE ERROR (sym) - ignore sym >#{sym}<"
              nil  ## ignore others (e.g. brackets [])
            end
          elsif m[:any]
             ## todo/check log error
             msg = "parse error (tokenize geo) - skipping any match>#{m[:any]}< @#{offsets[0]},#{offsets[1]} in line >#{line}<"
             puts "!! WARN - #{msg}"
  
             errors << msg
             log( "!! WARN - #{msg}" )
       
             nil   
          else
            ## report error/raise expection
             puts "!!! TOKENIZE ERROR - no match found"
             nil 
          end
      ###################################################
      ## assume TOP_LEVEL (a.k.a. RE) machinery
      else  
        if m[:space] || m[:spaces]
           nil   ## skip space(s)
        elsif m[:text]
          [:TEXT, m[:text]]   ## keep pos - why? why not?
        elsif m[:status]   ## (match) status e.g. cancelled, awarded, etc.
          ## todo/check - add text (or status) 
          #     to opts hash {} by default (for value)
          if m[:status_note]   ## includes note? e.g.  awarded; originally 2-0
             [:STATUS, [m[:status], {status: m[:status], 
                                     note:   m[:status_note]} ]]
          else
             [:STATUS, [m[:status], {status: m[:status] } ]]
          end
        elsif m[:note]
            ###  todo/check:
            ##      use value hash - why? why not? or simplify to:
            ## [:NOTE, [m[:note], {note: m[:note] } ]]
             [:NOTE, m[:note]] 
        elsif m[:score_note]
             [:SCORE_NOTE, m[:score_note]]
        elsif m[:time]
              ## unify to iso-format
              ###   12.40 => 12:40
              ##    12h40 => 12:40 etc.
              ##  keep string (no time-only type in ruby)
              hour =   m[:hour].to_i(10)  ## allow 08/07/etc.
              minute = m[:minute].to_i(10)
              ## check if valid -  0:00 - 24:00
              ##   check if 24:00 possible? or only 0:00 (23:59)
              if (hour >= 0 && hour <= 24) &&
                 (minute >=0 && minute <= 59)
               ## note - for debugging keep (pass along) "literal" time
               ##   might use/add support for am/pm later
               [:TIME, [m[:time], {h:hour,m:minute}]]
              else
                 raise ArgumentError, "parse error - time >#{m[:time]}< out-of-range"
              end
        elsif m[:date]
            date = {}
 ## map month names
 ## note - allow any/upcase JULY/JUL etc. thus ALWAYS downcase for lookup
            date[:y]  = m[:year].to_i(10)  if m[:year]
            ## check - use y too for two-digit year or keep separate - why? why not?
            date[:yy] = m[:yy].to_i(10)    if m[:yy]    ## two digit year (e.g. 25 or 78 etc.)
            date[:m] = m[:month].to_i(10)  if m[:month]
            date[:m] = MONTH_MAP[ m[:month_name].downcase ]   if m[:month_name]
            date[:d]  = m[:day].to_i(10)   if m[:day]
            date[:wday] = DAY_MAP[ m[:day_name].downcase ]   if m[:day_name]
            ## note - for debugging keep (pass along) "literal" date
            [:DATE, [m[:date], date]]
        elsif m[:wday]    ## standalone weekday e.g. Mo/Tu/We/etc.
             [:WDAY, [m[:wday], { wday: DAY_MAP[ m[:day_name].downcase ] } ]]
        elsif m[:num]   ## fix - change to ord (for ordinal number!!!)
              ## note -  strip enclosing () and convert to integer
             [:ORD, [m[:num], { value: m[:value].to_i(10) } ]]
        elsif m[:score_more]
              score = {}
              ## check for pen
              score[:p] = [m[:p1].to_i(10),
                           m[:p2].to_i(10)]  if m[:p1] && m[:p2]
              score[:et] = [m[:et1].to_i(10),
                            m[:et2].to_i(10)]  if m[:et1] && m[:et2]
              score[:ft] = [m[:ft1].to_i(10),
                            m[:ft2].to_i(10)]  if m[:ft1] && m[:ft2]
              score[:ht] = [m[:ht1].to_i(10),
                            m[:ht2].to_i(10)]  if m[:ht1] && m[:ht2]

            ## note - for debugging keep (pass along) "literal" score
            [:SCORE_MORE, [m[:score_more], score]]
        elsif m[:score]
            score = {}
            ## must always have ft for now e.g. 1-1 or such
            ###  change to (generic) score from ft -
            ##     might be score a.e.t. or such - why? why not?
            score[:ft] = [m[:ft1].to_i(10),
                          m[:ft2].to_i(10)]  
          ## note - for debugging keep (pass along) "literal" score
          [:SCORE, [m[:score], score]]
        elsif m[:vs]
           [:VS, m[:vs]]
        elsif m[:sym]
          sym = m[:sym]
          ## return symbols "inline" as is - why? why not?
          ## (?<sym>[;,@|\[\]-])
 
          case sym
          when '@'    ##  enter geo mode
            puts "  ENTER GEO_RE MODE"  if debug?
            @re = GEO_RE
            [:'@']
          when ',' then [:',']
          when ';' then [:';']
          when '/' then [:'/']
          when '|' then [:'|']
          when '[' then [:'[']
          when ']' then [:']']
          when '-' then [:'-']        # level 1 OR (classic) dash
          when '--'   then [:'--']    # level 2
          when '---'  then [:'---']   # level 3
          when '----' then [:'----']  # level 4
          else
            puts "!!! TOKENIZE ERROR (sym) - ignore sym >#{sym}<"
            nil  ## ignore others (e.g. brackets [])
          end
        elsif m[:any]
           ## todo/check log error
           msg = "parse error (tokenize) - skipping any match>#{m[:any]}< @#{offsets[0]},#{offsets[1]} in line >#{line}<"
           puts "!! WARN - #{msg}"

           errors << msg
           log( "!! WARN - #{msg}" )
     
           nil   
        else
          ## report error
           puts "!!! TOKENIZE ERROR - no match found"
           nil 
        end
      end


    tokens << t    if t

#    if debug?
#      print ">"
#      print "*" * pos
#      puts "#{line[pos..-1]}<"
#    end
  end

  ## check if no match in end of string
  if offsets[1] != line.size
    msg =  "!! WARN - parse error - skipping >#{line[offsets[1]..-1]}< @#{offsets[1]},#{line.size} in line >#{line}<"
    puts msg
    log( msg )

    errors << "parse error (tokenize) - skipping >#{line[offsets[1]..-1]}< @#{offsets[1]},#{line.size} in line >#{line}<"
  end

 
   if @re == GEO_RE   ### ALWAYS switch back to top level mode
     puts "  LEAVE GEO_RE MODE, BACK TO TOP_LEVEL/RE"  if debug?
     @re = RE 
   end

  
  [tokens,errors]
end

end  # class LexerMin
end # module SportDb
