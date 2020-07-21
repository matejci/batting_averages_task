# frozen_string_literal: true

require 'minitest/autorun'
require './batting_averages_app'

class BattingAveragesAppTest < Minitest::Test
  #bad scenarios
  begin
    def test_app_will_print_error_msg_if_params_are_wrong
      ARGV.replace ['non existing file']
      app = BattingAveragesApp.new(ARGV)
      assert_output(/No such file or directory @ rb_sysopen - non existing file/) { app.run }
    end

    def test_app_will_print_error_msg_if_params_are_missing
      ARGV.replace []
      app = BattingAveragesApp.new(ARGV)
      assert_output(/Error: no implicit conversion of nil into String/) { app.run }
    end
  end

  # happy scenarios
  begin
    def test_app_will_generate_results_file
      ARGV.replace(['./task/Batting.csv', 'year:1871'])
      app = BattingAveragesApp.new(ARGV)
      assert_output(/Results generated/) { app.run }
    end

    def test_app_will_return_results
      ARGV.replace(['./task/Batting.csv', 'year:1871'])
      results = BattingAveragesApp.new(ARGV).run

      assert_instance_of(Array, results)
      assert_equal(results.size, 115)
    end
  end
end
