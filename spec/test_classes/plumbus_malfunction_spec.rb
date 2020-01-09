# frozen_string_literal: true

RSpec.describe PlumbusMalfunction, type: :malfunction do
  subject { described_class }

  it { is_expected.to inherit_from Malfunction::MalfunctionBase }

  it { is_expected.to have_default_problem }
  it { is_expected.not_to use_attribute_errors }
  it { is_expected.not_to be_contextualized }
end
