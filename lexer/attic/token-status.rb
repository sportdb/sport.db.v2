

         verified   ##=>  use awarded - why? why not?
             ## e.g.  [verified 2:0 wo.]
   


        verified     ### todo/fix - add status upstream (same as awarded??) - why? why not? 
                            ###  move to note(s) - do NOT interpret as status - why? why not?
                            ##   check - verified bascially a synonym for awarded - yes/no?
                            ##  q:  what's the difference of the match stati
                            ##            awarded 2-0 and verified 2-0 ???
 

         (?: originally[ ])? scheduled
          ## e.g. [originally scheduled to play in Mexico City] 
          |
 
          played  
          ## e.g. [played in Macaé-RJ]
          ##      [played in Caxias do Sul-RS]
          ##      [played in Sete Lagoas-MG]
          ##      [played in Uberlândia-MG]
          ##      [played in Brasília-DF]
          ##      [played in Vöcklabruck]
          ##      [played in Pasching]
          |

          (?:
            ## starting with in  - do NOT allow digits
            ##   name starting with in possible - why? why not?
                in[ ]
                 [^0-9\]]+?
            ## e.g. [In Estadio La Corregidora] 
            ##      [in Unidad Deportiva Centenario]
            ##      [in Estadio Olímpico Universitario]
            ##      [in Estadio Victoria]
            ##      [in UD José Brindis]
            ##      [in Colomos Alfredo "Pistache" Torres stadium]
            ##
            ##  TODO/FIX
            ##     remove in ?? - is same as @ Estadio Victoria and such - why? why not= 
          )
     

          |
          inter-group
          ## e.g. [inter-group A-B]
          ##      [inter-group C-D]

