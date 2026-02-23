
##
# for timezone format use for now:
# (BRT/UTC-3)      (e.g. brazil time)
#
# (CET/UTC+1)   - central european time
# (CEST/UTC+2)  - central european summer time  - daylight saving time (DST).
# (EET/UTC+1)  - eastern european time
# (EEST/UTC+2)  - eastern european summer time  - daylight saving time (DST).
#
# UTC+3
# UTC+4
# UTC+0
# UTC+00
# UTC+0000
#
#  - allow +01 or +0100  - why? why not
#  -       +0130 (01:30)
#
# see
#   https://en.wikipedia.org/wiki/Time_zone
#   https://en.wikipedia.org/wiki/List_of_UTC_offsets
#   https://en.wikipedia.org/wiki/UTC−04:00  etc.
#
#  e.g. (UTC-2) or (CEST/UTC-2) etc.
#    todo check - only allow upcase 
#    or  (utc-2) and (cest/utc-2) too - why? why not?
 
TIMEZONE_RE = %r{
  (?<timezone>
      \(
           ## optional "local" timezone name eg. BRT or CEST etc.
           (?:  [a-z]+
                 /
           )?
            [a-z]+
            [+-]
            \d{1,4}   ## e.g. 0 or 00 or 0000
      \)
   )
}ix



GEO_RE = Regexp.union(
    ##  note - timezone for now moved out of geo
    ##              (use after TIME or use TIME_LOCAL w/ optional TIMEZONE)
    ##                TIMEZONE_RE, 
                    GEO_BASICS_RE, 
                    GEO_TEXT_RE,
                    ANY_RE,
                      )

