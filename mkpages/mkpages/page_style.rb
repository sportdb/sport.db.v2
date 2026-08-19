

def build_style( outdir: )

  css =<<CSS

a, a:visited {
  text-decoration: none;
}

a:hover {
  text-decoration: underline;
}


/*********
  reset h1,h2,h3,h4,h5,h6 formatting inside pre blocks
  ****/

  pre h1,
  pre h2,
  pre h3,
  pre h4,
  pre h5,
  pre h6 { /* color: red;  */
            font-size: 100%;
            margin: 0;
             }



   pre h1,
   pre h2,
   pre h3 {
      font-size: 150%;
   }

  pre h4 {
     /* add blue-ish background */
     background-color: #CCCCFF;
     padding-top: 1px;
     padding-bottom: 1px;
  }


  pre h5 {
            /* bold by default keep */
         }

 pre h6 {
            font-weight: normal;
            /* use underline */
            text-decoration: underline;
         }

   pre span.comment {
            color: green;
      }

CSS

   write_text( "#{outdir}/style.css", css )
end
