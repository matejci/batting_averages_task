# frozen_string_literal: true

# require 'byebug'
require 'csv'

class TeamsService
  def initialize; end

  def call
    load_teams_file
  end

  private

  def load_teams_file
    team_records = {}

    CSV.foreach('./task/Teams.csv', headers: true) do |row|
      team_records[row['teamID']] = row['name'].downcase
    end

    team_records
  end
end
