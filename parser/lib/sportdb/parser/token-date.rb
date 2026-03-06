module SportDb
class Lexer



def self.parse_names( txt )
  lines = [] # array of lines (with words)

  txt.each_line do |line|
    line = line.strip

    next if line.empty?
    next if line.start_with?( '#' )   ## skip comments too

    ## strip inline (until end-of-line) comments too
    ##   e.g. Janvier  Janv  Jan  ## check janv in use??
    ##   =>   Janvier  Janv  Jan

    line = line.sub( /#.*/, '' ).strip
    ## pp line

    values = line.split( /[ \t]+/ )
    ## pp values

    ## todo/fix -- add check for duplicates
    lines << values
  end
  lines

end # method parse


def self.build_names( lines )
  ## join all words together into a single string e.g.
  ##   January|Jan|February|Feb|March|Mar|April|Apr|May|June|Jun|...
  lines.map { |line| line.join('|') }.join('|')
end


def self.build_map( lines, downcase: false )
   ## note: downcase name!!!
  ## build a lookup map that maps the word to the index (line no) plus 1 e.g.
  ##  {"january" => 1,  "jan" => 1,
  ##   "february" => 2, "feb" => 2,
  ##   "march" => 3,    "mar" => 3,
  ##   "april" => 4,    "apr" => 4,
  ##   "may" => 5,
  ##   "june" => 6,     "jun" => 6, ...
  lines.each_with_index.reduce( {} ) do |h,(line,i)|
    line.each do |name|
       h[ downcase ? name.downcase : name ] = i+1
    end  ## note: start mapping with 1 (and NOT zero-based, that is, 0)
    h
  end
end




MONTH_LINES = parse_names( <<TXT )
January    Jan
February   Feb
March      Mar
April      Apr
May
June       Jun
July       Jul
August     Aug
September  Sept  Sep
October    Oct
November   Nov
December   Dec
TXT

MONTH_NAMES = build_names( MONTH_LINES )
# pp MONTH_NAMES
MONTH_MAP   = build_map( MONTH_LINES, downcase: true )
# pp MONTH_MAP



DAY_LINES = parse_names( <<TXT )
Monday                   Mon  Mo
Tuesday            Tues  Tue  Tu
Wednesday                Wed  We
Thursday    Thurs  Thur  Thu  Th
Friday                   Fri  Fr
Saturday                 Sat  Sa
Sunday                   Sun  Su
TXT

DAY_NAMES = build_names( DAY_LINES )
# pp DAY_NAMES
DAY_MAP   = build_map( DAY_LINES, downcase: true )
# pp DAY_MAP


#=>
# "January|Jan|February|Feb|March|Mar|April|Apr|May|June|Jun|
#  July|Jul|August|Aug|September|Sept|Sep|October|Oct|
#  November|Nov|December|Dec"
#
# "Monday|Mon|Mo|Tuesday|Tues|Tue|Tu|Wednesday|Wed|We|
#  Thursday|Thurs|Thur|Thu|Th|Friday|Fri|Fr|
#  Saturday|Sat|Sa|Sunday|Sun|Su"



## todo - add more date variants !!!! why? why not?


# e.g.  Fri Aug 9
##      note - Fri Aug/9  no longer supported!!!   
DATE_I_RE = %r{
(?<date>
  \b
     ## optional day name
     ((?<day_name>#{DAY_NAMES})
          [ ]
     )?
     (?<month_name>#{MONTH_NAMES})
          [ ] 
     (?<day>\d{1,2})
     ## optional year
     (  [ ]
        (?<year>\d{4})
     )?
  \b
)}ix


### todo/fix - add (opt) day_name later
##             add (opt) year later
# e.g.  Aug 9 & Aug 10
### note - allow shortcut e.g. Aug 9 & 10
DATE_LEGS_I_RE = %r{
(?<date_legs>
 \b
     (?<month_name1>#{MONTH_NAMES})
          [ ] 
     (?<day1>\d{1,2})
    [ ] & [ ]
     (?:
        (?<month_name2>#{MONTH_NAMES})
          [ ] 
      )?  ## note - make 2nd month_name optional 
     (?<day2>\d{1,2})
  \b
)}ix


# e.g. 3 June  or 10 June
DATE_II_RE = %r{
(?<date>
  \b
     ## optional day name
     ((?<day_name>#{DAY_NAMES})
          [ ]
     )?
     (?<day>\d{1,2})
         [ ]
     (?<month_name>#{MONTH_NAMES})
     ## optional year
     (  [ ]
        (?<year>\d{4})
     )?
  \b
)}ix


# e.g. iso-date  -  2011-08-25     
##   note - allow/support ("shortcuts") e.g 2011-8-25  or 2011-8-3 / 2011-08-03 etc. 
DATE_III_A_RE = %r{
(?<date>
  \b
   (?<year>\d{4})
       -
   (?<month>\d{1,2})
       -
   (?<day>\d{1,2})
  \b
)}ix

##  starting w/  day/month/year e.g.  25-08-2011
DATE_III_B_RE = %r{
(?<date>
  \b
     ## optional day name
     ((?<day_name>#{DAY_NAMES})
          [ ]
     )?
   (?<day>\d{1,2})
       -
   (?<month>\d{1,2})
       -
   (?<year>\d{4})
  \b
)}ix



## allow (short)"european" style  8.8. 
##   note - assume day/month!!!
DATE_IIII_RE = %r{
(?<date>
  \b
     ## optional day name
     ((?<day_name>#{DAY_NAMES})
          [ ]
     )?
   (?<day>\d{1,2})
       \.
   (?<month>\d{1,2})
       \.
   (?: (?: 
          (?<year>\d{4})        ## optional year 2025 (yyyy)
              |
          (?<yy>\d{2})           ## optional year 25 (yy)
       )
        \b
   )?
)
}ix

####################
### 04/03/2026
##     note - year (YYYY) required for now - why? why not?
DATE_IIIII_RE = %r{
(?<date>
  \b
     ## optional day name
     ((?<day_name>#{DAY_NAMES})
          [ ]
     )?
   (?<day>\d{1,2})
       /
   (?<month>\d{1,2})
       /
   (?<year>\d{4})      
  \b
)
}ix



#############################################
# map tables
#  note: order matters; first come-first matched/served
DATE_RE = Regexp.union(
   DATE_I_RE,
   DATE_II_RE,
   DATE_III_A_RE,    ## e.g. 1973-08-14
   DATE_III_B_RE,
   DATE_IIII_RE,    ## e.g. 8.8. or 8.13.79 or 08.14.1973 
   DATE_IIIII_RE,   ## e.g.  08/14/1973
)

## todo - add more format style here; change to Regexp.union later!!!
DATE_LEGS_RE  =    DATE_LEGS_I_RE


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
def _build_date( m ) self.class._build_date( m ); end

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
def _build_date_legs( m ) self.class._build_date_legs( m ); end




#############
## "top-level" add a date parser helper
def self.parse_date( str, start: )
    if m=DATE_RE.match( str )

      year    = m[:year].to_i(10)  if m[:year]
      month   = MONTH_MAP[ m[:month_name].downcase ]   if m[:month_name]
      day     = m[:day].to_i(10)   if m[:day]
      wday    = DAY_MAP[ m[:day_name].downcase ]   if m[:day_name]

      if year.nil?   ## try to calculate year
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
      puts "!! ERROR - unexpected date format; cannot parse >#{str}<"
      exit 1
    end
end


end  #   class Lexer
end  # module SportDb

