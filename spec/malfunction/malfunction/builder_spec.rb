# frozen_string_literal: true

RSpec.describe Malfunction::Malfunction::Builder, type: :concern do
  include_context "with an example malfunction"

  describe ".build" do
    it_behaves_like "a class pass method", :build do
      let(:test_class) { example_malfunction_class }
    end
  end

  describe "#build" do
    subject(:_build) { example_malfunction.build }

    it { is_expected.to eq example_malfunction }

    it_behaves_like "a handler for the callback" do
      subject(:run) { instance.build }

      let(:example_class) { example_malfunction_class }
      let(:callback) { :build }
      let(:method) { :on_build }
    end
  end
end
