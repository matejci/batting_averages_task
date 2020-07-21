# frozen_string_literal: true

require 'csv'

class TeamsService
  def initialize; end

  def call
    load_teams_file
  rescue StandardError => e
    puts "Error: #{e.message}"
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
