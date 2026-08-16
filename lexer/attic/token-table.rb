
## todo/check - compact version in use? collect "real-world" samples!!!
##        Pld GF-GA Pts         |  d d-d d
## 
TABLE_III_RE = %r{
        (?<table>\b 
             \d{1,2} [ ]+                        # Pld
             (?: \d{1,3} - [ ]* \d{1,3} [ ]+)    # GF-GA
             \d{1,3}                             # Pts   
              \b 
        )}ix

