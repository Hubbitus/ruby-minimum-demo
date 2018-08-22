require_relative 'card_comparable'

# Main class for demos
class Card < CardComparable
  def to_s
    self.inspect
  end
end
