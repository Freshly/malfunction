# frozen_string_literal: true

# RSpec matcher that tests usage of the default `MalfunctionBase.problem`
#
#     class FooBarMalfunction < Malfunction::Base
#     end
#
#     RSpec.describe FooBarMalfunction, type: :malfunction do
#       it { is_expected.to have_default_problem }
#     end

RSpec::Matchers.define :have_default_problem do
  match { expect(test_subject.problem).to eq test_subject.prototype_name.underscore.to_sym }
  description { "have default problem" }
  failure_message { "expected #{test_subject.name} to have default problem" }

  def test_subject
    subject.is_a?(Module) ? subject : subject.class
  end
end
