
module Fbtxt
  module Model

### note - use inline Score class Match::Score - why? why not?
##      note - score might internally be an array [2,3]  -- now reported (!!)
##                 or hash { ft:, } etc.

## note - score for now might be
##            1) array e.g. [1,0] or []      --- now reported (!!)
##            2)  hash  e.g. { ft: [1,0] } etc.

    ## if node.score.is_a?(Array)
    ##    ## assume "undefined" score
    ##    score = node.score
    ##  else  ## (default) assume Hash
    ##     # ht = node.score[:ht] || [nil,nil]
    ##     # ft = node.score[:ft] || [nil,nil]
    ##     # et = node.score[:et] || [nil,nil]
    ##     # p  = node.score[:p]  || [nil,nil]
    ##     # values = [*ht, *ft, *et, *p]
    ##     # pp values
    ##     ## pp node.score
    ##    score = node.score
    ##  end
    ## end



class Score

def self.build( score )
  if score.nil?
        raise ArgumentError, "Score.build - expected Hash or Array; got nil"
  elsif score.is_a?(Hash)
      new( **score.transform_keys(&:to_sym) )
  elsif score.is_a?(Array)
       new( reported: score )
  else
       raise ArgumentError, "Score.build - expected Hash or Array; got type #{score} #{score.class.name}"
  end
end



attr_reader   :ht, :ft, :et, :p, :agg,
              :reported


def initialize( ht: nil, ft: nil, et: nil, p: nil,
                agg: nil,
               reported: nil,
               score: nil )
   @ht, @ft, @et, @p = ht, ft, et, p
   @agg = agg

   ##
   ## note: use reported for "generic" score where
   ##             period is not known (might be  full-time or aet)
   ##          or undefined e.g. for  abandoned or awarded (administered) score
   @reported = reported

   if score
      puts "!! DEPRECATED - score got score keyword (use reported):"
      pp [ ht, ft, et, p, agg, reported, score]
      @reported = score
   end
end

###
#   only know reported "vanilla" score  (might be full-time? extra-time? etc.)
def reported?()  @reported.is_a?( Array ) && @reported.size == 2; end


def ft?()  @ft.is_a?( Array ) && @ft.size == 2; end
def et?()  @et.is_a?( Array ) && @et.size == 2; end
def p?()   @p.is_a?( Array ) && @p.size == 2; end



def to_s
    if @reported
        ## check for ary empty - why? why not?
        "#{@reported[0]}-#{@reported[1]}"
    else
      if @et && @p
             if @ft && @ht
               "#{@et[0]}-#{@et[1]} a.e.t." +
               " (#{@ft[0]}-#{@ft[1]}, #{@ht[0]}-#{@ht[1]}), " +
               "#{@p[0]}-#{@p[1]} pen."
             elsif @ft
               "#{@et[0]}-#{@et[1]} a.e.t." +
               " (#{@ft[0]}-#{@ft[1]}), " +
               "#{@p[0]}-#{@p[1]} pen."
            else
               "#{@et[0]}-#{@et[1]} a.e.t., " +
               "#{@p[0]}-#{@p[1]} pen."
             end
      elsif @et && @p.nil?
             if @ft && @ht
                "#{@et[0]}-#{@et[1]} a.e.t."+
                " (#{@ft[0]}-#{@ft[1]}, #{@ht[0]}-#{@ht[1]})"
             elsif @ft
                "#{@et[0]}-#{@et[1]} a.e.t."+
                " (#{@ft[0]}-#{@ft[1]})"
             else
                "#{@et[0]}-#{@et[1]} a.e.t."
             end
      elsif  @ft &&  @et.nil? && @p.nil?
              if @ht
                "#{@ft[0]}-#{@ft[1]} (#{@ht[0]}-#{@ht[1]})"
              else
               "#{@ft[0]}-#{@ft[1]}"
              end
      else
           ## raise error/warn - about unknown (or empty) score type - why? why not?
            ''
      end
    end
end



def as_json(*)
    if @reported
        ## return array only - why? why not?
        ##   or use hash with  reported or _ - key - why? why not?
        @reported
    else
        h = {}
        h['ht']  = @ht     if @ht
        h['ft']  = @ft     if @ft
        h['et']  = @et     if @et
        h['p']   = @p      if @p
        h['agg'] = @agg    if @agg
        h
    end
end



end  # class Score


end # module Model
end # module Fbtxt