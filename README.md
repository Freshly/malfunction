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
  address_verification_malfunction = AddressVerificationMalfunction.build(address)
  address_verification_malfunction.zipcode_mismatch = service.zipcode_mismatch?
end
```

## Usage

TODO: Write usage instructions here

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/Freshly/malfunction.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
