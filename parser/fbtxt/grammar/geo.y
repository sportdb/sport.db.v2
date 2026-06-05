
###
##  geo tree
##
## e.g.  @ Parc des Princes, Paris
##       @ München


        geo   :  '@' geo_names               { result = { geo: val[1] } }

        geo_names
               :  GEO                         {  result = [val[0].as_str] }
               |  geo_names ',' GEO          {  result.push( val[2].as_str )  }



       opt_geo  :   { result = {} }    ## empty -- optional
                |  geo
