require_relative 'card_minimum'

class CardComparable < CardMinimum
  include Comparable

  def <=>(other)
    suit <=> other.suit && value <=> other.value
  end

  def eql?(other)
    self.class == other.class && self == other
  end

  def hash
    suit.hash + value.hash
  end
end
