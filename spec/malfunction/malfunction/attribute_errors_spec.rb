# frozen_string_literal: true

RSpec.describe Malfunction::Malfunction::AttributeErrors, type: :concern do
  include_context "with an example malfunction"

  it { is_expected.to delegate_method(:uses_attribute_errors?).to(:class) }

  describe ".uses_attribute_errors?" do
    subject { example_malfunction_class }

    context "when uses_attribute_errors" do
      before { example_malfunction_class.__send__(:uses_attribute_errors) }

      it { is_expected.to be_uses_attribute_errors }
    end

    context "when not uses_attribute_errors" do
      it { is_expected.not_to be_uses_attribute_errors }
    end
  end

  describe ".uses_attribute_errors" do
    subject(:uses_attribute_errors) { example_malfunction_class.__send__(:uses_attribute_errors) }

    it "changes uses_attribute_errors?" do
      expect { uses_attribute_errors }.to change { example_malfunction_class.uses_attribute_errors? }.to(true)
    end
  end

  describe ".inherited" do
    subject(:inherited_malfunction_class) { Class.new(child_malfunction_class) }

    let(:child_malfunction_class) { Class.new(example_malfunction_class) }
    let(:not_inherited_malfunction_class) { Class.new(example_malfunction_class) }

    before { child_malfunction_class.__send__(:uses_attribute_errors) }

    it "is inherited" do
      expect(example_malfunction_class).not_to be_uses_attribute_errors
      expect(not_inherited_malfunction_class).not_to be_uses_attribute_errors
      expect(child_malfunction_class).to be_uses_attribute_errors
      expect(inherited_malfunction_class).to be_uses_attribute_errors
    end
  end

  describe "#attribute_errors?" do
    subject { example_malfunction }

    context "when uses_attribute_errors" do
      before { example_malfunction_class.__send__(:uses_attribute_errors) }

      context "with attribute_errors" do
        before { example_malfunction.add_attribute_error(:attribute_name, :error_code) }

        it { is_expected.to be_attribute_errors }
      end

      context "without attribute_errors" do
        it { is_expected.not_to be_attribute_errors }
      end
    end

    context "when not uses_attribute_errors" do
      it { is_expected.not_to be_attribute_errors }
    end
  end

  describe "#add_attribute_error" do
    subject(:add_attribute_error) { example_malfunction.add_attribute_error(attribute_name, error_code, message) }

    let(:attribute_name) { Faker::Internet.domain_word }
    let(:error_code) { Faker::Internet.domain_word }
    let(:message) { Faker::Lorem.sentence }

    context "when uses_attribute_errors" do
      shared_examples_for "an error attribute is added" do
        let(:first_attribute_error) { example_malfunction.attribute_errors.first }

        it "is an Malfunction::AttributeError with expected values" do
          add_attribute_error
          expect(first_attribute_error).to be_an_instance_of Malfunction::AttributeError
          expect(first_attribute_error).
            to have_attributes(attribute_name: attribute_name, error_code: error_code, message: message)
        end
      end

      before { example_malfunction_class.__send__(:uses_attribute_errors) }

      context "with message" do
        it_behaves_like "an error attribute is added"
      end

      context "without message" do
        subject(:add_attribute_error) { example_malfunction.add_attribute_error(attribute_name, error_code) }

        let(:message) { nil }

        it_behaves_like "an error attribute is added"
      end
    end

    context "when not uses_attribute_errors" do
      it "raises" do
        expect { add_attribute_error }.
          to raise_error ArgumentError, "#{example_malfunction_name} does not use attribute errors"
      end
    end
  end

  describe "#attribute_errors" do
    subject(:attribute_errors) { example_malfunction.attribute_errors }

    context "when uses_attribute_errors" do
      before { example_malfunction_class.__send__(:uses_attribute_errors) }

      context "with attribute_errors" do
        before { example_malfunction.add_attribute_error(attribute_name, error_code, message) }

        let(:first_attribute_error) { attribute_errors.first }

        let(:attribute_name) { Faker::Internet.domain_word }
        let(:error_code) { Faker::Internet.domain_word }
        let(:message) { Faker::Lorem.sentence }

        it "is an Malfunction::AttributeError with expected values" do
          expect(first_attribute_error).to be_an_instance_of Malfunction::AttributeError
          expect(first_attribute_error).
          to have_attributes(attribute_name: attribute_name, error_code: error_code, message: message)
        end
      end

      context "without attribute_errors" do
        it { is_expected.to be_empty }
      end
    end

    context "when not uses_attribute_errors" do
      it { is_expected.to be_nil }
    end
  end
end
