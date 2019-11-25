# frozen_string_literal: true

require_relative "malfunction/core"
require_relative "malfunction/attribute_errors"

module Malfunction
  class MalfunctionBase < Spicerack::RootObject
    include Conjunction::Junction
    suffixed_with "Malfunction"

    include Malfunction::Core
    include Malfunction::AttributeErrors
  end
end
