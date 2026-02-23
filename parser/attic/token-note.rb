

OLD_NOTE_RE = %r{
    \[ 
   (?<note>
     (?:
       #############  
       ##  starting with ___   PLUS requiring more text
       (?:
          nb:
          ##  e.g. [NB: between top-8 of regular season]
          #        [NB: América, Morelia and Tigres qualified on better record regular season]
          #        [NB: Celaya qualified on away goals]
          #        [NB: Alebrijes qualified on away goal]
          #        [NB: Leones Negros qualified on away goals]
          ##      
          # todo/fix:
          # add "top-level" NB: version
          ##   with full (end-of) line note - why? why not?
    
          ###   keep  this special cases - why? why not?
          ###    always start with nb: or note: or such - why? why not?
          |
          rescheduled
          ## e.g.  [rescheduled due to earthquake occurred in Mexico on September 19]
          |
          declared
          ## e.g.  [declared void]
          |
          remaining
          ## e.g. [remaining 79']   
          ##      [remaining 84'] 
          ##      [remaining 59']   
          ##      [remaining 5']
       )
      [ ]
      [^\]]+?    ## slurp all to next ] - (use non-greedy) 
     )
   )
   \] 
}ix    
