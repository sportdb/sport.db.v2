
##  (old) "inline" optional coach in lineup

    lineup_lines  : PROP  opt_formation  lineup  opt_coach  PROP_END



       ## add (factor out) coach_sep  - why? why not?

      ###
      ## todo/check - fix/fix/fix - COACH  gets matched with PROP_KEY ???
      ##    change COACH to INLINE_COACH - why? why not?
      ##   was
      ##    | ';' NEWLINE  COACH  PROP_NAME    ## note - allow newline break
      ##    | '-' NEWLINE  COACH  PROP_NAME    ## note - allow newline break

       opt_coach   : /* empty */    { result = {}  }    ## optional
                   | ';' COACH  PROP_NAME
                           {  result = { coach: val[2].as_str } }
                   | '-' COACH  PROP_NAME
                           {  result = { coach: val[2].as_str } }
