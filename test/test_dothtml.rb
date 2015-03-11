require 'minitest_helper'

class TestDothtml < Minitest::Test
  def test_that_it_has_a_version_number
    refute_nil ::Dothtml::VERSION
  end
end
