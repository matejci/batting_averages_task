# frozen_string_literal: true

require 'csv'

class AverageCalculationService
  Result = Struct.new(:player_id, :year_id, :team_names, :batting_average)

  def initialize(file, filter, teams)
    @file = file
    @filter = filter
    @teams = teams
    @averages = []
  end

  def call
    process_file
  rescue StandardError => e
    puts "Error: #{e.message}"
  end

  private

  def process_file
    results_hash = {}

    filter_type, filter_value = @filter&.split(':')
    filter_type&.strip!
    filter_value&.strip!

    CSV.foreach(@file, headers: true) do |row|
      case filter_type
      when 'year'
        next unless row['yearID'] == filter_value
      when 'team_name'
        team_id = @teams.key(filter_value.downcase)

        next unless row['teamID'] == team_id
      when 'year_and_team_name'
        year, team_name = filter_value.split(',')
        team_id = @teams.key(team_name&.strip&.downcase)

        next unless row['yearID'] == year&.strip && row['teamID'] == team_id
      end

      results_hash_id = "#{row['playerID']}-#{row['yearID']}"

      if results_hash.key?(results_hash_id)
        batting_average_current = results_hash[results_hash_id].batting_average
        batting_average_from_file = (row['H'].to_i / row['AB'].to_f).round(3)

        stint = row['stint'].to_i

        batting_average = batting_average_from_file.nan? ? (batting_average_current / stint).round(3) : ((batting_average_current + batting_average_from_file) / stint).round(3)

        results_hash[results_hash_id].batting_average = batting_average
        results_hash[results_hash_id].team_names << @teams[row['teamID']]
      else
        result = Result.new(row['playerID'], row['yearID'], [], 0.0)
        result.team_names << @teams[row['teamID']]

        batting_average = (row['H'].to_i / row['AB'].to_f).round(3)
        result.batting_average = batting_average.nan? ? 0.0 : batting_average

        results_hash["#{row['playerID']}-#{row['yearID']}"] = result
      end
    end

    results_hash.values.sort_by { |val| val.batting_average }.reverse!
  end
end
