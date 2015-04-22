require 'rspec'
require 'hand'
require 'spec_helper'

RSpec.describe Hand do
  let(:deck) { Deck.new }
  let(:hand) { Hand.new }

  describe '#initialize' do
    it 'initializes a new hand without cards by default' do
      expect(hand.cards.length).to eq(0)
    end
  end

  describe '#draw' do
    it 'draws the correct number of cards from the deck' do
      hand.draw(deck, 4)
      expect(hand.cards.length).to eq(4)
    end
  end

  describe '#discard' do
    let(:bad_hand) { Hand.new([Card.new(:diamonds, 4)]) }

    it 'discards cards form the hand' do
      bad_card = bad_hand.cards.first
      bad_hand.discard(bad_card)
      expect(bad_hand.cards.index(bad_card)).to eq(nil)
    end

    it 'does not allow discarding a card not in hand' do
      card = Card.new(:spades, 7)
      expect do
        bad_hand.discard(card)
      end.to raise_error(RuntimeError, 'card not found')
    end

    it 'cannot discard from an empty hand' do
      expect do
        hand.discard(:card)
      end.to raise_error(RuntimeError, 'empty hand')
    end
  end

  describe '#compare' do
    let (:pair_kings_one) do
      Hand.new([Card.new(:clubs, 13),
                Card.new(:spades, 13),
                Card.new(:hearts, 9),
                Card.new(:clubs, 8),
                Card.new(:hearts, 11)])
    end

    context 'when hands have different highest rankings' do
      let (:straight_flush) do
        Hand.new([Card.new(:clubs, 11),
                  Card.new(:clubs, 10),
                  Card.new(:clubs, 9),
                  Card.new(:clubs, 8),
                  Card.new(:clubs, 7)])
      end
      let (:full_house) do
        Hand.new([Card.new(:hearts, 5),
                  Card.new(:spades, 5),
                  Card.new(:diamonds, 5),
                  Card.new(:spades, 8),
                  Card.new(:hearts, 8)])
      end
      let (:two_pairs) do
        Hand.new([Card.new(:clubs, 13),
                  Card.new(:spades, 13),
                  Card.new(:hearts, 9),
                  Card.new(:clubs, 9),
                  Card.new(:hearts, 11)])
      end
      it 'allows a straight flush to win against a full house' do
        expect(straight_flush.compare(full_house)).to eq(1)
      end

      it 'allows a two pairs to win against a one pair' do
        expect(two_pairs.compare(pair_kings_one)).to eq(1)
      end
    end

    context 'when hands have same highest rankings' do
      let (:pair_deuces) do
        Hand.new([Card.new(:diamonds, 7),
                  Card.new(:hearts, 2),
                  Card.new(:hearts, 12),
                  Card.new(:hearts, 7),
                  Card.new(:clubs, 6)])
      end
      let (:pair_kings_two) do
        Hand.new([Card.new(:hearts, 13),
                  Card.new(:diamonds, 13),
                  Card.new(:hearts, 6),
                  Card.new(:clubs, 9),
                  Card.new(:hearts, 8)])
      end
      let (:singles_one) do
        Hand.new([Card.new(:hearts, 13),
                  Card.new(:hearts, 12),
                  Card.new(:hearts, 11),
                  Card.new(:hearts, 10),
                  Card.new(:diamonds, 13)])
      end
      let (:singles_two) do
        Hand.new([Card.new(:spades, 13),
                  Card.new(:spades, 12),
                  Card.new(:spades, 11),
                  Card.new(:spades, 10),
                  Card.new(:diamonds, 8)])
      end

      it 'compares card values' do
        expect(pair_kings_one.compare(pair_deuces)).to eq(1)
      end

      it 'compares singles when the tie is one pair with same value' do
        expect(pair_kings_one.compare(pair_kings_two)).to eq(1)
      end

      it 'compares singles correctly' do
        expect(singles_one.compare(singles_two)).to eq(1)
      end
    end

    context 'when tied' do
      it 'calls a tie when two hands have same rankings and values' do
        expect(pair_kings_one.compare(pair_kings_one)).to eq(0)
      end
    end
  end

end
