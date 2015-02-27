require_relative 'deck'

class Hand
  HAND_VALUES = {
    straight_flush:  7,
    four_of_a_kind:  6,
    full_house:      5,
    flush:           4,
    straight:        3,
    three_of_a_kind: 2,
    one_pair:        1,
    high_card:       0
  }

  def initialize(cards = [])
    @cards = cards
  end

  def get_hand(deck)
    @cards += deck.deal(5)
  end
end
