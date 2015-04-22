require_relative 'card'

class Deck

  attr_reader :cards

  def initialize(cards = make_deck)
    @cards = cards
  end

  def deal(n)
    [].tap do |dealt_cards|
      n.times { dealt_cards << @cards.pop }
    end
  end

  private

  def make_deck
    cards = []
    Card::SUITS.each do |suit|
      Card::VALUES.each do |value|
        cards << Card.new(suit, value)
      end
    end

    cards.shuffle
  end
end
