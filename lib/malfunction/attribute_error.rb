# frozen_string_literal: true

module Malfunction
  class AttributeError < Substance::InputObject
    argument :attribute_name
    argument :error_code

    option :message

    def ==(other)
      super || other.try(:attribute_name) == attribute_name && other.try(:error_code) == error_code
    end
    alias_method :eql?, :==
  end
end
