# frozen_string_literal: true

module Malfunction
  module Malfunction
    module Builder
      extend ActiveSupport::Concern

      included do
        define_callbacks_with_handler :build
      end

      class_methods do
        def build(*arguments)
          new(*arguments).build
        end
      end

      def build
        run_callbacks(:build) { self }
      end
    end
  end
end
