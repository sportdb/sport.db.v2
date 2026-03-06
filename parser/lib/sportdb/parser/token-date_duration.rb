module SportDb
class Lexer




###
#  date duration
#   use - or + as separator
#    in theory plus( +) only if dates
#     are two days next to each other
#
#   otherwise  define new dates type in the future? why? why not?
#
#  check for plus (+) if dates are next to each other (t+1) - why? why not?

#
#  Sun Jun 23 - Wed Jun 26   -- YES
#  Jun 23 - Jun 26           -- YES
#  Jun 25 - 26        - why? why not???  - YES - see blow variant iii!!!

#  Tue Jun 25 + Wed Jun 26   -- NO
#  Jun 25 + Jun 26           -- NO
#  Jun 25 .. 26        - why? why not???
#  Jun 25 to 26        - why? why not???
#  Jun 25 + 26        - add - why? why not???
#  Sun-Wed Jun 23-26  -  add - why? why not???
#  Wed+Thu Jun 26+27 2024  -  add - why? why not???
#
#  maybe use comma and plus for list of dates
#    Tue Jun 25, Wed Jun 26, Thu Jun 27  ??
#    Tue Jun 25 + Wed Jun 26 + Thu Jun 27  ??
#
#   add back optional comma (before) year - why? why not?
#


##
#   todo add plus later on - why? why not?
###   todo/fix  add optional comma (,) before year

### regex note/tip/remindr -  \b () \b MUST always get enclosed in parantheses
##                                     because alternation (|) has lowest priority/binding


DURATION_I_RE =  %r{
(?<duration>
    \b
  (?:
   ## optional day name
   ((?<day_name1>#{DAY_NAMES})
      [ ]
   )?
   (?<month_name1>#{MONTH_NAMES})
      [ ] 
   (?<day1>\d{1,2})
   ## optional year
   (  ,?   # optional comma
      [ ]
      (?<year1>\d{4})
   )?

   ## support + and -  (add .. or such - why??)
   [ ]* - [ ]*

   ## optional day name
   ((?<day_name2>#{DAY_NAMES})
      [ ]
   )?
   (?<month_name2>#{MONTH_NAMES})
      [ ] 
   (?<day2>\d{1,2})
   ## optional year
   (  ,?   # optional comma
      [ ]
      (?<year2>\d{4})
   )?
  )
   \b
)}ix



#   FIX - remove this variant 
#         "standardize on month day [year]" !!!!

=begin
###
#   variant ii
# e.g. 26 July - 27 July
#      26 July, 
XXX_DURATION_II_RE =  %r{
(?<duration>
    \b
  (?
   ## optional day name
   ((?<day_name1>#{DAY_NAMES})
      [ ]
   )?
   (?<day1>\d{1,2})
      [ ]
   (?<month_name1>#{MONTH_NAMES})
   ## optional year
   (  
       [ ]
      (?<year1>\d{4})
   )?

   ## support + and -  (add .. or such - why??)
   [ ]*[-][ ]*

   ## optional day name
   ((?<day_name2>#{DAY_NAMES})
      [ ]
   )?
   (?<day2>\d{1,2})
      [ ]
   (?<month_name2>#{MONTH_NAMES})
   ## optional year
   ( [ ]
      (?<year2>\d{4})
   )?
  )
   \b
)}ix
=end


#  variant ii
#  add support for shorthand
#     August 16-18, 2011     
#     September 13-15, 2011
#      October 18-20, 2011
#      March 6-8 2012
#      March 6-8
#     
#   - add support for August 16+17 or such (and check 16+18)
#       use <op> to check if day2 is a plus or range or such - why? why not?

DURATION_II_RE =  %r{
(?<duration>
    \b
   (?:
       (?<month_name1>#{MONTH_NAMES})
           [ ]
        (?<day1>\d{1,2})
             -
        (?<day2>\d{1,2})
          (?:
            ,?     ## optional comma
            [ ]
            (?<year1>\d{4})
          )?     ## optional year   
   )
   \b
)}ix



#############################################
# map tables
#  note: order matters; first come-first matched/served
DURATION_RE = Regexp.union(
   DURATION_I_RE,
   DURATION_II_RE,
)


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
def _build_duration(m) self.class._build_duration( m ); end


end  #   class Lexer
end  # module SportDb

