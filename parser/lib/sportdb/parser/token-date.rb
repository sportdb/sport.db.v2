module SportDb
class Lexer



# e.g.  Fri Aug 9
#       Fri  Aug 9
##      Fri, Aug 9
##      Fri, Aug 9 2024
##      Fri, Aug 9, 2024
##           Aug 9, 2024
##           Aug 9, 2024
##   note - eat-up optional comma after DAY_NAMES!!
##
##      note - Fri Aug/9  no longer supported!!!
DATE_I_RE = %r{
(?<date>
  \b
     ## optional day name
     ((?<day_name>#{DAY_NAMES})
           (?: ,?[ ]+)
     )?
     (?<month_name>#{MONTH_NAMES})
          [ ]
     (?<day>\d{1,2})
          \b
     ## optional year
     (      ,? [ ]       ## note - comma optinal with single space required for now
            (?<year>\d{4})        ## optional year 2025 (yyyy)
              \b
     )?
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


###
# e.g. 3 June  or 10 June
##   note - allow more spaces between  DAY_NAMES and DAY e.g.
##    Sun  1 Mar
##    Wed  4 Mar
##    Sat 14 Mar
##    Sat 11 Apr
##    Sat 11 Apr 2021
##    Sat 11 Apr 21
##
##    Sat, 11 Apr
##   note - eat-up optional comma after DAY_NAMES!!
##
##  note - Sat 14 Mar 17:30
##          check two-digit year (with NEGATIVE lookahead for time!!!)

DATE_II_RE = %r{
(?<date>
  \b
     ## optional day name
     ((?<day_name>#{DAY_NAMES})
           (?: ,?[ ]+)
     )?
     (?<day>\d{1,2})
         [ ]
     (?<month_name>#{MONTH_NAMES})
          \b
     ## optional year
     (  [ ]
        (?:
           (?<year>\d{4})        ## optional year 2025 (yyyy)
               |
            (?:
               (?<yy>\d{2})           ## optional year 25 (yy)
                ## check NEGATIVE lookahead
               (?! :|[:h]\d{2})
            )
        )
        \b
     )?
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
          (?: ,?[ ]+)
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
           (?: ,?[ ]+)
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
### 04/03/2026  or 4/3/2026
##   04/03/26   or 4/3/26
##   04/03      or 4/3
DATE_IIIII_RE = %r{
(?<date>
  \b
     ## optional day name
     ((?<day_name>#{DAY_NAMES})
          (?: ,?[ ]+)
     )?
   (?<day>\d{1,2})
       /
   (?<month>\d{1,2})
    \b
   (?:
        /
       (?:
          (?<year>\d{4})         ## optional year 2025 (yyyy)
              |
          (?<yy>\d{2})           ## optional year 25 (yy)
       )
      \b
   )?
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



end  #   class Lexer
end  # module SportDb
