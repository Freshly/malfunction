# frozen_string_literal: true

RSpec.describe Malfunction::MalfunctionBase, type: :malfunction do
  include_context "with an example malfunction"

  subject { example_malfunction_class }

  it { is_expected.to inherit_from Spicerack::RootObject }

  it { is_expected.to include_module Conjunction::Junction }
  it { is_expected.to have_conjunction_suffix "Malfunction" }

  it { is_expected.to include_module Malfunction::Malfunction::AttributeErrors }
  it { is_expected.to include_module Malfunction::Malfunction::Context }
  it { is_expected.to include_module Malfunction::Malfunction::Core }
  it { is_expected.to include_module Malfunction::Malfunction::Builder }

  describe ".prototype_name" do
    subject { example_malfunction_class.prototype_name }

    it { is_expected.to eq example_prototype_name }
  end
end
