# frozen_string_literal: true

module Malfunction
  class AttributeError < Spicerack::InputObject
    argument :attribute_name
    argument :error_code

    def ==(other)
      super || other.try(:attribute_name) == attribute_name && other.try(:error_code) == error_code
    end
    alias_method :eql?, :==
  end
end
