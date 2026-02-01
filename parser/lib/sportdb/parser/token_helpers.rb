module SportDb
class Lexer


=begin
def self._mk_is( re )
    ##   add  \A ... \z to regex
    ##     for strict matching of beginning and end of string
    ##     regex note -  \z will NOT allow trailing newline(s)!!!!
    ##      note - must double espace \\A,\\z  in quoted string!!
    Regexp.new( %Q<   \\A
                    (?:#{re.source})
                       \\z
                  >, re.options )
end


  IS_TEAM_RE = _mk_is( TEXT_RE )   ## todo/fix - rename TEXT_RE to TEAM_RE!!!
  IS_DATE_RE = _mk_is( DATE_IIII_RE )    ## DATE_RE )
=end


def self._parse_team( str )  
    ## note - strip - leading/trailing spaces
    m = TEXT_RE.match( str.strip )
    if m && m.pre_match == '' && m.post_match == ''
      m
    elsif  m
        ## note - match BUT not anchored to start and end-of-string!!!
        ##  report, error somehow??
      nil   
    else
      nil  ## no match - return nil
    end
end


def self._parse_date( str )
    ## note - strip - leading/trailing spaces
    m = DATE_RE.match( str.strip )
    
    ####  todo/fix/check:
    ###   wrapped with  \A \z NOT working with union  - check later - why?
    ###   use hand-coded  with pre_match = "" and post_match = ""
    
    if m && m.pre_match == '' && m.post_match == ''
      ## return hash table with captured components
      date = {}
      ## map month names
      ## note - allow any/upcase JULY/JUL etc. thus ALWAYS downcase for lookup
      date[:y]  = m[:year].to_i(10)  if m[:year]
      ## check - use y too for two-digit year or keep separate - why? why not?
      date[:yy] = m[:yy].to_i(10)    if m[:yy]    ## two digit year (e.g. 25 or 78 etc.)
      date[:m]  = m[:month].to_i(10)  if m[:month]
      date[:m]  = MONTH_MAP[ m[:month_name].downcase ]   if m[:month_name]
      date[:d]  = m[:day].to_i(10)   if m[:day]
      date[:wday] = DAY_MAP[ m[:day_name].downcase ]   if m[:day_name]
      date 
    elsif  m
        ## note - match BUT not anchored to start and end-of-string!!!
        ##  report, error somehow??
      nil   
    else
      nil  ## no match - return nil
    end
end   


def self._parse_score_full( str )
    ## note - strip - leading/trailing spaces
    m=SCORE_FULL_RE.match( str )

    if m && m.pre_match == '' && m.post_match == ''
       score = {}
       score[:p]  = [m[:p1].to_i,m[:p2].to_i]     if m[:p1] && m[:p2]
       score[:et] = [m[:et1].to_i,m[:et2].to_i]   if m[:et1] && m[:et2]
       score[:ft] = [m[:ft1].to_i,m[:ft2].to_i]   if m[:ft1] && m[:ft2]
       score[:ht] = [m[:ht1].to_i,m[:ht2].to_i]   if m[:ht1] && m[:ht2]
       ## score[:agg] = [m[:agg1].to_i,m[:agg2].to_i]   if m[:agg1] && m[:agg2]
       score
    elsif  m
        ## note - match BUT not anchored to start and end-of-string!!!
        ##  report, error somehow??
      nil   
    else
      nil  ## no match - return nil
    end
end       
       

end  #   class Lexer
end  # module SportDb
