# frozen_string_literal: true

module Malfunction
  module Malfunction
    module Core
      extend ActiveSupport::Concern

      included do
        delegate :problem, to: :class
        attr_reader :details
      end

      class_methods do
        def problem
          prototype_name.underscore.to_sym
        end
      end

      def initialize(details = {})
        @details = details.presence || {}
      end
    end
  end
end
