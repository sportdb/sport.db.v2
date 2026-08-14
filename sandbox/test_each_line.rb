

##
## note only    \r\n  AND \n matched for (new)line!!!
##       \r\n (cr+lf)  => WINDOWS
##          \n (lf)    => UNIX / UNIVERSAL
##
##            \r => cr - carriage return
##            \n => lf - line feed  (newline)

txt = "hello\r\n line2  \r\n\n\r\n  \n   another line"

puts txt
puts "---"
pp txt
puts "---"

txt.each_line do |line|
  pp line
end



txt = txt.gsub("\r\n", "\n" )  ## unify newlines (crlf => lf)

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