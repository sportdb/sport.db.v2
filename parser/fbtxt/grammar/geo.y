
    opt_geo  :   { result = {} }   ## empty; optional
             |  geo_opts


        ##   fix-fix-fix
        ##  rename geo_opts  to simply geo - why? why not?
        ##       or keep because geo_opts - returns always hash for merge of options
        ##                  e.g. { geo: [] }


        ## e.g.  @ Parc des Princes, Paris
        ##       @ München
        geo_opts : '@' geo_values           { result = { geo: val[1] } }


        geo_values
               :  GEO                         {  result = [val[0].value] }
               |  geo_values ',' GEO          {  result.push( val[2].value )  }
