

txt = "hello\r\n line2  \r\n\n   another line"

puts txt
puts "---"
pp txt
puts "---"

txt.each_line do |line|
  pp line
end


puts "bye"

__END__

hello
 line2

   another line
---
"hello\r\n" + " line2  \r\n" + "\n" + "   another line"
---
"hello\r\n"
" line2  \r\n"
"\n"
"   another line"