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
        raise ArgumentError, "details is invalid" unless details.nil? || details.respond_to?(:to_hash)

        @details = details.presence&.to_hash || {}
      end
    end
  end
end
