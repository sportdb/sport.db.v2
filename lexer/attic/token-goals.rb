


###
##  e.g.  (-; Metzger)
GOAL_NONE_RE = %r{ (?<goals_none>
                        -[ ]*;
                    )
                 }x




=begin
                       # check NEGATIVE lookahead
                       (?!
                             ##  exclude ord
                             (?: \d+ \))
                                 |
                            ## exclude score - goal_line_alt!!!
                             (?: [ ]* \b
                                        \d-\d   ## score e.g. 1-0
                                      \b  )
                       )
=end


=begin
MINUTE_RE = %r{
     (?<minute>
       (?<=[ (])	 # positive lookbehind for space or opening ( e.g. (61') required
                     #    todo - add more lookbehinds e.g.  ,) etc. - why? why not?
             (?<value>\d{1,3})      ## constrain numbers to 0 to 999!!!
                   (?: \+
                     (?<value2>\d{1,3})
                   )?
        '     ## must have minute marker!!!!
     )
}ix
=end
