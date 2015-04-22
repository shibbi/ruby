require 'byebug'
require_relative 'deck'

class Hand

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
    if value == other_value
      tie_breaking(other_hand)
    else
      value <=> other_value
    end
  end

  def value_counts
    value_hash = Hash.new(0)

    cards.each do |card|
      value_hash[card.value] += 1
    end

    value_hash
  end

  def sort
    cards.sort_by(&:value)
  end

  private

  def tie_breaking(other_h)
    card, other_card = nil, nil
    case value
    when 8, 5, 4
      card, other_card = sort.last, other_h.sort.last
    when 7, 3
      card = (cards - cards.uniq).first
      other_card = (other_h.cards - other_h.cards.uniq).first
    when 6
      card = (value_counts.find { |key, val| val == 3 }).first
      other_card = (other_h.value_counts.find { |key, val| val == 3 }).first
    when 2
      pairs = (value_counts.select { |key, val| val == 2 }).keys
      pairs2 = (other_h.value_counts.select { |key, val| val == 2 }).keys
      values = pairs.sort.reverse
      values2 = pairs2.sort.reverse
      if values.first != values2.first
        card, other_card = values.first, values2.first
      elsif values.last != values2.last
        card, other_card = values.last, values2.last
      else
        card = value_counts.find { |key, val| val == 1 }
        other_card = other_h.value_counts.find { |key, val| val == 1 }
      end
    when 1
      pair = (value_counts.find { |key, val| val == 2 }).first
      pair2 = (other_h.value_counts.find { |key, val| val == 2 }).first
      if pair != pair2
        card, other_card = pair, pair2
      else
        singles = (value_counts.select { |key, val| val == 1 }).keys
        singles2 = (other_h.value_counts.select { |key, val| val == 1 }).keys
        values = singles.sort.reverse
        values2 = singles2.sort.reverse
        if values.first != values2.first
          card, other_card = values.first, values2.first
        elsif values[1] != values2[1]
          card, other_card = values[1], values2[1]
        else
          card, other_card = values.last, values2.last
        end
      end
    else
      singles = cards.sort.reverse
      singles2 = other_h.sort.reverse
      (0...singles.length).each do |index|
        single, other_single = singles[index], singles2[index]
        debugger
        if single != other_single
          card, other_card = single, other_single
          break
        end
      end
      return 0
    end

    card <=> other_card
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
