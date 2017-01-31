# EasyBreadcrumbs

Provides an `easy_breadcrumbs` view helper for automatically generating bootstrap breadcrumbs for your Sinatra Application.

* It's able to properly generate the html for many different types of complex routes (See Below).
* It only generates breadcrumbs for the routes you've defined, so if you have a route `/categories/10/contacts/5`, but haven't defined an index view route for `/categories`, that item will be left out.

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

### Step 1

If you're building a classic style Sinatra app, simply add this line to your sinatra application file:

    require "easy_breadcrumbs"

If you're building a modular style Sinatra app, you'll also need to explicitly register the module within your application.

    class HelloApp < Sinatra::Base
      helpers Sinatra::EasyBreadcrumbs

      get "/hello" do
        h "1 < 2"
      end
    end

### Step 2

And then use the helper method in your layout or view:
    
    <%= easy_breadcrumbs %>

### Step 3

And last but not least, make sure you have bootstrap installed. You can install bootstrap's css by adding this line to your applications layout template.

    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0-alpha.5/css/bootstrap.min.css" integrity="sha384-AysaV+vQoT3kOAXZkl02PThvDr8HYKPZhNT5h/CXfBThSRXQ6jW5DO2ekP5ViFdi" crossorigin="anonymous">

## Details

Easy Breadcrumbs is able to handle a variety of complex routes. Here are some examples:

### Simple path to page
```
Path: /about
Breadcrumb: Home > About
```

### Path to resource index page
```
Path: /contacts
Breadcrumb: Home > Contacts
```

###Path to specific resource
```
Path: /contacts/28
Breadcrumb: Home > Contacts > Contact
```

### Path to resource new view
```
Path: /contacts/new
Breadcrumb: Home > Contacts > New Contact
```

### Path to edit specific resource
```
Path: /contacts/28/edit
Breadcrumb: Home > Contacts > Contact > Edit Contact
```

### Path to nested resource index page
```
Path: /categories/5/contacts
Breadcrumb: Home > Categories > Category > Contacts
```

### Path to specific nested resource
```
Path: /categories/5/contacts/10
Breadcrumb: Home > Categories > Category > Contacts > Contact
```

### Path to nested resource new view
```
Path: /categories/5/contacts/new
Breadcrumb: Home > Categories > Category > Contacts > New Contact
```

### Path to edit specific nested resource
```
Path: /categories/5/contacts/10/edit
Breadcrumb: Home > Categories > Category > Contacts > Contact > Edit Contact
```

## Road Map

* Refactor and cleanup
  * Change `Breadcrumb` class to `Breadcrumbs`. This class will be responsible for the logic of which type of format to use for each breadcrumb
  * Create new `Breadcrumb` class. This class will be responsible for the implementation details of formatting each type of breadcrumb.
  * Add version restictions for dependencies in gemspec
* More robust spec suite
  * Explore more edge cases for both unit and integration tests
  * Eliminate repetition in specs
  * Other developments gems that would help with this?

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/nerboda/easy_breadcrumbs.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

