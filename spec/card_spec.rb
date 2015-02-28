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

  describe "==" do
    let(:card1) { Card.new(:hearts, 3) }
    let(:card2) { Card.new(:hearts, 3) }

    it "overrides the == operator correctly" do
      expect(card1).to eq(card2)
    end
  end
end
