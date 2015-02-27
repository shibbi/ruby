require 'rspec'
require 'hand'

RSpec.describe Hand do
  let(:deck) { Deck.new }
  let(:hand) { Hand.new }

  describe "#initialize" do
    it "initializes a new hand without cards by default" do
      expect(hand.cards.length).to eq(0)
    end
  end

  describe "#draw" do
    it "draws the correct number of cards from the deck" do
      hand.draw(deck, 4)
      expect(hand.cards.length).to eq(4)
    end
  end

  describe "#compare" do
    let(:straight_flush) { [Card.new(:clubs, 11),
                            Card.new(:clubs, 10),
                            Card.new(:clubs, 9),
                            Card.new(:clubs, 8),
                            Card.new(:clubs, 7)] }
    let(:full_house)    { [Card.new(:hearts, 5),
                           Card.new(:spades, 5)
                           Card.new(:diamonds, 5),
                           Card.new(:spades, 8),
                           Card.new(:hearts, 8)] }
    let(:flush_hand)    { Hand.new(straight_flush) }
    let(:full_hand)     { Hand.new(full_house) }
    let(:pair_kings)    { Hand.new([Card.new(:clubs, 13),
                                    Card.new(:spades, 13),
                                    Card.new(:hearts, 9),
                                    Card.new(:clubs, 8),
                                    Card.new(:hearts, 11)] }
    let(:pair_deuces)   { Hand.new([Card.new(:diamonds, 2),
                                    Card.new(:hearts, 2),
                                    Card.new(:hearts, 12),
                                    Card.new(:hearts, 7),
                                    Card.new(:clubs, 6)]) }
    let(:pair_kings2)   { Hand.new([Card.new(:hearts, 13),
                                    Card.new(:diamonds, 13),
                                    Card.new(:hearts, 6),
                                    Card.new(:clubs, 7),
                                    Card.new(:hearts, 4)] }

    it "allows a straight flush to win against a full house" do
      expect(flush_hand.compare(full_hand)).to eq(1)
    end

    it "checks card values if ranking is a tie" do
      expect(pair_kings.compare(pair_deuces)).to eq(1)
    end

    it "checks other cards if highest ranking is a tie" do
      expect(pair_kings.compare(pair_kings2)).to eq(1)
    end

    it "calls a tie when two players have same hand rankings" do
      expect(flush_hand.compare(flush_hand)).to eq(0)
    end
  end

end
