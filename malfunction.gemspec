# frozen_string_literal: true

lib = File.expand_path("lib", __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "malfunction/version"

Gem::Specification.new do |spec|
  spec.name          = "malfunction"
  spec.version       = Malfunction::VERSION
  spec.authors       = [ "Eric Garside" ]
  spec.email         = %w[garside@gmail.com]

  spec.summary       = "Define an standard way to handle the non-exceptional issues which occur in your application"
  spec.description   = "An extensible way to encapsulate the variety of BadStuff that happens in Rails applications"
  spec.homepage      = "https://github.com/Freshly/malfunction"
  spec.license       = "MIT"

  spec.files         = Dir["README.md", "LICENSE.txt", "lib/**/{*,.[a-z]*}"]
  spec.require_paths = "lib"

  spec.add_runtime_dependency "activesupport", ">= 5.2.1"
  spec.add_runtime_dependency "spicery", ">= 0.21.0", "< 1.0"

  spec.add_development_dependency "pry-byebug", ">= 3.7.0"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "simplecov", "~> 0.16"
  spec.add_development_dependency "timecop", ">= 0.9.1"
  spec.add_development_dependency "shoulda-matchers", "4.0.1"

  spec.add_development_dependency "rspice", ">= 0.21.0", "< 1.0"
  spec.add_development_dependency "spicerack-styleguide", ">= 0.21.0", "< 1.0"
end
