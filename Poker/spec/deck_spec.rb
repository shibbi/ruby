require 'rspec'
require 'deck'

RSpec.describe Deck do
  let(:deck) { Deck.new }

  describe "#initialize" do
    it "initializes a new deck with 52 cards by default" do
      expect(deck.cards.length).to eq(52)
    end
  end

  describe "#deal" do
    it "deals the number of cards specified" do
      expect(deck.deal(4).length).to eq(4)
    end

    it "removes cards from the deck" do
      cards = deck.deal(4)
      expect(deck.cards.length).to eq(48)
    end

    it "deals valid cards" do
      card = deck.deal(1).first
      expect(card.class).to eq(Card)
    end
  end
end
