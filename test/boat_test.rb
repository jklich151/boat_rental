require 'minitest/autorun'
require 'minitest/pride'
require './lib/boat'
require './lib/renter'

class BoatTest < Minitest::Test
  def setup
    @kayak = Boat.new(:kayak, 20)
  end

  def test_boat_exists_with_starting_attributes
    assert_instance_of Boat, @kayak
    assert_equal :kayak, @kayak.type
    assert_equal 20, @kayak.price_per_hour
    assert_equal 0, @kayak.hours_rented
  end

  def test_boat_can_add_hours_rented
    3.times {@kayak.add_hour}
    assert_equal 3, @kayak.hours_rented
  end
end
