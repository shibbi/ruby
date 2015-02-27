class Card
  SUITS = [:hearts, :diamonds, :spades, :clubs]
  VALUES = (1..13).to_a

  attr_reader :suit, :value

  def initialize(suit, value)
    raise 'invalid card' unless SUITS.include?(suit) && VALUES.include?(value)
    @suit = suit
    @value = value
  end
end
