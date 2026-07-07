
module Fbtxt
class MatchTree

  def log( msg )
    ## append msg to ./logs.txt
    ##     use ./errors.txt - why? why not?
    File.open( './logs.txt', 'a:utf-8' ) do |f|
      f.write( msg )
      f.write( "\n" )
    end
  end


### check - rename last_year to running_last_year to make intent clearer - why? why not?
  def _build_date( m:, d:, y:, yy:, wday:,
                    start:,
                    last_year: )

    if m.nil? || d.nil?
      puts "[debug] !! ERROR - _build_date required month or day missing:"
      pp [m,d,y,yy,wday,start]
      exit 1
    end


   ## quick debug hack
   if m == 2 && d == 29
      puts "quick check  feb/29 dates"
      pp [d,m,y]
      pp start
   end


    ####
    ## support two digit shortcut for year
    if yy
      ###
      ## for now assume 00,01 to 30 is 2000,2001 to 2030
      ##   and          31 to 99   is  1931 to 1999
      y =   yy <= 30 ?  2000+yy : 1900+yy
    end


    if y.nil?   ## try to calculate year
      if last_year && @last_year   ## use new formula
         y = @last_year
      elsif start.nil?
         puts "!! ERROR - _build_date - year expected for (first) date; cannot infer/guess; sorry"
         exit 1
      else  ## fallback to "old" formula - FIX/FIX remove later
         ## puts "[deprecated] WARN - do NOT use old year (date) auto-complete; add year to first date"
         y =  if  m > start.month ||
                 (m == start.month && d >= start.day)
                  # assume same year as start_at event (e.g. 2013 for 2013/14 season)
                  start.year
              else
                  # assume year+1 as start_at event (e.g. 2014 for 2013/14 season)
                  start.year+1
              end
      end
    else
      ### note - reset @start to new date
      ##            use @last_year
      if last_year
        @last_year = y
        puts "  [debug] _build_date - set running last_year to #{y}"
      end
    end


      date = Date.new( y,m,d )  ## y,m,d

      ### todo/fix
      ###  check/validate  wday here

      date
  end

end  ## class MatchTree
end  ## module Fbtxt
