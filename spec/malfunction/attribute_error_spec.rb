# frozen_string_literal: true

RSpec.describe Malfunction::AttributeError, type: :attribute_error do
  subject(:attribute_error) { described_class.new(attribute_name: attribute_name, error_code: error_code) }

  let(:attribute_name) { Faker::Internet.domain_word }
  let(:error_code) { Faker::Internet.domain_word }

  it { is_expected.to inherit_from Substance::InputObject }

  it { is_expected.to define_argument :attribute_name }
  it { is_expected.to define_argument :error_code }

  it { is_expected.to define_option :message }

  it { is_expected.to alias_method(:eql?, :==) }

  describe "#attribute_name" do
    subject { attribute_error.attribute_name }

    it { is_expected.to eq attribute_name }
  end

  describe "#error_code" do
    subject { attribute_error.error_code }

    it { is_expected.to eq error_code }
  end

  describe "#==" do
    context "when other is nil" do
      let(:other) { nil }

      it { is_expected.not_to eq other }
    end

    context "when other is nonsense" do
      let(:other) { SecureRandom.hex }

      it { is_expected.not_to eq other }
    end

    context "when blank other" do
      let(:other) { described_class.new(attribute_name: nil, error_code: nil) }

      it { is_expected.not_to eq other }
    end

    context "when other with different data" do
      let(:other) { described_class.new(attribute_name: error_code, error_code: attribute_name) }

      it { is_expected.not_to eq other }
    end

    context "when other with same data" do
      let(:other) { described_class.new(attribute_name: attribute_name, error_code: error_code) }

      it { is_expected.to eq other }
    end

    context "when other is exactly the same" do
      let(:other) { attribute_error }

      it { is_expected.to eq other }
    end
  end
end
