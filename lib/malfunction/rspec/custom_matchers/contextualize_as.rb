# frozen_string_literal: true

# RSpec matcher that tests usage of the default `MalfunctionBase.contextualize`
#
#     class FooMalfunction < Malfunction::Base
#       contextualize :fringle
#     end
#
#     class BarMalfunction < Malfunction::Base
#       contextualize :bangle, allow_nil: true
#     end
#
#     RSpec.describe FooMalfunction, type: :malfunction do
#       it { is_expected.to contextualize_as :fringle }
#     end
#
#     RSpec.describe BarMalfunction, type: :malfunction do
#       it { is_expected.not_to contextualize_as :bangle, allow_nil: true }
#     end

RSpec::Matchers.define :contextualize_as do |contextualized_as, allow_nil: false|
  match do
    expect(test_subject.contextualized_as).to eq contextualized_as
    expect(test_subject.allow_nil_context?).to eq allow_nil
  end
  description { "use contextualize as #{contextualized_as} with allow_nil: #{allow_nil}" }
  failure_message do
    "expected #{test_subject.name} to contextualize as #{contextualized_as} with allow_nil: #{allow_nil}"
  end

  def test_subject
    subject.is_a?(Module) ? subject : subject.class
  end
end
