class Card
  SUITS = [:hearts, :diamonds, :spades, :clubs]
  VALUES = (1..13).to_a

  attr_reader :suit, :value

  def initialize(suit, value)
    raise 'invalid card' unless SUITS.include?(suit) && VALUES.include?(value)
    @suit = suit
    @value = value
  end

  def ==(other_card)
    suit == other_card.suit && value == other_card.value
  end
end
