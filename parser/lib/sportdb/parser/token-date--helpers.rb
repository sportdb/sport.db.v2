module SportDb
class Lexer


##  "internal" date helpers
def self._build_date( m )
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

            date
end

def self._build_date_legs( m )
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

            legs
end


def self._build_duration( m )
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

            duration
end




def _build_date( m )      self.class._build_date( m ); end
def _build_date_legs( m ) self.class._build_date_legs( m ); end
def _build_duration( m )  self.class._build_duration( m ); end




#############
## "top-level" add a date parser helper

##  note:  parse_date  - returns Date object
##        _parse_date (with underscore) - return  hash of "parsed" regex match data!!

def self.parse_date( str, start: nil )
    if m = _parse_date( str )
       year  = m[:y]
       yy    = m[:yy]

       ####
       ## support two digit shortcut for year
       if yy && year.nil?
          ###
          ## for now assume 00,01 to 30 is 2000,2001 to 2030
          ##   and          31 to 99   is  1931 to 1999
          year =   yy <= 30 ?  2000+yy : 1900+yy
       end

       month = m[:m]
       day   = m[:d]
       wday  = m[:wday]


      if year.nil?     ## try to calculate year
        raise ArgumentError, "year required in date >#{str}< or pass along start date"   if start.nil?

        year =  if  month > start.month ||
                   (month == start.month && day >= start.day)
                  # assume same year as start_at event (e.g. 2013 for 2013/14 season)
                  start.year
                else
                  # assume year+1 as start_at event (e.g. 2014 for 2013/14 season)
                  start.year+1
                end
      end
      Date.new( year,month,day )
    else
      raise ArgumentError, "unexpected date format; cannot parse >#{str}<"
    end
end



def self._parse_date( str )
    ## note - strip - leading/trailing spaces automatic - why? why not?
    m = DATE_RE.match( str.strip )

    if m && m.pre_match == '' && m.post_match == ''
      ## return hash table with captured components
      date = _build_date( m )
      date
    elsif  m
        ## note - match BUT not anchored to start and end-of-string!!!
        ##  report, error somehow??
      nil
    else
      nil  ## no match - return nil
    end
end


end  # class Lexer
end  # module SportDb
