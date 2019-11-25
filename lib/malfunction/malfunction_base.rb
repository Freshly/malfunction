# frozen_string_literal: true

require_relative "malfunction/attribute_errors"

module Malfunction
  class MalfunctionBase < Spicerack::RootObject
    include Malfunction::AttributeErrors
  end
end
