# frozen_string_literal: true

# RSpec matcher that tests usage of the default `MalfunctionBase.uses_attribute_errors`
#
#     class FooMalfunction < Malfunction::Base
#       uses_attribute_errors
#     end
#
#     class BarMalfunction < Malfunction::Base
#     end
#
#     RSpec.describe FooMalfunction, type: :malfunction do
#       it { is_expected.to use_attribute_errors }
#     end
#
#     RSpec.describe BarMalfunction, type: :malfunction do
#       it { is_expected.not_to use_attribute_errors }
#     end

RSpec::Matchers.define :use_attribute_errors do
  match { expect(test_subject.uses_attribute_errors?).to eq true }
  description { "use attribute errors" }
  failure_message { "expected #{test_subject.name} to use attribute errors" }

  def test_subject
    subject.is_a?(Module) ? subject : subject.class
  end
end
