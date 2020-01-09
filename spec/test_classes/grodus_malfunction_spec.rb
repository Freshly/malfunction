# frozen_string_literal: true

RSpec.describe GrodusMalfunction, type: :malfunction do
  subject { described_class }

  it { is_expected.to inherit_from PlumbusMalfunction }

  it { is_expected.to have_default_problem }
  it { is_expected.to use_attribute_errors }

  it { is_expected.not_to be_contextualized }
end
