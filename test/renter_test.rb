require 'minitest/autorun'
require 'minitest/pride'
require './lib/boat'
require './lib/renter'

class RenterTest < Minitest::Test
  def setup
    @renter = Renter.new("Patrick Star", "4242424242424242")
  end

  def test_renter_exists_with_starting_attributes
    assert_instance_of Renter, @renter
    assert_equal "Patrick Star", @renter.name
    assert_equal "4242424242424242", @renter.credit_card_number
  end
end
