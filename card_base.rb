# Minimum Card class to show differences with CardComparable which will extend it
# @see TestCard
class CardBase
  attr_accessor :suit
  attr_accessor :value

  def initialize (suit, value)
    self.suit = suit
    self.value = value
  end

  def inspect
    "Card(suit:#{suit}, value:#{value})"
  end
end
