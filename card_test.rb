# https://en.wikibooks.org/wiki/Ruby_Programming/Unit_testing
require 'test/unit'

require_relative 'card_base'
require_relative 'card'

class TestCard < Test::Unit::TestCase

  def setup
    @cards = []
    @cards << Card.new(1, 1)
    @cards << Card.new(1, 2)
    @cards << Card.new(1, 3)
  end

  def test_inspect
    assert_equal('Card(suit:1, value:1)', CardBase.new(1, 1).inspect)
  end

  def test_to_string
    # By default object representation look like: #<CardBase:0x000055b2488349d8>
    assert_match(/#<CardBase:0x00005[\da-f]+>/, CardBase.new(1, 1).to_s)
    # But we may change it implementing `to_s` method:
    assert_equal('Card(suit:1, value:1)', Card.new(1, 1).to_s)

    # It for collection also works:
    assert_equal('[Card(suit:1, value:1), Card(suit:1, value:2), Card(suit:1, value:3)]', @cards.to_s)
  end

  def test_array_compare
    @a = [11, 4, 3, 11, 12].sort.reverse # [12, 11, 11, 4, 3]
    @b = [13, 4, 5, 11, 5].sort.reverse # [13, 11, 5, 5, 4]

    assert_equal([12, 11, 11, 4, 3], @a)
    assert_equal([13, 11, 5, 5, 4],  @b)

    # Где я косячу?
    # @a.zip(@b).map{ |x, y| x > y } #=> [false, false, true, false, false]

    assert_equal(@a.zip(@b).map{ |x, y| x > y }, [false, false, true, false, false])
  end
end