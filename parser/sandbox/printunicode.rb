
def ppchars(str)
     puts
    pp str
  str.each_char do |ch|
    puts "%s => U+%04X (%d)" % [ch, ch.ord, ch.ord]
  end
end



str =  "Alexis MAC ALLISTER"
ppchars(str)
str = "Henry MA"
ppchars(str)
#   => U+00A0 (160)   -- No-Break Space (unicode)

str = "Henry MA"
ppchars(str)
#   => U+0020 (32)    -- ascii - Space

str = "-–−"
ppchars(str)
# - => U+002D (45)       -- ascii - Hyphen-Minus 
# – => U+2013 (8211)     -- En Dash     (unicode) 
# − => U+2212 (8722)     -- Minus Sign  (unicode)

puts "bye"




