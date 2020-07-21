# frozen_string_literal: true

require './services/teams_service'
require './services/average_calculation_service'
require './services/display_service'
# require 'byebug'

class BattingAveragesApp
  def initialize(params)
    @file = params[0]
    @filter = params[1]
  end

  def run
    load_teams_file
    calculate_averages
    display_results
    @averages # returning this just for testing to confirm results are generated, not needed otherwise
  rescue StandardError => e
    puts "Something went wrong: #{e.inspect}"
  end

  private

  def load_teams_file
    @teams = TeamsService.new.call
  end

  def calculate_averages
    @averages = AverageCalculationService.new(@file, @filter, @teams).call
  end

  def display_results
    DisplayService.new(@averages, @filter).call
  end
end

BattingAveragesApp.new(ARGV).run
