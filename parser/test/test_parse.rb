###
#  to run use
#     ruby test/test_parse.rb


require_relative 'helper'


class TestParseGoals < Minitest::Test

  def test_parse_goals
      read_n_assert_tests( "./test/parse_goals.txt" )
  end

  def test_parse_score_full
      read_n_assert_tests( "./test/parse_score_full.txt" )
  end

  def test_parse_score_fuller
      read_n_assert_tests( "./test/parse_score_fuller.txt" )
      read_n_assert_tests( "./test/parse_score_fuller-agg.txt" )
      read_n_assert_tests( "./test/parse_score_fuller-min.txt" )
  end
 
end # class TestParseGoals

