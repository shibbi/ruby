require 'rspec'
require 'card'

RSpec.describe Card do
  describe "#initialize" do
    let(:card) { Card.new(:hearts, 3) }
    it "initializes a card properly given the suit and value" do
      expect(card.suit).to eq(:hearts)
      expect(card.value).to eq(3)
    end
  end
end
