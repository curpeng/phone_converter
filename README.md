# PhoneConverter

## .covert(number)
Converts 10 digit phone number to all possible words or
combination of words from the provided dictionary.

Example:
```ruby
PhoneConverter.convert(6686787825)
#=> [["noun", "struck"], ["onto", "struck"], ["motor", "usual"], ["nouns", "truck"], ["nouns", "usual"], "motortruck"]
```      

How to run:
```bash
irb -r ./lib/phone_converter.rb
PhoneConverter.convert(6686787825)
```

Run tests:

```bash
bundle exec rspec spec
```
