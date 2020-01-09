# frozen_string_literal: true

# RSpec matcher that tests usage of `MalfunctionBase.problem`
#
#     class FooBarMalfunction < Malfunction::Base
#     end
#
#     class BazMalfunction < Malfunction::Base
#     end
#
#     class CustomMalfunction < Malfunction::Base
#       def self.problem
#         :something_else
#       end
#     end
#
#     RSpec.describe FooBarMalfunction, type: :malfunction do
#       it { is_expected.to define_problem :foo_bar }
#     end
#
#     RSpec.describe BazMalfunction, type: :malfunction do
#       it { is_expected.to define_problem :baz }
#     end
#
#     RSpec.describe CustomMalfunction, type: :malfunction do
#       it { is_expected.to define_problem :something_else }
#     end

RSpec::Matchers.define :define_problem do |problem|
  match { expect(test_subject.problem).to eq problem }
  description { "defines problem #{problem}" }
  failure_message { "expected #{test_subject.name} to define problem #{problem}" }

  def test_subject
    subject.is_a?(Module) ? subject : subject.class
  end
end
