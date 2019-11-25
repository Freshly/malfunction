# frozen_string_literal: true

RSpec.describe ChumbleMalfunction, type: :malfunction do
  subject { described_class }

  it { is_expected.to inherit_from GrumboMalfunction }

  it { is_expected.to define_problem :fumble_wumble }
  it { is_expected.not_to use_attribute_errors }
  it { is_expected.to contextualize_as :frayed_chumble, allow_nil: true }
end
