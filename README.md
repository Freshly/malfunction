# Malfunction

An extensible way to encapsulate the variety of BadStuff that happens in Rails applications

[![Gem Version](https://badge.fury.io/rb/malfunction.svg)](https://badge.fury.io/rb/malfunction)
[![Build Status](https://semaphoreci.com/api/v1/freshly/malfunction/branches/develop/badge.svg)](https://semaphoreci.com/freshly/malfunction)
[![Maintainability](https://api.codeclimate.com/v1/badges/9cd538174249bb6b1798/maintainability)](https://codeclimate.com/github/Freshly/malfunction/maintainability)
[![Test Coverage](https://api.codeclimate.com/v1/badges/9cd538174249bb6b1798/test_coverage)](https://codeclimate.com/github/Freshly/malfunction/test_coverage)

* [Installation](#installation)
* [Usage](#usage)
* [Development](#development)
* [Contributing](#contributing)
* [License](#license)

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'malfunction'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install malfunction

## What is Malfunction?

Malfunctions are a framework for describing more sophisticated errors for Ruby on Rails and Gems.

Automated error handling becomes easier and more extensible using Malfunctions; this is their primary use case.

Malfunctions must be configured specifically for your gem or application and provides no out-of-the-box value.

## Getting Started

⚠️ *HEADS UP!*: Use `.build` and NOT `.new` to create instances of Malfunction!

Within your application, create a `malfunctions` directory and create an `application_malfunction.rb`:

```ruby
class ApplicationMalfunction < Malfunction::MalfunctionBase; end
```

From here, you can define all your application specific errors. 

An example case, a user tries to add an address which fails verification by a third party adding validation errors:

```ruby
class AddressVerificationMalfunction < ApplicationMalfunction
  # Indicates this malfunction will have errors on attributes (helpful to passthru active record error data)
  uses_attribute_errors
  
  # Contextualize the "broken" object passed into malfunction so you can reference it by this given name vs "context"
  contextualize :address
  
  # If true the service determined all the data was true but the user likely typed their zipcode in wrong; common issue
  attr_accessor :zipcode_mismatch
  
  def zipcode_mismatch?
    @zipcode_mismatch
  end

  # The malfunction is built after being initialized with the context object and any details
  on_build do
    address.errors.each do |active_record_error|
      add_attribute_error(active_record_error.attribute, active_record_error.type, active_record_error.full_message)
    end
  end
end
```

This allows you to create a malfunction describing the problem:

```ruby
address = Address.new(address_params)
service = AddressVerificationService.new(address)
unless service.verified?
  malfunction = AddressVerificationMalfunction.build(address)
  malfunction.zipcode_mismatch = service.zipcode_mismatch?
end
```

The `malfunction` object can now be used in error handling:

```erb
<% if malfunction.present? %>
  <div class="alert alert-warning">
    <p>Your address could not be verified! Please check your details and resubmit.<p>
  
    <% if malfunction.zipcode_mismatch %>
      <p><strong>Seems like your zipcode may be wrong?. Maybe check that!</strong><p>
    <% else %>
  
    <p>If everything looks correct, click the "Looks okay to me" checkbox to continue!</p>
  </div>
  
  <%= simple_form_for malfunction.address do |form| %>
    <% if malfunction.attribute_errors? %>
      <div class="alert alert-error">
        <p>The following fields could not be verified:</p>
        <ul>
          <% malfunction.attribute_errors.each do |attribute_error| %>
            <li><%= attribute_error.attribute_name %></li>
          <% end %>
        </ul>
      <div>
    <% end %>
    
    ...
  <% end %>
<% end %>
```

## Malfunction Development

Your gem or application should define as many malfunctions as it needs to properly define it's defect states.

Malfunctions are flexible objects which provide a few base configuration options to help you define your defects.

The simplest Malfunction you can define has no configuration options and essentially defines a specific issue.

```ruby
class SimpleMalfunction < ApplicationMalfunction; end
```

In gem development this pattern may see use for consistency in emitting clear information about defect states.

However within an application context "featureless" malfunctions should be used sparingly and are a code smell.

### Contextualization

Malfunctions should always, if possible, `contextualize` the object they're initialized with.

Without contextualization, no reference object can be provided, or an argument error will be raised:

```ruby
class WidgetMalfunction < ApplicationMalfunction; end

malfunction = WidgetMalfunction.build(Widget.last) # => raises ArgumentError
```

With contextualization, you can reference the type of object directly or with the `@context` accessor:

```ruby
class WidgetMalfunction < ApplicationMalfunction
  contextualize :widget
end

malfunction = WidgetMalfunction.build(Widget.find(3))
malfunction.widget.id # => 3
malfunction.context.id # => 3
```

Contextualization assumes a required object and an argument error will be raised if it is NOT present:

```ruby
class WidgetMalfunction < ApplicationMalfunction
  contextualize :widget
end

malfunction = WidgetMalfunction.build # => raises ArgumentError
```

If you want to allow nil values with contextualized malfunctions you must specify that with the `allow_nil` flag:

```ruby
class WidgetMalfunction < ApplicationMalfunction
  contextualize :widget, allow_nil: true
end

malfunction = WidgetMalfunction.build
malfunction.context # => nil
malfunction.widget # => nil
```

### Problem Name

Malfunctions use the [Conjunction Junction](https://github.com/Freshly/spicerack/tree/develop/conjunction) gem.

This gives access to a `prototypical name` which is a fancy way of saying "the class name without Malfunction".

So if your class name `ChumbleWumbleBumbleMalfunction` its prototypical name is `ChumbleWumbleBumble`.

This name is used to auto define the `problem` that your malfunction represents.

📝 *Note!*: `.problem` is both a class and instance method so you can inspect it without instantiating.

```ruby
# terrible name
class WidgetMalfunction < ApplicationMalfunction; end

# great name
class InvalidStateMalfunction < ApplicationMalfunction; end

WidgetMalfunction.problem # => :widget
InvalidStateMalfunction.problem # => :invalid_state
```

The intent of this accessor is when you are downstream and have been given an unknown `malfunction` object to handle:

```ruby
case malfunction.problem
when :widget
  raise PoorlyNameMalfunctionError
when :invalid_state
  render json: { flow: malfunction.flow, state: malfunction.flow.state }
else
  raise CrazyNonsenseError
end
```

🚨 *ALERT!* If you choose to namespace your objects, you have to tell `Conjunction::Junction` how you want to handle it.

By default it will simply prepend the namespace to your prototypical name. If this is what you want, you're welcome.

```ruby
class GenericNamespace::InvalidStateMalfunction < ApplicationMalfunction; end

GenericNamespace::InvalidState.problem # => :generic_namespace_invalid_state
```

Otherwise, you need to tell `Conjunction::Junction` what namespace is being sanitized out of the filesystem.

```ruby
class GenericNamespace::InvalidStateMalfunction < ApplicationMalfunction
  prefixed_with "GenericNamespace::"
end

GenericNamespace::InvalidState.problem # => :invalid_state
```

If letting names automagically define the problem rubs you the wrong way, you can explicitly define the problem:

```ruby
class InvalidStateMalfunction < ApplicationMalfunction
  def self.problem
    :my_explicit_problem
  end
end

InvalidStateMalfunction.problem # => :my_explicit_problem
```

I don't recommend this of course.

Reasons for why can be found throughout my manifesto, which I've disguised as the docs to the Conjunction Junction gem.

### Attribute Errors

Attribute errors are very similar to ActiveRecord validation errors.

The reason these are not literally ActiveRecord validation errors is twofold:

(1) turns out ActiveRecord validation errors are kind of inflexible to use generically.
(2) sometimes you don't have an actual validation error you just have a problem on the field of an object.

So generally; to be more precise and not improperly say "this attribute error is a validation error" when it wasn't.

To utilize attribute errors, you must declare as a class configuration that your Malfunction will use them.

```ruby
class IllegalOperationMalfunction < ApplicationOperation
  uses_attribute_errors
end
```

Attribute errors are not pre-defined or limited in anyway, as each Malfunction instance represents a unique error state.

Once a Malfunction is denoted to use attribute errors, all it's descendants automatically use them as well:

```ruby
class UserRequestMalfunction < ApplicationOperation
  uses_attribute_errors
end

class PasswordResetMalfunction < UserRequestMalfunction; end

UserRequestMalfunction.uses_attribute_errors? # => true
PasswordResetMalfunction.uses_attribute_errors? # => true
```

Once instantiated, attribute errors may be added to it at any time and in any order:

```ruby
malfunction = UnprocessibleOrderMalfunction.build(order)
malfunction.attribute_errors? # => false
malfunction.attribute_errors.length # => 0

# this is why attribute errors are their own object; allowing simple custom errors on attribute fields
malfunction.add_attribute_error(:shipping_address_id, :no_shipping_options) unless order_service.shipping_options?
malfunction.attribute_errors.length # => 1

# attribute errors play nicely with active record validation errors; this is a very common line to map one to the other
order.errors.each { |error| malfunction.add_attribute_error(error.attribute, error.type, error.full_message) }
malfunction.attribute_errors? # => true

# error objects can be pulled out of the collection and used directly
first_attribute_error = malfunction.attribute_errors.first
first_attribute_error.attribute_name # => :shipping_address_id
first_attribute_error.error_code # => :no_shipping_options
first_attribute_error.message # => nil

# attribute errors can be compared with each other / themselves
first_attribute_error == malfunction.attribute_errors.first # => true
```

Attempting to use attribute errors without first declaring it on the class will result in argument errors:

```ruby
class NonArgumentErrorMalfunction < ApplicationMalfunction; end 

malfunction = NonArgumentErrorMalfunction.build
malfunction.add_argument_error(:foo, :bar) # => raises ArgumentError
```

### Building

⚠️ *HEADS UP!*: Use `.build` and NOT `.new` to create instances of Malfunction!

Malfunctions assume the context provides the information needed to fill out all its details.

To facilitate shaping Malfunction objects completely on instantiation there is a build hook.

```ruby
class InvalidStateMalfunction < ApplicationMalfunction
  uses_attribute_errors
  
  contextualize :state
  
  on_build do
    state.errors.each { |error| add_attribute_error(error.attribute, error.type, error.full_message) }
  end
end

# using build
malfunction = InvalidStateMalfunction.build(state)
malfunction.attribute_errors? # => true

# using new doesn't automatically build...
malfunction = InvalidStateMalfunction.new(state)
malfunction.attribute_errors? # => false

# however build CAN be called manually!
malfunction.build
malfunction.attribute_errors? # => true
```

The normal expected use is to just instantiate your malfunctions with the `.build` class accessor.

This instantiates and calls build for you in one action as a convenience pattern.

### Details

While not technically a configuration option, Malfunctions also provide an arbitrary hash of details at instantiation.

These are passed either in addition to the context object:

```ruby
class ContextualizedMalfunction < ApplicationMalfunction
  contextualized :object
end

malfunction = UncontextualizedMalfunction.build(something, details: { issue: :yep, problem: :most_definitely })
malfunction.details[:issue] # => :yep
malfunction.details[:problem] # => :most_definitely
```

Or in lieu of the context object:

```ruby
class UncontextualizedMalfunction < ApplicationMalfunction; end

malfunction = UncontextualizedMalfunction.build(details: { issue: :yep, problem: :most_definitely })
malfunction.details[:issue] # => :yep
malfunction.details[:problem] # => :most_definitely
```

If no details are given or used, the value will always be an empty hash:

```ruby
class ContextualizedMalfunction < ApplicationMalfunction
  contextualized :object
end

malfunction = ContextualizedMalfunction.build(something)
malfunction.details[:issue] # => nil
malfunction.details[:problem] # => nil
```

## Testing

Add the following to your `spec/rails_helper.rb` file:

```ruby
require "malfunction/spec_helper"
```

This will allow you to use the following custom matchers:

* [contextualize_as](lib/malfunction/rspec/custom_matchers/contextualize_as.rb) tests usage of the default `MalfunctionBase.contextualize`
* [define_problem](lib/malfunction/rspec/custom_matchers/define_problem.rb) tests usage of `MalfunctionBase.problem`
* [have_default_problem](lib/malfunction/rspec/custom_matchers/have_default_problem.rb) tests usage of the default `MalfunctionBase.problem`
* [use_attribute_errors](lib/malfunction/rspec/custom_matchers/use_attribute_errors.rb) tests usage of `MalfunctionBase.uses_attribute_errors`

### Testing Malfunctions

Malfunctions are simple objects with defined shapes that benefit from unit tests.

It is recommended you assert their expected shape and configuration within a test.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/Freshly/malfunction.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
