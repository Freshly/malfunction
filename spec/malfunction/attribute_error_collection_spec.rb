# frozen_string_literal: true

RSpec.describe Malfunction::AttributeErrorCollection, type: :collection do
  subject(:collection) { described_class }

  it { is_expected.to inherit_from Collectible::CollectionBase }

  describe "#item_enforcement" do
    subject { described_class.__send__(:item_enforcement) }

    it { is_expected.to eq Malfunction::AttributeError }
  end
end
