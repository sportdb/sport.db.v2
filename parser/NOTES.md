
# Quick Notes



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