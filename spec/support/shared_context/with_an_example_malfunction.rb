# frozen_string_literal: true

RSpec.shared_context "with an example malfunction" do
  subject(:example_malfunction) { example_malfunction_class.new }

  let(:example_malfunction_class) { Class.new(Malfunction::MalfunctionBase) }

  let(:example_malfunction_name) do
    Array.new(2) { Faker::Internet.domain_word.capitalize }.join("")
  end

  before { stub_const(example_malfunction_name, example_malfunction_class) }
end
