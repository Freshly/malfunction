# frozen_string_literal: true

RSpec.describe ChumbleMalfunction, type: :malfunction do
  it { is_expected.to inherit_from GrumboMalfunction }

  it { is_expected.to define_problem :fumble_wumble }
  it { is_expected.not_to use_attribute_errors }
end
