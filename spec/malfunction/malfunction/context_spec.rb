# frozen_string_literal: true

RSpec.describe Malfunction::Malfunction::Context, type: :concern do
  include_context "with an example malfunction"

  it { is_expected.to delegate_method(:contextualized?).to(:class) }
  it { is_expected.to delegate_method(:allow_nil_context?).to(:class) }

  describe ".contextualized?" do
    subject { example_malfunction_class }

    context "with contextualize" do
      before { example_malfunction_class.__send__(:contextualize, :contextualized_as) }

      it { is_expected.to be_contextualized }
    end

    context "without contextualize" do
      it { is_expected.not_to be_contextualized }
    end
  end

  describe ".allow_nil_context?" do
    subject { example_malfunction_class }

    context "with allow_nil in contextualize" do
      before { example_malfunction_class.__send__(:contextualize, :contextualized_as, allow_nil: true) }

      it { is_expected.to be_allow_nil_context }
    end

    context "without allow_nil in contextualize" do
      it { is_expected.not_to be_allow_nil_context }
    end
  end

  describe ".contextualize" do
    subject(:contextualize) { example_malfunction_class.__send__(:contextualize, contextualized_as, allow_nil: true) }

    let(:contextualized_as) { Faker::Internet.domain_word.to_sym }

    it "contextualizes properly" do
      expect { contextualize }.
        to change { example_malfunction_class.contextualized_as }.to(contextualized_as).
        and change { example_malfunction_class.contextualized? }.to(true).
        and change { example_malfunction_class.allow_nil_context? }.to(true).
        and change { example_malfunction_class.method_defined?(contextualized_as) }.to(true)
    end

    it "is an alias to context" do
      contextualize
      expect(example_malfunction.public_send(contextualized_as)).to eq context
    end
  end

  describe ".inherited" do
    subject(:inherited_malfunction_class) { Class.new(child_malfunction_class) }

    let(:child_malfunction_class) { Class.new(example_malfunction_class) }
    let(:sibling_malfunction_class) { Class.new(example_malfunction_class) }
    let(:not_inherited_malfunction_class) { Class.new(example_malfunction_class) }
    let(:inherited_sibling_malfunction_class) { Class.new(sibling_malfunction_class) }

    let(:contextualized_as) { Faker::Internet.domain_word.to_sym }

    before do
      child_malfunction_class.__send__(:contextualize, contextualized_as, allow_nil: true)
      sibling_malfunction_class.__send__(:contextualize, contextualized_as, allow_nil: false)
    end

    it "inherits contextualization" do
      expect(example_malfunction_class).not_to be_contextualized
      expect(not_inherited_malfunction_class).not_to be_contextualized
      expect(child_malfunction_class).to be_contextualized
      expect(inherited_malfunction_class).to be_contextualized
      expect(sibling_malfunction_class).to be_contextualized
      expect(inherited_sibling_malfunction_class).to be_contextualized
    end

    it "inherits contextualized_as" do
      expect(child_malfunction_class.contextualized_as).to eq contextualized_as
      expect(inherited_malfunction_class.contextualized_as).to eq contextualized_as
      expect(sibling_malfunction_class.contextualized_as).to eq contextualized_as
      expect(inherited_sibling_malfunction_class.contextualized_as).to eq contextualized_as
    end

    it "inherits contextualization nil rules" do
      expect(example_malfunction_class).not_to be_allow_nil_context
      expect(not_inherited_malfunction_class).not_to be_allow_nil_context
      expect(child_malfunction_class).to be_allow_nil_context
      expect(inherited_malfunction_class).to be_allow_nil_context
      expect(sibling_malfunction_class).not_to be_allow_nil_context
      expect(inherited_sibling_malfunction_class).not_to be_allow_nil_context
    end
  end
end
