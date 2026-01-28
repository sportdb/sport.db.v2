###
#  to run use
#     ruby test/test_date.rb


require_relative 'helper'

class TestDate < Minitest::Test

DATE_RE   =  SportDb::Lexer::DATE_RE
MONTH_MAP = SportDb::Lexer::MONTH_MAP
DAY_MAP   = SportDb::Lexer::DAY_MAP 


## note - wday mapping starting with 1 (NOT zero)
##                 1 => monday, 2 => tuesday, ..., 7 => sunday

TESTS = [
      ## "european"-style
      ['20.01.2026',          { d:20, m:1, y:2026} ],  
      ['20.1.26',             { d:20, m:1, yy:26} ],  
      ['20.1.',               { d:20, m:1} ],
      ## "classic" american  - month/day 
      ['Tu July/9 2024',      { wday:2, m:7, d:9, y:2024}],
      ['Sunday Jul 14 2024',  { wday:7, m:7, d:14, y:2024}],
      ['Tue Feb/13',          { wday:2, m:2, d:13}],
      ## "classic" - day/month
      ['Tu 9 July 2024',      { wday:2, m:7, d:9, y:2024}],
      ['Sunday 14 Jul 2024',  { wday:7, m:7, d:14, y:2024}],
      ['Tue 13 Feb',          { wday:2, m:2, d:13}],
      ## iso date   (YYYY-MM-DD)
      ['2026-01-20',          { d:20, m:1, y:2026} ],  
      ['2026-1-20',           { d:20, m:1, y:2026} ],
      ['2026-01-02',          { d:2, m:1, y:2026} ],  
      ['2026-1-2',            { d:2, m:1, y:2026} ],  
]



def test_date
  TESTS.each do |text, exp_date|
  
     puts "==> #{text}"
     m=DATE_RE.match( text )

     if m
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
 
       ## pp m
       puts "  #{date.pretty_inspect}"
       assert_equal exp_date, date
    else
       puts "!! NOT matching"
       assert false
    end
  end
end



end  # class TestDate