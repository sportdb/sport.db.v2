
module SportDb
class Lexer



def log( msg )
   ## append msg to ./logs.txt
   ##     use ./errors.txt - why? why not?
   File.open( './logs.txt', 'a:utf-8' ) do |f|
     f.write( msg )
     f.write( "\n" )
   end
end


  ###
  ##  todo/fix -   use LangHelper or such
  ##   e.g.     class Lexer
  ##                include LangHelper
  ##            end
  ##
  ##  merge back Lang into Lexer - why? why not?
  ## keep "old" access to checking for group, round & friends
  ##    for now for compatibility
  def is_group?( text )  Lang.is_group?( text ); end
  def is_round?( text )  Lang.is_round?( text ); end
  



def debug?()  @debug == true; end

def initialize( lines, debug: false )
   raise ArgumentError, "(string) text expected for lexer; got #{lines.class.name}"  unless lines.is_a?(String)
  
   @debug = debug
   @txt   = lines
end


HTML_COMMENT_RE = %r{  <!--
                            .*?   ## note - use non-greedy/lazy *? match
                         --> 
                       }xm      ## note - turn on multi-line match (for dot (.))


##
##  note - [] block may NOT incl. square brackets
##       what about comments (e.g. #)?                       
##    todo/check - rename to NOTE_BLOCK or TEXT_BLOCK or ??? 
PREPROC_BLOCK_RE = %r{  \[
                      [^\[\]\#]*?  ## note - use non-greedy/lazy *? match
                  \]
                        }xm  ## note - turn on multi-line match (for dot(.))


##
## check for "literal"  (multi-line) note blocks
##   eg.  nb:  or note:          
##   space required after double colon - why? why not?              
PREPROC_NOTA_BENE_RE = %r{
         ^  
    [ ]* (?: nb | note) [ ]* : [ ]+
       .+?  ## non-greedy 
   
    ## positive lookahead
    ##    note - must end with blank line or end-of-file/document   
      (?=  \n[ ]*\n | \z )   
}xim

##  
##  replace "escaped" newline with non-newline char e.g. '↵'
LINE_CONTINUATION_RE = %r{
                           \\[ ]* \n
                        }x


def tokenize_with_errors
    tokens_by_line = []   ## note: add tokens line-by-line (flatten later)
    errors         = []   ## keep a list of errors - why? why not?
  
   ##  preprocess automagically - why? why not?
    ##   strip lines with comments and empty lines striped / removed
    ##      keep empty lines? why? why not?
    ##      keep leading spaces (indent) - why?
    ##
    ##  note - KEEP empty lines (get turned into BLANK token!!!!)


    ###
    ## quick hack for now
    ##   remove  html-style comments <!-- -->
    ##           (incl. multi-line)  with two spaces
    ##       will mess-up lineno tracking!!!
    ##    fix later to have function lineno & colno!!!
    txt = @txt.gsub( HTML_COMMENT_RE ) do |m|
                        puts " [debug] preproc html comment:"
                        puts m
                        '  ' 
                   end
    ###
    ## add more "native" multi-line comment-styles
    ##  e.g.    #[[ ... ]]  or  #<<< .. >>> or #<< .. >>
    ##                 or such - why? why not?


   txt = txt.gsub( PREPROC_NOTA_BENE_RE ) do |m|
       if m.include?( "\n" )   ## check for newlines (\n) and replace
         puts " [debug] preproc (multi-line) note/nota bene block:"
         puts m
         ## todo/check: replace with two spaces insead of ↵ - why? why not?
         m.gsub( "\n", '↵' )
       else
         m 
       end 
    end



   ##
   ## e.g. used in (multi-line) TableNote  
   ##  1.SOUTH KOREA   6  5  1  0 22- 1 16  [0-0]
   ##  2.LEBANON       6  3  1  2 11- 8 10  [0-2, 0-0]
   ##  3.Turkmenistan  6  3  0  3  8-11  9  [3-1]
   ##  4.Sri Lanka     6  0  0  6  2-23  0  [0-1]
   ##  -.North Korea   withdrew after playing 5 matches due to safety concerns in \
   ##                  connection with the Covid-19 pandemic; all results annulled

   txt = txt.gsub( LINE_CONTINUATION_RE ) do |_|
            puts " [debug] preproc line continuation"
              ## todo/check: replace with two spaces insead of ↵ - why? why not?
               '↵' 
         end 



    #####
    ## (another) quick hack for now
    ##   turn multi-line note blocks into 
    ##             single-line note blocks
    ##             by changing newline (\n) to ⏎ (unicode U+23CE)
    ##              or why not  to ___ ?
    ##
    ##  unicode options for return/arrows:
    ##   -  ↵ (U+21B5): Downwards Arrow With Corner Leftwards. 
    ##                This is the most common "carriage return" symbol.
    ##   -  ⏎ (U+23CE): Return Symbol. 
    ##               Specifically designated as the keyboard's "Return" key symbol, 
    ##                often used in user interfaces.

    txt = txt.gsub( PREPROC_BLOCK_RE ) do |m|
       if m.include?( "\n" )   ## check for newlines (\n) and replace
         puts " [debug] preproc (multi-line) block:"
         puts m
         ## todo/check: replace with two spaces insead of ↵ - why? why not?
         m.gsub( "\n", '↵' )
       else
         m 
       end 
    end


    ####
    ## quick hack - keep re state/mode between tokenize calls!!!
    @re  ||= RE     ## note - switch between RE & INSIDE_RE
  

    txt.each_line do |line|

       ##
       ##  first check for tabs
       ##    add error/warn
       ##    for auto-fix - replace tabs with two spaces
 
        line = line.gsub( "\t" ) do |_|
                  ## report error here
                  ## todo/add error here
                  puts "!! WARN - auto-fix; replacing tab (\\t) with two spaces in line #{line.inspect}"
                   "  "   ## replace with two spaces
                 end

        line = line.gsub( /[–]/ ) do |_|
                  ## report error here
                  ## todo/add error here
                  puts "!! WARN - auto-fix; replacing unicode dash ascii dash (-) in line #{line.inspect}"
                   '-'   ## replace with ascii dash (-)
                  end

        ## line = line.rstrip   ## note - MUST remove/strip trailing newline (spaces optional)!!!
        line = line.strip   ## note - strip leading AND trailing whitespaces
                            ## note - trailing whitespace may incl. \n or \r\n!!!

        next if line.start_with?('#')   ###  skip comments
       
        line = line.sub( /#.*/, '' ).strip   ###  cut-off end-of line comments too


        puts "line: >#{line}<"    if debug?

        ######
        ### special case for empty line (aka BLANK)
        if line.empty?
           ## note - blank always resets parser mode to std/top-level!!!
           @re = RE
           tokens_by_line << [[:BLANK, '<|BLANK|>']]
        elsif (m = HEADING_RE.match(line))
           ## note - heading always resets parser mode to std/top-level!!!
           @re = RE
           puts "   HEADING"  if debug?
           ## note - derive heading level from no of (leading) markers
           ##             e.g. = is 1, == is 2, == is 3, etc.
           heading_level = m[:heading_marker].size 
           tokens_by_line << [[:"H#{heading_level}", m[:heading]]]
        elsif (m = NOTA_BENE_RE.match(line))
           ## note - nota bene always resets parser mode to std/top-level!!!
           @re = RE
           tokens_by_line << [[:NOTA_BENE, m[:nota_bene]]]
        elsif @re == RE && (m = TABLE_RE.match(line))
            @re = TABLE_MORE_RE  ## switch into table mode
            if m[:table_heading]
              tokens_by_line << [[:TABLE_HEADING, m[:table_heading]]]
            else  ## assume table (line) e.g. m[:table]
              tokens_by_line << [[:TABLE_LINE, line]]
            end 
        elsif @re == TABLE_MORE_RE
            ### todo/fix - check if no match and report/add error!!
            ##        for now (ummatched) line gets auto-added as table line!!!
            ##
            ##   note - MUST be followed by blank line (or nota bene/heading)
            ##            to switch back into to top-level!!!! 
            m = TABLE_MORE_RE.match(line)
            if m[:table_note]
              tokens_by_line << [[:TABLE_NOTE, m[:table_note]]]
            else  ## assume table (line) e.g. m[:table]
              tokens_by_line << [[:TABLE_LINE, line]]
            end 
        else

          more_tokens, more_errors = _tokenize_line( line )
        
          tokens_by_line  << more_tokens   
          errors          += more_errors
        end
    end # each line





    tokens_by_line = tokens_by_line.map do |tokens|  
        #################
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
         elsif buf.match?( :GOAL_MINUTE, :',', :GOAL_MINUTE )
             ## note - only advance by two tokens!
             ##     allows more :GOAL_MINUTE sequences!! e.g. 12,13,14 etc!!!
             ##  
             ## help parser with comma shift/reduce conflict
             ##   change ',' to GOAL_MINUTE_SEP !!!
             nodes << buf.next   ## pass through goal_minute 
             _ = buf.next  ## eat-up goal_minute_sep a.k.a. comma (,)
                           ##   and replace with dedicated sep(arator)
             nodes << [:GOAL_MINUTE_SEP,"<|GOAL_MINUTE_SEP|>"]
         elsif buf.match?( :',', :INLINE_ATTENDANCE )
             ## note  - allow optional comma before inline attendance  
             ## help parser with comma shift/reduce conflict
             ##   change ',' to INLINE_ATTENDANCE_SEP !!!
             nodes << [:INLINE_ATTENDANCE_SEP, "<|INLINE_ATTENDANCE_SEP|>"]
             _ = buf.next  ## eat-up inline_attendance_sep a.k.a. comma (,)
                           ##   and replace with dedicated sep(arator)
             nodes << buf.next   ## pass through inline_attendance 
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
         tokens  << [:NEWLINE, "\n"]   unless tok[0] && tok[0][0] == :BLANK
    end

    [tokens,errors]
end   # method tokenize_with_errors




def _tokenize_line( line )
  tokens = []
  errors = []   ## keep a list of errors - why? why not?


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
    if (m = GROUP_DEF_LINE_RE.match( line ))
      puts "  ENTER GROUP_DEF_RE MODE"   if debug?
      @re = GROUP_DEF_RE   

      tokens << [:GROUP_DEF, m[:group_def]]

      offsets = [m.begin(0), m.end(0)]
      pos = offsets[1]    ## update pos
    elsif (m = PROP_KEY_RE.match( line ))
      ##  start with prop key (match will switch into prop mode!!!)
      ##   - fix - remove leading spaces in regex (upstream) - why? why not?
      ##
      ###  switch into new mode
      ##  switch context  to PROP_RE
        puts "  ENTER PROP_RE MODE"   if debug?
        key = m[:key]


        ### todo - add prop yellow/red cards too - why? why not?
        if ['sent off', 'red cards'].include?( key.downcase) 
          @re = PROP_CARDS_RE    ## use CARDS_RE ???
          tokens << [:PROP_REDCARDS, m[:key]]
        elsif ['yellow cards'].include?( key.downcase )
          @re = PROP_CARDS_RE  
          tokens << [:PROP_YELLOWCARDS, m[:key]]
        elsif ['ref', 'referee'].include?( key.downcase )
          @re = PROP_REFEREE_RE     
          tokens << [:PROP_REFEREE, m[:key]]
        elsif ['att', 'attn', 'attendance'].include?( key.downcase )
          @re = PROP_ATTENDANCE_RE
          tokens << [:PROP_ATTENDANCE, m[:key]]         
     #   elsif ['goals'].include?( key.downcase )
     #     @re = PROP_GOAL_RE
     #     tokens << [:PROP_GOALS, m[:key]]
        elsif ['penalties', 'penalty shootout'].include?( key.downcase )
          @re = PROP_PENALTIES_RE
          tokens << [:PROP_PENALTIES, m[:key]]
        else   ## assume (team) line-up
          @re = PROP_RE           ## use LINEUP_RE ???
          tokens << [:PROP, m[:key]]
        end

        offsets = [m.begin(0), m.end(0)]
        pos = offsets[1]    ## update pos
    elsif (m = ROUND_DEF_OUTLINE_RE.match( line ))
      puts "   ENTER ROUND_DEF_RE MODE"  if debug?
      @re = ROUND_DEF_RE   

      ## note - return ROUND_DEF NOT  ROUND_OUTLINE token
      tokens << [:ROUND_DEF, m[:round_outline]]

      offsets = [m.begin(0), m.end(0)]
      pos = offsets[1]    ## update pos
    elsif (m = ROUND_OUTLINE_RE.match( line ))
      puts "   ROUND_OUTLINE"  if debug?
      ## note - derive round level from no of (leading) markers
      ##             e.g. ▪/:: is 1, ▪▪/::: is 2, ▪▪▪/:::: is 3, etc.
      ##       note  - ascii-style starts with double ::, thus, autodecrement by one!
      round_level = m[:round_marker].size
      round_level -= 1  if m[:round_marker].start_with?( '::' ) 

      tokens << [:ROUND_OUTLINE, [m[:round_outline], 
                      { outline: m[:round_outline] , 
                        level: round_level}]]

      ## note - eats-up line for now (change later to only eat-up marker e.g. »|>>)
      offsets = [m.begin(0), m.end(0)]
      pos = offsets[1]    ## update pos
    elsif (m = GOAL_LINE_RE.match( line ))   ## line starting with ( - assume
      ##  switch context to GOAL_RE (goalline(s)
      ##   split token (automagically) into two!! - player AND minute!!!
      @re = GOAL_RE
      puts "  ENTER GOAL_RE MODE"   if debug?

      tokens << [:GOALS, "<|GOALS|>"]

      ## note - eat-up ( for now
      ##   pass along "virtual" GOALS token (see INLINE_GOALS for the starting goal line inline)     
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


  t = if @re == ROUND_DEF_RE 
           if m[:spaces] || m[:space] 
               nil    ## skip spaces
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
          elsif m[:duration]
            ## todo/check/fix - if end: works for kwargs!!!!!
            duration = { start: {}, end: {}}
            duration[:start][:y] = m[:year1].to_i(10)  if m[:year1]
            duration[:start][:m] = MONTH_MAP[ m[:month_name1].downcase ]   if m[:month_name1]
            duration[:start][:d]  = m[:day1].to_i(10)   if m[:day1]
            duration[:start][:wday] = DAY_MAP[ m[:day_name1].downcase ]   if m[:day_name1]
            duration[:end][:y] = m[:year2].to_i(10)  if m[:year2]
            duration[:end][:m] = MONTH_MAP[ m[:month_name2].downcase ]   if m[:month_name2]
            duration[:end][:d]  = m[:day2].to_i(10)   if m[:day2]
            duration[:end][:wday] = DAY_MAP[ m[:day_name2].downcase ]   if m[:day_name2]
            ## note - for debugging keep (pass along) "literal" duration
            [:DURATION, [m[:duration], duration]] 
          elsif m[:sym]
              sym = m[:sym]
              case sym
              when '|' then  [:'|']
              when ':' then  [:':']
              when ',' then  [:',']
              else
                puts "!!! TOKENIZE ERROR (sym) - ignore sym >#{sym}<"
                nil  ## ignore others (e.g. brackets [])
              end
           elsif m[:any]
              ## todo/check log error
               msg = "parse error (tokenize round_def) - skipping any match>#{m[:any]}< @#{offsets[0]},#{offsets[1]} in line >#{line}<"
               puts "!! WARN - #{msg}"
  
               errors << msg
               log( "!! WARN - #{msg}" )
       
               nil   
            else
              ## report error/raise expection
               puts "!!! TOKENIZE ERROR - no match found"
               nil 
            end
      elsif @re == GROUP_DEF_RE
           if m[:spaces] || m[:space] 
               nil    ## skip spaces
           elsif m[:text]
               [:TEAM, m[:text]]  
           elsif m[:sym]
              sym = m[:sym]
              case sym
              when '|' then  [:'|']
              when ':' then  [:':']
              when ',' then  [:',']
              else
                puts "!!! TOKENIZE ERROR (sym) - ignore sym >#{sym}<"
                nil  ## ignore others (e.g. brackets [])
              end
           elsif m[:any]
              ## todo/check log error
               msg = "parse error (tokenize group_def) - skipping any match>#{m[:any]}< @#{offsets[0]},#{offsets[1]} in line >#{line}<"
               puts "!! WARN - #{msg}"
  
               errors << msg
               log( "!! WARN - #{msg}" )
       
               nil   
            else
              ## report error/raise expection
               puts "!!! TOKENIZE ERROR - no match found"
               nil 
            end
       elsif @re == GEO_RE
           ### note - possibly end inline geo on [ (and others?? in the future
           ## note: break on double spaces e.g.
           ## e.g. Jul/16 @ Arena Auf Schalke, Gelsenkirchen  Serbia 0-1 England    
           if m[:spaces]
                 ## get out-off geo mode and backtrack (w/ next)
                 puts "  LEAVE GEO_RE MODE, BACK TO TOP_LEVEL/RE"  if debug?
                 @re = RE
                 pos = old_pos
                 next   ## backtrack (resume new loop step)                 
           elsif m[:space] 
               nil    ## skip (single) space
           elsif m[:text]
               [:GEO, m[:text]]   ## keep pos - why? why not?
        ##  note - timezone for now moved out of geo
        ##              (use after TIME or use TIME_LOCAL w/ optional TIMEZONE)
        ##                TIMEZONE_RE, 
        #   elsif m[:timezone]
        #       [:TIMEZONE, m[:timezone]]
           elsif m[:sym]
              sym = m[:sym]
              ## return symbols "inline" as is - why? why not?
              ## (?<sym>[;,@|\[\]-])
              case sym
              when ',' then  [:',']
              when '›' then  [:',']  ## note - treat geo sep › (unicode) like comma for now!!!
              when '>' then  [:',']  ## note - treat geo sep > (ascii) like comma for now!!!
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
      elsif @re == PROP_CARDS_RE 
        if m[:space] || m[:spaces]
              nil    ## skip space(s)
         elsif m[:prop_name]
              [:PROP_NAME, m[:name]]
         elsif m[:minute]
              minute = {}
              minute[:m]      = m[:value].to_i(10)
              minute[:offset] = m[:value2].to_i(10)   if m[:value2]
             ## note - for debugging keep (pass along) "literal" minute
             [:MINUTE, [m[:minute], minute]]
         elsif m[:sym]
            sym = m[:sym]
            case sym
            when ',' then [:',']
            when ';' then [:';']
            when '-' then [:'-']
            else
              nil  ## ignore others (e.g. brackets [])
            end
         else
            ## report error
             puts "!!! TOKENIZE ERROR (PROP_CARDS_RE) - no match found"
             nil 
         end    
      elsif @re == PROP_RE   ### todo/fix - change to LINEUP_RE !!!!
         if m[:space] || m[:spaces]
              nil    ## skip space(s)
         elsif m[:prop_key]   ## check for inline prop keys
              key = m[:key]   
              ##  supported for now coach/trainer (add manager?)
              if ['coach', 
                  'trainer'].include?( key.downcase )
                [:COACH, m[:key]]   ## use COACH_KEY or such - why? why not?
              else
                ## report error - for unknown (inline) prop key in lineup
                nil
              end
         elsif m[:prop_name]
               if m[:name] == 'Y'
                 [:YELLOW_CARD, m[:name]]
               elsif m[:name] == 'R'
                 [:RED_CARD, m[:name]]
               else 
                 [:PROP_NAME, m[:name]]
               end
         elsif m[:minute]
              minute = {}
              minute[:m]      = m[:value].to_i(10)
              minute[:offset] = m[:value2].to_i(10)   if m[:value2]
             ## note - for debugging keep (pass along) "literal" minute
             [:MINUTE, [m[:minute], minute]]
         elsif m[:sym]
            sym = m[:sym]
            ## return symbols "inline" as is - why? why not?
            ## (?<sym>[;,@|\[\]-])
 
            case sym
            when ',' then [:',']
            when ';' then [:';']
            when '[' then [:'[']
            when ']' then [:']']
            when '(' then [:'(']
            when ')' then [:')']
            when '-' then [:'-']
            else
              nil  ## ignore others (e.g. brackets [])
            end
         else
            ## report error
             puts "!!! TOKENIZE ERROR (PROP_RE) - no match found"
             nil 
         end
      elsif @re == PROP_ATTENDANCE_RE
         if m[:space] || m[:spaces]
              nil    ## skip space(s)
         elsif m[:enclosed_name]
              ## reserverd for use for sold out or such (in the future) - why? why not?
             [:ENCLOSED_NAME, m[:name]]
         elsif m[:num]
             [:PROP_NUM, [m[:num], { value: m[:value].to_i(10) } ]]
=begin             
         elsif m[:sym]
            sym = m[:sym]
            case sym
            when ',' then [:',']
            when ';' then [:';']
            # when '[' then [:'[']
            # when ']' then [:']']
            else
              nil  ## ignore others (e.g. brackets [])
            end
=end
         else
            ## report error
            puts "!!! TOKENIZE ERROR (PROP_ATTENDANCE_RE) - no match found"
            nil 
         end
      elsif @re == PROP_REFEREE_RE
         if m[:space] || m[:spaces]
              nil    ## skip space(s)
         elsif m[:prop_key]   ## check for inline prop keys
              key = m[:key]   
              ##  supported for now coach/trainer (add manager?)
              if ['att', 'attn', 'attendance' ].include?( key.downcase )
                [:ATTENDANCE, m[:key]]   ## use COACH_KEY or such - why? why not?
              else
                ## report error - for unknown (inline) prop key in lineup
                nil
              end
         elsif m[:prop_name]    ## note - change prop_name to player
             [:PROP_NAME, m[:name]]    ### use PLAYER for token - why? why not?
         elsif m[:num]
             [:PROP_NUM, [m[:num], { value: m[:value].to_i(10) } ]]
         elsif m[:enclosed_name]
              ## use HOLD,SAVE,POST or such keys - why? why not?
             [:ENCLOSED_NAME, m[:name]]
         elsif m[:sym]
            sym = m[:sym]
            case sym
            when ',' then [:',']
            when ';' then [:';']
 #           when '[' then [:'[']
 #           when ']' then [:']']
            else
              nil  ## ignore others (e.g. brackets [])
            end
         else
            ## report error
            puts "!!! TOKENIZE ERROR (PROP_REFEREE_RE) - no match found"
            nil 
         end       
      elsif @re == PROP_PENALTIES_RE
        if m[:space] || m[:spaces]
              nil    ## skip space(s)
         elsif m[:prop_name]    ## note - change prop_name to player
             [:PROP_NAME, m[:name]]    ### use PLAYER for token - why? why not?
         elsif m[:enclosed_name]
              ## use HOLD,SAVE,POST or such keys - why? why not?
             [:ENCLOSED_NAME, m[:name]]
         elsif m[:score]
              score = {}
              ## must always have ft for now e.g. 1-1 or such
              ###  change to (generic) score from ft -
              ##     might be score a.e.t. or such - why? why not?
              score[:ft] = [m[:ft1].to_i(10),
                            m[:ft2].to_i(10)]  
              ## note - for debugging keep (pass along) "literal" score
              [:SCORE, [m[:score], score]]
         elsif m[:sym]
            sym = m[:sym]
            case sym
            when ',' then [:',']
            when ';' then [:';']
            when '[' then [:'[']
            when ']' then [:']']
            else
              nil  ## ignore others (e.g. brackets [])
            end
         else
            ## report error
            puts "!!! TOKENIZE ERROR (PROP_PENALTIES_RE) - no match found"
            nil 
         end
      elsif @re == GOAL_RE 
         if m[:space] || m[:spaces]
              nil    ## skip space(s)
         elsif m[:goals_none]    ## note - eats-up semicolon!! e.g. -; or - ;
             [:GOALS_NONE, "<|GOALS_NONE|>"]
         elsif m[:goal_sep_alt]
             [:GOAL_SEP_ALT, "<|GOAL_SEP_ALT|>" ]   ## e.g. dash (-) WITH leading & trailing space required    
         elsif m[:prop_name]    ## note - change prop_name to player
             [:PLAYER, m[:name]] 
         elsif m[:goal_minute]
              minute = _build_goal_minute( m )
             [:GOAL_MINUTE, [m[:goal_minute], minute]]
         elsif m[:goal_count]
              count = _build_goal_count( m ) 
              [:GOAL_COUNT, [m[:goal_count], count]]
         elsif m[:sym]
            sym = m[:sym]
            ## return symbols "inline" as is - why? why not?
            ## (?<sym>[;,@|\[\]-])
 
            case sym
            when ',' then [:',']
            when ';' then [:';']
            # when '[' then [:'[']
            # when ']' then [:']']
            when ')'  ## leave goal mode!!
                puts "  LEAVE GOAL_RE MODE"   if debug?
                @re = RE
                nil
            else
              nil  ## ignore others (e.g. brackets [])
            end
         else
            ## report error
            puts "!!! TOKENIZE ERROR (GOAL_RE) - no match found"
            nil 
         end
      ###################################################
      ## assume TOP_LEVEL (a.k.a. RE) machinery
      else  
        if m[:space] || m[:spaces]
           nil   ## skip space(s)
        elsif m[:text]
          ##  note - top-level (for now always) assumes TEAM for TEXT match!!
          [:TEAM, m[:text]]   ## keep pos - why? why not?
        elsif m[:status]   ## (match) status e.g. cancelled, awarded, etc.
          ## todo/check - add text (or status) 
          #     to opts hash {} by default (for value)
          if m[:status_note]   ## includes note? e.g.  awarded; originally 2-0
             [:STATUS, [m[:status], {status: m[:status], 
                                     note:   m[:status_note]} ]]
          else
             [:STATUS, [m[:status], {status: m[:status] } ]]
          end
        elsif m[:inline_wo]   ## w/o - walkout  (match status)
            [:INLINE_WO, m[:inline_wo]]
        elsif m[:inline_bye]  ## bye  (match status)
            [:INLINE_BYE, m[:inline_bye]]
        elsif m[:attendance]
             att = {} 
             att[:value] = m[:value].gsub( '_', '' ).to_i(10)
             ## note - for token id use INLINE_ATTENDANCE  (ATTENDANCE in use for prop!!!) 
            [:INLINE_ATTENDANCE, [m[:attendance], att ]]
        elsif m[:note]
            ###  todo/check:
            ##      use value hash - why? why not? or simplify to:
            ## [:NOTE, [m[:note], {note: m[:note] } ]]
             [:NOTE, m[:note]] 
        elsif m[:time]
              ## unify to iso-format
              ###   12.40 => 12:40
              ##    12h40 => 12:40 etc.
              ##  keep string (no time-only type in ruby)
              time = {}
              hour     =   m[:hour].to_i(10)  ## allow 08/07/etc.
              minute   = m[:minute].to_i(10)

              time[:h] = hour
              time[:m] = minute
              time[:timezone] = m[:timezone]    if m[:timezone] 

              ##   check if 24:00 possible? or only 0:00 (23:59)
              if (hour >= 0 && hour <= 24) &&
                 (minute >=0 && minute <= 59)
               ## note - for debugging keep (pass along) "literal" time
               ##   might use/add support for am/pm later
               [:TIME, [m[:time], time]]
              else
                 raise ArgumentError, "parse error - time >#{m[:time]}< out-of-range"
              end
        elsif m[:time_local]
              time = {}
              hour     =   m[:hour].to_i(10)  ## allow 08/07/etc.
              minute   = m[:minute].to_i(10)

              time[:h] = hour
              time[:m] = minute
              time[:timezone] = m[:timezone]    if m[:timezone] 

              ## check if valid -  0:00 - 24:00
              ##   check if 24:00 possible? or only 0:00 (23:59)
              if (hour >= 0 && hour <= 24) &&
                 (minute >=0 && minute <= 59)
               ## note - for debugging keep (pass along) "literal" time
               ##   might use/add support for am/pm later
               [:TIME_LOCAL, [m[:time_local], time]]
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
        elsif m[:date_legs]
            legs = {}
 ## map month names
 ## note - allow any/upcase JULY/JUL etc. thus ALWAYS downcase for lookup
            date = {}
            date[:m] = MONTH_MAP[ m[:month_name1].downcase ]
            date[:d]  = m[:day1].to_i(10)   
            legs[:date1] = date
     
            date = {}
            date[:m] = MONTH_MAP[ m[:month_name2].downcase ]   if m[:month_name2]
            date[:d]  = m[:day2].to_i(10)   
            legs[:date2] = date

            ## note - for debugging keep (pass along) "literal" date
            [:DATE_LEGS, [m[:date_legs], legs]] 
        elsif m[:ord]   ## note -  ord (for ordinal number!!!) e.g match number (1), (42), etc.
              ## note -  strip enclosing () and convert to integer
             [:ORD, [m[:ord], { value: m[:value].to_i(10) } ]]
        elsif m[:score_legs]
              legs = {}
              
              ### leg1
              score = {}
              score[:ft] = [m[:leg1_ft1].to_i(10),
                            m[:leg1_ft2].to_i(10)] 
              legs['leg1'] = score
              
              ### leg2
              score = {}
              score[:ft] = [m[:leg2_ft1].to_i(10),
                            m[:leg2_ft2].to_i(10)]  if m[:leg2_ft1] && m[:leg2_ft2]
              score[:et] = [m[:leg2_et1].to_i(10),
                            m[:leg2_et2].to_i(10)]  if m[:leg2_et1] && m[:leg2_et2]
              score[:p]  = [m[:leg2_p1].to_i(10),
                            m[:leg2_p2].to_i(10)]  if m[:leg2_p1] && m[:leg2_p2]
              legs['leg2'] = score
              
              ## check for (opt) aggregate - keep on "top-level"
              legs[:agg] = [m[:agg1].to_i(10),
                            m[:agg2].to_i(10)]  if m[:agg1] && m[:agg2]
              legs[:away] = true  if m[:away]  
              
              ## note - for debugging keep (pass along) "literal" score
              [:SCORE_LEGS, [m[:score_legs], legs]]
        elsif m[:score_full]
              score = {}
              score[:p] = [m[:p1].to_i(10),
                           m[:p2].to_i(10)]  if m[:p1] && m[:p2]
              score[:et] = [m[:et1].to_i(10),
                            m[:et2].to_i(10)]  if m[:et1] && m[:et2]
              score[:ft] = [m[:ft1].to_i(10),
                            m[:ft2].to_i(10)]  if m[:ft1] && m[:ft2]
              score[:ht] = [m[:ht1].to_i(10),
                            m[:ht2].to_i(10)]  if m[:ht1] && m[:ht2]
              score[:agg] = [m[:agg1].to_i(10),
                             m[:agg2].to_i(10)]  if m[:agg1] && m[:agg2]

              if m[:away1] && m[:away2]               
                 score[:away] = [m[:away1].to_i(10),
                                 m[:away2].to_i(10)]
              elsif m[:away]    ## fallback if no away score; check away flag
                 score[:away] = true
              end  

              ## add golden/silver flags
              score[:golden] = true   if m[:aetgg]  ## golden goal (gg)/sudden death (sd)
              score[:silver] = true   if m[:aetsg]  ## silver goal (sg)

            ## note - for debugging keep (pass along) "literal" score
            [:SCORE_FULL, [m[:score_full], score]]
        elsif m[:score_fuller]
              score = {}
              score[:p] = [m[:p1].to_i(10),
                           m[:p2].to_i(10)]  if m[:p1] && m[:p2]
              score[:et] = [m[:et1].to_i(10),
                            m[:et2].to_i(10)]  if m[:et1] && m[:et2]
              score[:ft] = [m[:ft1].to_i(10),
                            m[:ft2].to_i(10)]  if m[:ft1] && m[:ft2]
              score[:ht] = [m[:ht1].to_i(10),
                            m[:ht2].to_i(10)]  if m[:ht1] && m[:ht2]
              score[:agg] = [m[:agg1].to_i(10),
                             m[:agg2].to_i(10)]  if m[:agg1] && m[:agg2]
              if m[:away1] && m[:away2]               
                 score[:away] = [m[:away1].to_i(10),
                                 m[:away2].to_i(10)]
              elsif m[:away]    ## fallback if no away score; check away flag
                 score[:away] = true
              end  

              ## add aet flag true/false
              # score[:aet] = true   if m[:aet] || m[:aetgg] || m[:aetsg]
              
              ## add golden/silver flags
              score[:golden] = true   if m[:aetgg]  ## golden goal (gg)/sudden death (sd)
              score[:silver] = true   if m[:aetsg]  ## silver goal (sg)

            ## note - for debugging keep (pass along) "literal" score
            [:SCORE_FULLER, [m[:score_fuller], score]]
        elsif m[:score_fuller_more]
               ##    SCORE + SCORE_FULLER_MORE
               ## note -  after extra-time (aet) or full-time (ft) 
               ##           score may be present in SCORE!!! 
              score = {}
              score[:p] = [m[:p1].to_i(10),
                           m[:p2].to_i(10)]  if m[:p1] && m[:p2]
              score[:et] = [m[:et1].to_i(10),
                            m[:et2].to_i(10)]  if m[:et1] && m[:et2]
              score[:ft] = [m[:ft1].to_i(10),
                            m[:ft2].to_i(10)]  if m[:ft1] && m[:ft2]
              score[:ht] = [m[:ht1].to_i(10),
                            m[:ht2].to_i(10)]  if m[:ht1] && m[:ht2]
              score[:agg] = [m[:agg1].to_i(10),
                             m[:agg2].to_i(10)]  if m[:agg1] && m[:agg2]
              if m[:away1] && m[:away2]               
                 score[:away] = [m[:away1].to_i(10),
                                 m[:away2].to_i(10)]
              elsif m[:away]    ## fallback if no away score; check away flag
                 score[:away] = true
              end  

              ## add aet flag true/false
              score[:aet] = true   if m[:aet] || m[:aetgg] || m[:aetsg]
              ## add golden/silver flags
              score[:golden] = true   if m[:aetgg]  ## golden goal (gg)/sudden death (sd)
              score[:silver] = true   if m[:aetsg]  ## silver goal (sg)

            ## note - for debugging keep (pass along) "literal" score
            [:SCORE_FULLER_MORE, [m[:score_fuller_more], score]]
        elsif m[:score]
            score = {}
             ##  note - score is "generic"
            ##      might be full-time (ft) or
            ##         after extra-time (aet) or such
            ##         or even undecided/unknown
            ##    thus, use score1/score2 and NOT ft1/ft2
            score[:score] = [m[:score1].to_i(10),
                             m[:score2].to_i(10)]  
         ## note - for debugging keep (pass along) "literal" score
          [:SCORE, [m[:score], score]]
      elsif m[:minute]
              minute = {}
              minute[:m]      = m[:value].to_i(10)
              minute[:offset] = m[:value2].to_i(10)   if m[:value2]
             ## note - for debugging keep (pass along) "literal" minute
             [:MINUTE, [m[:minute], minute]]
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
          when '-' then [:'-']    
          when '('    ## enter goal scorer mode on "free-floating" open paranthesis!!!
             puts "  ENTER GOAL_RE MODE"   if debug?
             @re = GOAL_RE
              ## note - eat-up ( for now; do NOT pass along as token
              ##       pass along "virutal" INLINE GOALS - why? why not?
              [:INLINE_GOALS, "<|INLINE_GOALS|>"]
          when ')' then [:')']
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


  # if @re == GOAL_RE   ### ALWAYS switch back to top level mode
  #   puts "  LEAVE GOAL_RE MODE, BACK TO TOP_LEVEL/RE"  if debug?
  #   @re = RE 
  # end
 
   if @re == GEO_RE   ### ALWAYS switch back to top level mode
     puts "  LEAVE GEO_RE MODE, BACK TO TOP_LEVEL/RE"  if debug?
     @re = RE 
   end
 
   @re = RE  if @re == GROUP_DEF_RE   ### ALWAYS switch back to top level mode
   @re = RE  if @re == ROUND_DEF_RE

   ##
   ## if in prop mode continue if   last token is [,-]
   ##        otherwise change back to "standard" mode
   if @re == PROP_RE            || @re == PROP_CARDS_RE ||
      @re == PROP_PENALTIES_RE ||
      @re == PROP_ATTENDANCE_RE || @re == PROP_REFEREE_RE
     if [:',', :'-', :';'].include?( tokens[-1][0] )
        ## continue/stay in PROP_RE mode
        ##  todo/check - auto-add PROP_CONT token or such
        ##                to help parser with possible NEWLINE
        ##                  conflicts  - why? why not?
     else
        ## switch back to top-level mode!!
        puts "  LEAVE PROP_RE MODE, BACK TO TOP_LEVEL/RE"  if debug?
        @re = RE 
        ## note - auto-add PROP_END (<PROP_END>)
        tokens << [:PROP_END, "<|PROP_END|>"]    
     end
   end

  
  [tokens,errors]
end

end  # class Lexer
end # module SportDb
