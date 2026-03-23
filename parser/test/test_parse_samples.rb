###
#  to run use
#     ruby test/test_parse_samples.rb


require_relative 'helper'


class TestParseSamples < Minitest::Test

  def test_parse_main    
      read_n_assert_tests( "./fbtxt-samples/main.txt" )
  end
 
end # class TestParseSamples

