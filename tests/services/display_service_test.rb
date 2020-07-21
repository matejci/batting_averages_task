# frozen_string_literal: true

require 'minitest/autorun'
require './services/display_service'
require 'securerandom'

class DisplayServiceTest < Minitest::Test
  RESULTS_FILENAME = 'results.html'
  Result = Struct.new(:player_id, :year_id, :team_names, :batting_average)

  # bad scenarios
  begin
    def test_will_print_error_if_data_param_does_not_respond_to_each
      service = DisplayService.new('', nil)
      assert_output(/Error: undefined method `each'/) { service.call }

      service = DisplayService.new(22, nil)
      assert_output(/Error: undefined method `each'/) { service.call }

      service = DisplayService.new('string', nil)
      assert_output(/Error: undefined method `each'/) { service.call }

      service = DisplayService.new(nil, nil)
      assert_output(/Error: undefined method `each'/) { service.call }
    end
  end

  # happy scenarios
  begin
    def test_will_generate_new_file_if_successful
      !assert(File.file?(RESULTS_FILENAME))
      DisplayService.new(params[:data], nil).call
      assert(File.file?(RESULTS_FILENAME))
    end

    def test_will_print_message_if_successful
      service = DisplayService.new(params[:data], nil)
      assert_output(/Results generated/) { service.call }
    end
  end

  private

  def params
    @params ||= { data: data }
  end

  def data
    @data = []

    15.times do |ind|
      result = Result.new(SecureRandom.hex(5), "200#{ind}", [], 0.0)
      result.team_names << SecureRandom.hex(3)
      result.batting_average = rand.round(3)
      @data << result
    end

    @data
  end
end
