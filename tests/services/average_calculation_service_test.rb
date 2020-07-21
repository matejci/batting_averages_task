# frozen_string_literal: true

require 'minitest/autorun'
require './services/average_calculation_service'
require './services/teams_service'

class AverageCalculationServiceTest < Minitest::Test

  # bad scenarios
  begin
    def test_will_print_error_if_file_is_missing
      service = AverageCalculationService.new('', params[:year], params[:teams])
      assert_output(/Error: No such file or directory @ rb_sysopen/) { service.call }
    end

    def test_will_print_error_if_file_is_wrong_format
      service = AverageCalculationService.new(params[:wrong_file], params[:year], params[:teams])
      assert_output(/Illegal quoting/) { service.call }
    end
  end

  # happy scenarios
  begin
    def test_will_return_array
      service = AverageCalculationService.new(params[:file], nil, params[:teams]).call

      assert_instance_of(Array, service)
      assert_equal(service.size, 99402)
    end

    def test_will_return_results_sorted_by_batting_average_desc
      service = AverageCalculationService.new(params[:file], nil, params[:teams]).call

      assert(service.first.batting_average > service.last.batting_average)
      assert(service[1].batting_average > service[-2].batting_average)
      assert(service[2].batting_average > service[service.size/2].batting_average)
    end

    def test_will_return_only_results_that_match_given_year
      service = AverageCalculationService.new(params[:file], params[:year], params[:teams]).call
      years = service.map(&:year_id)

      assert_equal(years.size, service.size)
      assert_equal(years.uniq.size, 1)
      assert_equal(years.first, params[:year].split(':').last)
    end

    def test_will_return_only_results_that_match_given_team_name
      service = AverageCalculationService.new(params[:file], params[:team_name], params[:teams]).call
      teams = service.map(&:team_names).flatten

      assert_equal(teams.uniq.size, 1)
      assert_equal(teams.first, params[:team_name].split(':').last.downcase)
    end

    def test_will_return_only_results_that_match_given_team_name_and_year
      service = AverageCalculationService.new(params[:file], params[:year_and_team_name], params[:teams]).call

      teams = service.map(&:team_names).flatten
      years = service.map(&:year_id)

      parsed_params = params[:year_and_team_name].split(':').last
      params_year, params_team_name = parsed_params.split(',')
      params_year.strip!
      params_team_name.strip!

      assert_equal(teams.uniq.size, 1)
      assert_equal(teams.first, params_team_name.downcase)
      assert_equal(years.uniq.size, 1)
      assert_equal(years.first, params_year)
    end
  end

  private

  def params
    @params ||= { teams: TeamsService.new.call,
                  year: 'year:1981',
                  team_name: 'team_name:Boston Red Stockings',
                  year_and_team_name: 'year_and_team_name: 1871, Boston Red Stockings',
                  wrong_file: 'task/README.backend.md',
                  file: 'task/Batting.csv' }
  end
end
