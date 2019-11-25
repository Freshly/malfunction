# frozen_string_literal: true

RSpec.describe FloobMalfunction, type: :malfunction do
  subject { described_class }

  it { is_expected.to inherit_from GrodusMalfunction }

  it { is_expected.to have_default_problem }
  it { is_expected.to use_attribute_errors }

  it { is_expected.to be_contextualized }
  it { is_expected.not_to be_allow_nil_context }
  it { is_expected.to contextualize_as :source_fleeb }
end
