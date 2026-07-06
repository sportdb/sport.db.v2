module SportDb
class MatchTree




  def on_date_header( node )
    _trace( "date header: >#{node}<")

    date = _build_date( m: node.date[:m],
                        d: node.date[:d],
                        y: node.date[:y],
                        yy: node.date[:yy],
                        wday: node.date[:wday],
                        start: @start,
                        last_year: true )

    _trace( "    date: #{date} with start: #{@start}")

      @last_date = date   # keep a reference for later use
      @last_time = nil

      ###  quick "corona" hack - support seasons going beyond 12 month (see swiss league 2019/20 and others!!)
      ##    find a better way??
      ##  set @start date to full year (e.g. 1.1.) if date.year  is @start.year+1
      ##   todo/fix: add to linter to check for chronological dates!! - warn if NOT chronological
      ###  todo/check: just turn on for 2019/20 season or always? why? why not?

      ## todo/fix: add switch back to old @start_org
      ##   if year is date.year == @start.year-1    -- possible when full date with year set!!!
=begin
      if @start.month != 1
         if date.year == @start.year+1
           _trace( "!! hack - extending start date to full (next/end) year; assumes all dates are chronologigal - always moving forward" )
           @start_org = @start   ## keep a copy of the original (old) start date - why? why not? - not used for now
           @start = Date.new( @start.year+1, 1, 1 )
         end
      end
=end
  end



end ## class MatchTree
end ##  module SportDb
