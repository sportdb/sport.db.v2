##############
#  date & time rules / productions


    ##
    ## note - date incl. may be "standalone" year only
    ##               e.g.  1986   etc.
    date
      :   DATE    { result = { date: val[0].value } }
      |   YEAR    { result = { year: val[0].value } }

    ##  check if we need to return a copy of the hash that later gets modified
    ##                 or if we can pass along the "original" token hash value
    datetime
      :   DATETIME              { result = val[0].value  }

    time
      :   TIME                  { result = val[0].value  }


     ## note - does NOT incl. time only  (BUT incl. datetime!)
     ##   todo/check - rename to date_or_datetime - why? why not?
       ##   yes - rename to date_datetime / date_or_datetime  !!!
    date_clause
      :  date
      |  datetime



    ## rename to opt_date_datetime_time or such - why? why not?
    opt_date
      :         {  result = {} }      ## optional; empty
      ## | date
      ## | datetime
      | date_clause    #  note: is same as date | datetime
      | time




        ## note - only one option (DATE) allowed for "standalone" header now
        ##            use match header (with geo tree)

        date_header
              :     date  NEWLINE
                  {
                     @tree <<  DateHeader.new( **val[0] )
                  }

        date_header_legs
             :     DATE_LEGS  NEWLINE
                  {
                     kwargs =  val[0].value
                     @tree <<  DateHeaderLegs.new( **kwargs )
                  }
