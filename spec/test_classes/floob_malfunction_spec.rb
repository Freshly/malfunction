# frozen_string_literal: true

RSpec.describe FloobMalfunction, type: :malfunction do
  it { is_expected.to inherit_from GrodusMalfunction }

  it { is_expected.to have_default_problem }
  it { is_expected.to use_attribute_errors }
end
