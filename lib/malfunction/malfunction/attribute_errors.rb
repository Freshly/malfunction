# frozen_string_literal: true

module Malfunction
  module Malfunction
    module AttributeErrors
      extend ActiveSupport::Concern

      included do
        delegate :uses_attribute_errors?, to: :class
        memoize :attribute_errors
      end

      class_methods do
        def uses_attribute_errors?
          @uses_attribute_errors.present?
        end

        def inherited(base)
          base.uses_attribute_errors if uses_attribute_errors?
          super
        end

        protected

        def uses_attribute_errors
          @uses_attribute_errors = true
        end
      end

      def attribute_errors?
        attribute_errors.present?
      end

      def attribute_errors
        AttributeErrorCollection.new if uses_attribute_errors?
      end

      def add_attribute_error(attribute_name, error_code, message = nil)
        raise ArgumentError, "#{self.class.name} does not use attribute errors" unless uses_attribute_errors?

        attribute_errors << AttributeError.new(attribute_name: attribute_name, error_code: error_code, message: message)
      end
    end
  end
end
