# StatHat::Json

StatHat JSON API Client.

[![Build Status](https://travis-ci.org/nkeyes/stathat-json.png?branch=master)](https://travis-ci.org/nkeyes/stathat-json)
[![Gem Version](https://badge.fury.io/rb/stathat-json.png)](http://badge.fury.io/rb/stathat-json)
[![Dependency Status](https://gemnasium.com/nkeyes/stathat-json.svg)](https://gemnasium.com/nkeyes/stathat-json)
[![Code Climate](https://codeclimate.com/github/nkeyes/stathat-json/badges/gpa.svg)](https://codeclimate.com/github/nkeyes/stathat-json)
[![Test Coverage](https://codeclimate.com/github/nkeyes/stathat-json/badges/coverage.svg)](https://codeclimate.com/github/nkeyes/stathat-json)

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'stathat-json'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install stathat-json

## Usage
#### Batch post stats
```Ruby
require 'stathat/json'

StatHat::Json::Api.ez_key = 'YOUR_EZ_KEY' # will also be picked up from ENV['STATHAT_EZKEY']

stats = []
stats << {stat: 'count_stat1'} # implicit count and time
stats << {stat: 'count_stat2', count: 2, t: 1420428506} # explicit count and time
stats << {stat: 'value_stat1', value: 3.14159} # delicious Pi

StatHat::Json::Api.post_stats(stats)

```

#### Post individual stats
```Ruby
require 'stathat/json'

StatHat::Json::Api.ez_key = 'YOUR_EZ_KEY' # will also be picked up from ENV['STATHAT_EZKEY']

StatHat::Json::Api.post_count('count_stat1') # implicit count and time
StatHat::Json::Api.post_count('count_stat2', 2, 1420428506) # explicit count and time
StatHat::Json::Api.post_value('value_stat1', 3.14159) # delicious Pi

```
#### Short lived processes
`Stathat::Json::Api` uses [Celluloid::IO](https://github.com/celluloid/celluloid-io) for threading and async network IO for long runing processes.  
Use `Stathat::Json::SyncApi` for short lived processes, the API is identical.

## Tested with the following Rubies
* 1.9.3
* 2.0.0
* 2.1.0
* rbx-2.2.10
* jruby-19mode
* ruby-head
* jruby-head

## Contributing

1. Fork it ( https://github.com/[my-github-username]/stathat-json/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
