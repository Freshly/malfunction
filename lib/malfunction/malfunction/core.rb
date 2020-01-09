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

      def initialize(context = nil, details: nil)
        self.context = context
        self.details = details
      end

      private

      def context=(context)
        if context.nil?
          raise ArgumentError, "#{self.class.name} requires context" if contextualized? && !allow_nil_context?
        else
          raise ArgumentError, "#{self.class.name} is not contextualized" unless contextualized?
        end

        @context = context
      end

      def details=(details)
        raise ArgumentError, "details is invalid" unless details.nil? || details.respond_to?(:to_hash)

        @details = details.presence&.to_hash || {}
      end
    end
  end
end
