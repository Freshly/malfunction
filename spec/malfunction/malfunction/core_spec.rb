# frozen_string_literal: true

RSpec.describe Malfunction::Malfunction::Core, type: :concern do
  include_context "with an example malfunction"

  it { is_expected.to delegate_method(:problem).to(:class) }

  describe ".problem" do
    subject { example_malfunction_class.problem }

    it { is_expected.to eq example_prototype_name.underscore.to_sym }
  end

  describe "#initialize" do
    let(:context) { double }
    let(:details) { nil }

    context "without context" do
      let(:context) { nil }

      context "when not contextualized" do
        context "without details" do
          subject { example_malfunction_class.new }

          it { is_expected.to have_attributes(context: nil, details: {}) }
        end

        context "with details" do
          subject { example_malfunction_class.new(details: details) }

          let(:details) { Hash[*Faker::Lorem.words(2 * rand(1..2))] }

          it { is_expected.to have_attributes(context: nil, details: details) }
        end
      end

      context "when contextualized" do
        let(:contextualized_as) { Faker::Internet.domain_word.to_sym }

        before { example_malfunction_class.__send__(:contextualize, contextualized_as, allow_nil: allow_nil?) }

        context "when allow_nil?" do
          let(:allow_nil?) { true }

          context "without details" do
            subject { example_malfunction_class.new }

            it { is_expected.to have_attributes(context: nil, details: {}) }
          end

          context "with details" do
            subject { example_malfunction_class.new(details: details) }

            let(:details) { Hash[*Faker::Lorem.words(2 * rand(1..2))] }

            it { is_expected.to have_attributes(context: nil, details: details) }
          end
        end

        context "when not allow_nil?" do
          let(:allow_nil?) { false }

          it "raises" do
            expect { example_malfunction }.to raise_error ArgumentError, "#{example_malfunction_name} requires context"
          end
        end
      end
    end

    context "with context" do
      context "when not contextualized" do
        it "raises" do
          expect { example_malfunction }.
            to raise_error ArgumentError, "#{example_malfunction_name} is not contextualized"
        end
      end

      context "when contextualized" do
        let(:contextualized_as) { Faker::Internet.domain_word.to_sym }

        before { example_malfunction_class.__send__(:contextualize, contextualized_as) }

        context "without details" do
          subject { example_malfunction_class.new(context) }

          it { is_expected.to have_attributes(context: context, details: {}, contextualized_as => context) }
        end

        context "with nil details" do
          let(:details) { nil }

          it { is_expected.to have_attributes(context: context, details: {}) }
        end

        context "with details" do
          let(:details) { Hash[*Faker::Lorem.words(2 * rand(1..2))] }

          it { is_expected.to have_attributes(context: context, details: details) }
        end

        context "with non-standard details" do
          let(:details) { [] }

          it "raises" do
            expect { example_malfunction }.to raise_error ArgumentError, "details is invalid"
          end
        end
      end
    end
  end
end
