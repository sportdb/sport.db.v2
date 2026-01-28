module SportDb
class Lexer
  
##  (match) status
##    note: english usage - cancelled (in UK), canceled (in US)
##
##  add more variants - why? why not?

STATUS_RE = %r{
            \[
      (?:    
            ### opt 1 - allow long forms with note/comment for some stati
           (?: (?<status> awarded
             ## e.g. [awarded match to Leones Negros by undue alignment; original result 1-2]
             ##     [awarded 3-0 to Cafetaleros by undue alignment; originally ended 2-0]
             ##     [awarded 3-0; originally 0-2, América used ineligible player (Federico Viñas)]
                            |
                          annulled
                            |
                          abandoned
             ## e.g. [abandoned at 1-1 in 65' due to cardiac arrest Luton player Tom Lockyer]
             ##      [abandoned at 0-0 in 6' due to waterlogged pitch]
             ##     [abandoned at 5-0 in 80' due to attack on assistant referee by Cerro; result stood]
             ##    [abandoned at 1-0 in 31']
             ##    [abandoned at 0-1' in 85 due to crowd trouble]
                            |
                          postponed
             ## e.g. [postponed due to problems with the screen of the stadium]
             ##      [postponed by storm]
             ##      [postponed due to tropical storm "Hanna"]
             ##      [postponed from Sep 10-12 due to death Queen Elizabeth II]
                           |
                        suspended
             ## e.g. [suspended at 0-0 in 12' due to storm]  
             ##      [suspended at 84' by storm; result stood]
                           |
                         verified
             ## e.g.  [verified 2:0 wo.]
   

               ) [ ;,]* (?<status_note> [^\]]+ )
                 [ ]*
            )
            |
        
            ###################
            ## opt 2 - short from only (no note/comments)
            (?<status>
               cancelled|canceled|can\.
                 |
               abandoned|abd\.
                 |
               postponed
                 |
               awarded|awd\.
                 |
               walkover|w/o      ## add o/w too - why? why not?
                 |
               replay
                 |
               annulled
                 |
               suspended    ### todo/fix - add status upstream - why? why not?
                            ###  move to note(s) - do NOT interpret as status - why? why not?
                 |
               verified     ### todo/fix - add status upstream (same as ??) - why? why not? 
                            ###  move to note(s) - do NOT interpret as status - why? why not?
            )
      )
    \]
}ix

end  #  class Lexer
end  # module SportDb
  