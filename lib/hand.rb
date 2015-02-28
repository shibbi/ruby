require 'byebug'
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

  attr_reader :cards

  def initialize(cards = [])
    @cards = cards
  end

  def draw(deck, n)
    @cards += deck.deal(n)
  end

  def discard(card)
    raise 'empty hand' if cards.empty?
    raise 'card not found' unless cards.include?(card)
    @cards.delete(card)
  end

  def value
    if straight_flush?
      8
    elsif four_of_a_kind?
      7
    elsif full_house?
      6
    elsif flush?
      5
    elsif straight?
      4
    elsif three_of_a_kind?
      3
    elsif two_pair?
      2
    elsif one_pair?
      1
    else
      0
    end
  end

  def compare(other_hand)
    other_value = other_hand.value
    value == other_value ? tie_breaking(other_hand) : value <=> other_value
  end

  def value_counts
    value_hash = Hash.new(0)

    cards.each do |card|
      value_hash[card.value] += 1
    end

    value_hash
  end

  def sort
    cards.sort_by { |card| card.value }
  end

  private

  def tie_breaking(other_h)
    case value
    when 8
      sort.last <=> other_h.sort.last
    when 7
      key = (cards - cards.uniq).first
      other_key = (other_h.cards - other_h.cards.uniq).first
      key <=> other_key
    when 6
      key = (value_counts.find { |key, val| val == 3 }).first
      other_key = (other_h.value_counts.find { |key, val| val == 3 }).first
      key <=> other_key
    when 5
      sort.last <=> other_h.sort.last
    when 4
      sort.last <=> other_h.sort.last
    when 3
      key = (cards - cards.uniq).first
      other_key = (other_h.cards - other_h.cards.uniq).first
      key <=> other_key
    when 2
      pairs = (value_counts.select { |key, val| val == 2 }).keys
      pairs2 = (other_h.value_counts.select { |key, val| val == 2 }).keys
      values = pairs.sort.reverse
      values2 = pairs2.sort.reverse

      if values.first != values2.first
        values.first <=> values2.first
      elsif values.last != values2.last
        values.last <=> values2.last
      else
        single = value_counts.find { |key, val| val == 1 }
        other_single = other_h.value_counts.find { |key, val| val == 1 }
        single.first <=> other_single.first
      end
    when 1
      pair = (value_counts.find { |key, val| val == 2 }).first
      pair2 = (other_h.value_counts.find { |key, val| val == 2 }).first
      if pair != pair2
        pair <=> pair2
      else
        singles = (value_counts.select { |key, val| val == 1 }).keys
        singles2 = (other_h.value_counts.select { |key, val| val == 1 }).keys
        values = singles.sort.reverse
        values2 = singles2.sort.reverse
        if values.first != values2.first
          values.first <=> values2.first
        elsif values[1] != values2[1]
          values[1] <=> values2[1]
        else
          values.last <=> values2.last
        end
      end
    else

    end
  end

  def straight_flush?
    flush? && straight?
  end

  def four_of_a_kind?
    value_counts.has_value?(4)
  end

  def full_house?
    counts = value_counts
    counts.has_value?(3) && counts.has_value?(2)
  end

  def flush?
    cards.all? {|card| card.suit == cards[0].suit }
  end

  def straight?
    sorted = sort
    (0...sorted.length - 1).each do |index|
      return false if sorted[index].value != sorted[index + 1].value - 1
    end

    true
  end

  def three_of_a_kind?
    counts = value_counts
    counts.has_value?(3) && !counts.has_value?(2)
  end

  def two_pair?
    counts = value_counts
    counts.count { |key, value| value == 2 } == 2
  end

  def one_pair?
    counts = value_counts
    counts.count { |key, value| value == 2 } == 1
  end
end
