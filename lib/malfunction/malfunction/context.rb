# frozen_string_literal: true

module Malfunction
  module Malfunction
    module Context
      extend ActiveSupport::Concern

      included do
        delegate :contextualized?, :allow_nil_context?, to: :class
        attr_reader :context
      end

      class_methods do
        attr_reader :contextualized_as

        def contextualized?
          @contextualized_as.present?
        end

        def allow_nil_context?
          contextualized? && @allow_nil_context
        end

        def inherited(base)
          base.contextualize(@contextualized_as, allow_nil: allow_nil_context?) if contextualized?
          super
        end

        protected

        def contextualize(contextualize_as, allow_nil: false)
          @contextualized_as = contextualize_as
          @allow_nil_context = allow_nil
          alias_method contextualize_as, :context
        end
      end
    end
  end
end
