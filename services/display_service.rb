# frozen_string_literal: true

# require 'byebug'
require 'erb'

class DisplayService
  def initialize(data, filter)
    @data = data
    @filter = filter
    file = './views/batting_average_results.html.erb'
    @template = File.read(file)
  end

  def call
    render_results
  end

  private

  def render_results
    results = ERB.new(@template).result(binding)
    full_path = ''

    File.open('results.html', 'w') do |f|
      f.write(results)
      full_path = "#{File.expand_path(File.dirname(f))}/#{f.path}"
    end

    puts "Results generated: #{full_path}"
    `xdg-open /home/matejci/Code/batting_averages_app/results.html` if RUBY_PLATFORM =~ /linux/
  end
end
