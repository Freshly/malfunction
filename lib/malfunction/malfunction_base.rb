# frozen_string_literal: true

require_relative "malfunction/attribute_errors"
require_relative "malfunction/context"
require_relative "malfunction/core"

module Malfunction
  class MalfunctionBase < Spicerack::RootObject
    include Conjunction::Junction
    suffixed_with "Malfunction"

    include Malfunction::AttributeErrors
    include Malfunction::Context
    include Malfunction::Core
  end
end
