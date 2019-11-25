# frozen_string_literal: true

RSpec.describe Malfunction::Malfunction::Core, type: :concern do
  include_context "with an example malfunction"

  it { is_expected.to delegate_method(:problem).to(:class) }

  describe ".problem" do
    subject { example_malfunction_class.problem }

    it { is_expected.to eq example_prototype_name.underscore.to_sym }
  end

  describe "#initialize" do
    subject(:_initialize) { example_malfunction_class.new(details) }

    let(:details) { nil }

    context "without details" do
      subject { example_malfunction_class.new }

      it { is_expected.to have_attributes(details: {}) }
    end

    context "with nil details" do
      let(:details) { nil }

      it { is_expected.to have_attributes(details: {}) }
    end

    context "with details" do
      let(:details) { Hash[*Faker::Lorem.words(2 * rand(1..2))] }

      it { is_expected.to have_attributes(details: details) }
    end

    context "with options" do
      subject { example_malfunction_class.new(**options) }

      let(:options) { Hash[*Faker::Lorem.words(2 * rand(1..2))].symbolize_keys }

      it { is_expected.to have_attributes(details: options) }
    end

    context "with other types" do
      let(:details) { [] }

      it "raises" do
        expect { _initialize }.to raise_error ArgumentError, "details is invalid"
      end
    end
  end
end
