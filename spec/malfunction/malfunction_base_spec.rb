# frozen_string_literal: true

RSpec.describe Malfunction::MalfunctionBase, type: :malfunction do
  include_context "with an example malfunction"

  it { is_expected.to inherit_from Spicerack::RootObject }

  it { is_expected.to include_module Malfunction::Malfunction::AttributeErrors }
end
