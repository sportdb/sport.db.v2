

###  16.00 => 16:00
##     todo/check - use space for positive lookbehind & ahead
##                      (instead of \b) - why? why not?
##  note - check for/exclude 12.12.  and 12.12.96  date in match
##             use negative lookahead
FIX_TIME_RE = %r{
                  ## check NEGATIVE lookbehind
                  (?<! [.])  ## do NOT match 12.94 in 12.12.94

                     \b
                   (\d{1,2})
                      \.
                   (\d{2})
                    \b

                 (?! [.] )   ## do NOT match 12.12.
            }ix

FIX_TIME_REPLACE = '\1:\2'





FIX_DATE_WDAY_MMM_DD_RE = %r{
                           \[
                                [ ]*  ## optional spaces
                           (?:    ## optional weekday
                              (?<wday>
                                  Mon|Mo|
                                  Tue|Tu|
                                  Wed|We|
                                  Thu|Th|
                                  Fri|Fr|
                                  Sat|Sa|
                                  Sun|Su)
                              [ ]+
                            )?
                           (?<month>
                               Jan|
                               Feb|
                               March|Mar|
                               April|Apr|
                               May|
                               June|Jun|
                               July|Jul|
                               Aug|
                               Sept|Sep|
                               Oct|
                               Nov|
                               Dec)
                              [/ ]+      ## allow spaces ( ) or slash (/)
                           (?<day> \d{1,2})
                           [ ]*      ## optional spaces
                        \]
            }ix


FIX_DATE_MMM_DD_RE = %r{     \b
                           (Jan|
                            Feb|
                            March|Mar|
                            April|Apr|
                            May|
                            June|Jun|
                            July|Jul|
                            Aug|
                            Sept|Sep|
                            Oct|
                            Nov|
                            Dec)
                             /
                           (\d{1,2})
                           \b
            }ix

FIX_DATE_MMM_DD_REPLACE = '\1 \2'







def fix_dates( txt )

   ##  change dot (.) to colon (:)
   ##  16.00  =>  16:00
   txt = txt.gsub( FIX_TIME_RE, FIX_TIME_REPLACE )

   ##  [Sat Sep/12]  =>  Sat Sep 12
   ##  [Sat Sep 12]  =>  Sat Sep 12
   ##  [Sep/12]      =>  Sep 12
   ##  [Sep 12]      =>  Sep 12
   txt = txt.gsub( FIX_DATE_WDAY_MMM_DD_RE ) do |_|
               ## note - sub passes in string (!) NOT matchdata in arg (_)
               m = Regexp.last_match     ##  $~   ## is $LAST_MATCH_DATA

               if m[:wday]
                  "#{m[:wday]} #{m[:month]} #{m[:day]}"
               else
                   "#{m[:month]} #{m[:day]}"
               end
           end

  ##  remove slash in date
  ## Sep/12   =>  Sep 12
  txt = txt.gsub( FIX_DATE_MMM_DD_RE, FIX_DATE_MMM_DD_REPLACE )


  txt
end