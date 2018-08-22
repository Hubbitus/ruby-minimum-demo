# https://en.wikibooks.org/wiki/Ruby_Programming/Unit_testing
require 'test/unit'

require_relative 'card_base'
require_relative 'card_comparable'

class TestCardCompare < Test::Unit::TestCase

  def test_to_string
    assert_equal('Card(suit:1, value:1)', CardBase.new(1, 1).inspect)
  end

  def test_simple_array_size
    cards = []
    cards << CardBase.new(1, 1)
    cards << CardBase.new(1, 2)
    cards << CardBase.new(1, 3)
    cards << CardBase.new(1, 1)

    assert_equal(4, cards.size)
    assert_equal(4, cards.uniq.size)
  end

  def test_comparable_array_size
    cards = []
    cards << CardComparable.new(1, 1)
    cards << CardComparable.new(1, 2)
    cards << CardComparable.new(1, 3)
    cards << CardComparable.new(1, 1)

    assert_equal(4, cards.size)
    assert_equal(3, cards.uniq.size)
  end

  def test1
    card = CardComparable.new(1, 1)
    assert_equal(1, card.suit)
  end

  def test2
    cards = []
    cards << CardComparable.new(1, 1)

    assert_equal(1, cards.first.suit)
  end

  def setup
    @cards = []
    @cards << CardComparable.new(1, 1)
    @cards << CardComparable.new(1, 2)
    @cards << CardComparable.new(1, 3)
    @cards << CardComparable.new(1, 1)
  end

  def test_each
    assert_equal(4, @cards.size)

    @cards.each do |c|
      p c
    end
  end
end