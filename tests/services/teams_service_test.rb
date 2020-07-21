# frozen_string_literal: true

require 'minitest/autorun'
require './services/teams_service'

class TeamsServiceTest < Minitest::Test
  def test_will_load_uniq_values_from_teams_file_in_a_hash
    service = TeamsService.new.call

    assert_instance_of(Hash, service)
    assert_equal(service.size, 149)
  end

  def test_will_load_correct_values_from_teams_file
    service = TeamsService.new.call

    team_records = {}

    CSV.foreach('./task/Teams.csv', headers: true) do |row|
      team_records[row['teamID']] = row['name']
    end

    assert_equal(service.keys.first, team_records.keys.first)
    assert_equal(service.values.first, team_records.values.first.downcase)
    assert_equal(service.keys.last, team_records.keys.last)
    assert_equal(service.values.last, team_records.values.last.downcase)
  end
end
