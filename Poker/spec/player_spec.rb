require 'player'

RSpec.describe Player do
  subject(:player) { Player.new }

  describe "#initialize" do
    it "should create a new player with an empty hand and pot"
  end

  describe "#discard" do
    it "should remove correct card from player's hand"

    it "should not remove more than three cards"

    it "should not remove more cards than the player has"
  end

  describe "#action" do
    it "should not accept an invalid action"

    context "when folding" do
      it "should discard the player's cards"

      it "should remove the player from the game"
    end

    context "when seeing" do
      it "should display all options"
end
