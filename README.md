# EasyBreadcrumbs

Provides an `easy_breadcrumbs` view helper for automatically generating bootstrap breadcrumbs for your Sinatra Application.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'easy_breadcrumbs'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install easy_breadcrumbs

## Usage

Simple add this line to your sinatra application file:

    require "easy_breadcrumbs"

And then use the helper method in your layout or view:
    
    <%= easy_breadcrumbs %>

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/nerboda/easy_breadcrumbs.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

