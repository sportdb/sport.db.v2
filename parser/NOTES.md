
# Quick Notes


## coach prop

```

- [ ]  simplify coach: property for now
          must be "top-level/standalone" for now
          add CoachLine or such
       and support multiple coaches like refs !!

##  supported for now coach/trainer (add manager?)
  if ['coach',
     'trainer'].include?( key.downcase )
## use PROP_COACH or COACH_KEY or such - why? why not?
  Token.new(:COACH, m[:key],
       lineno: ctx.lineno, offset: m.offset(:key))

- [ ] also check  attn, refs e.g.
         Attendance: 88_966
         Referee:    Szymon Marciniak (Poland)

note - keep only INLINE_ATTENDANCE for now
```


## prop specs

```
I would separate "property key classification" from "property mode"

Right now this:

if ['sent-off', 'sent off'].include?(key.downcase)
  @re = PROP_CARDS_RE
  tokens << Token.new(:PROP_SENTOFF, ...)
elsif ...

does two things simultaneously:

identifies the property
chooses how the following lines are tokenized

I'd introduce a property descriptor:

PropertySpec = Data.define(:token, :mode)

conceptually:

PROPERTY_SPECS = {
  'sent-off' => [:PROP_SENTOFF, :prop_cards],
  'red'       => [:PROP_REDCARDS, :prop_cards],
  'yellow'    => [:PROP_YELLOWCARDS, :prop_cards],
  ...
}

Then:

token, mode = PROPERTY_SPECS[key.downcase]
enter_mode(mode)
emit(token)

This would make the huge chain of special cases much easier to maintain.

```



- [x] up parser/grammar for
   - cards (incl. yellow/red/yellow-red/sent off)
   - goals (rm goals none; use goals array instead of goals1/2)
   - walkover (w/o); no longer special rule/production; uses std (not/played) match fixture
   - inline rounds (short/big) in matches (incl. match headers)
