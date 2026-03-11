## Notes


## regex notes

```
(?=X)	Positive lookahead	"Ruby"[/.(?=b)/] #=> "u"
(?!X)	Negative lookahead	"Ruby"[/.(?!u)/] #=> "u"
(?<=X)	Positive lookbehind	"Ruby"[/(?<=u)./] #=> "b"
(?<!X)	Negative lookbehind	"Ruby"[/(?<!R|^)./] #=> "b"

  see https://idiosyncratic-ruby.com/11-regular-extremism.html
```


## racc lexer notes

When the parser calls `next_token` on the tokenizer, 
it expects a two element array or a nil to be returned. 
The first element of the array must contain the name of the token, 
and the second element can be anything (but most people just add the matched text). 
When a nil is returned, that indicates there are no more tokens 
left in the tokenizer.

- <https://practicingruby.com/articles/parsing-json-the-hard-way>
- <https://martinfowler.com/bliki/HelloRacc.html>






