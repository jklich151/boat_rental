require 'minitest/autorun'
require 'minitest/pride'
require './lib/boat'
require './lib/renter'
require './lib/dock'

class DockTest < Minitest::Test
  def setup
    @dock = Dock.new("The Rowing Dock", 3)
    @kayak_1 = Boat.new(:kayak, 20)
    @kayak_2 = Boat.new(:kayak, 20)
    @sup_1 = Boat.new(:standup_paddle_board, 15)
    @sup_2 = Boat.new(:standup_paddle_board, 15)
    @canoe = Boat.new(:canoe, 25)
    @patrick = Renter.new("Patrick Star", "4242424242424242")
    @eugene = Renter.new("Eugene Crabs", "1313131313131313")
  end

  def test_dock_exists_with_starting_attributes
    assert_instance_of Dock, @dock
    assert_equal "The Rowing Dock", @dock.name
    assert_equal 3, @dock.max_rental_time
    assert_equal 0, @dock.revenue
  end

  def test_boats_can_be_rented_by_renters
    @dock.rent(@kayak_1, @patrick)
    @dock.rent(@kayak_2, @patrick)
    @dock.rent(@sup_1, @eugene)

    expected = {@kayak_1 => @patrick,
                @kayak_2 => @patrick,
                @sup_1 => @eugene}

    assert_equal expected, @dock.rental_log
  end

  def test_dock_can_charge_for_rental
    @dock.rent(@kayak_1, @patrick)
    @dock.rent(@kayak_2, @patrick)
    @dock.rent(@sup_1, @eugene)
    2.times {@kayak_1.add_hour}

    expected = {:card_number => "4242424242424242",
                :amount => 40}

    assert_equal expected, @dock.charge(@kayak_1)
  end

  def test_additional_hours_past_max_arent_counted
    @dock.rent(@kayak_1, @patrick)
    @dock.rent(@kayak_2, @patrick)
    @dock.rent(@sup_1, @eugene)

    5.times {@sup_1.add_hour}

    expected =  {:card_number => "1313131313131313",
                :amount => 45}

    assert_equal expected, @dock.charge(@sup_1)
  end

  def test_log_hour_adds_hour_to_rented_boats
    @dock.rent(@kayak_1, @patrick)
    @dock.rent(@kayak_2, @patrick)

    @dock.log_hour

    assert_equal 1, @kayak_1.hours_rented

    @dock.rent(@canoe, @patrick)

    @dock.log_hour

    assert_equal 2, @kayak_1.hours_rented
    assert_equal 1, @canoe.hours_rented
  end

  def test_boats_can_be_returned_and_charged_for_rental
    @dock.rent(@kayak_1, @patrick)
    @dock.rent(@kayak_2, @patrick)
    @dock.log_hour
    @dock.rent(@canoe, @patrick)
    @dock.log_hour

    @dock.return(@kayak_1)
    @dock.return(@kayak_2)
    @dock.return(@canoe)

    assert_equal 105, @dock.revenue
  end

  def test_boats_arent_charged_over_max_in_revenue
    @dock.rent(@kayak_1, @patrick)
    @dock.rent(@kayak_2, @patrick)
    @dock.log_hour
    @dock.rent(@canoe, @patrick)
    @dock.log_hour
    @dock.return(@kayak_1)
    @dock.return(@kayak_2)
    @dock.return(@canoe)

    @dock.rent(@sup_1, @eugene)
    @dock.rent(@sup_2, @eugene)

    5.times {@dock.log_hour}

    @dock.return(@sup_1)
    @dock.return(@sup_2)

    assert_equal 195, @dock.revenue
  end
end
