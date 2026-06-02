require 'cocos'




def read_pack( path )
    txt = read_text( path )

    h={}
    recs = nil
    path = nil

    txt.each_line do |line|
      line = line.strip
      next if line.start_with?('#') || line.empty?

      ######
      ## check if header
      if m= %r{^\[
               (.+?)
            \]$
           }x.match(line)

        keys = m[1].strip.split(  /[ ]*\|[ ]*/ )
        path = nil
        recs = []
        keys.each {|key| h[key] = recs }
      elsif m= %r{^
                 ([^ :]+?)
                [ ]*
                 :
                $
               }x.match(line)
        path = m[1]
      else
        name =  if path
                  File.join( path, line )
              else
                  line
              end
       recs << name
      end
    end

    h
end



h = read_pack( './filepack.txt' )

pp h

puts "bye"