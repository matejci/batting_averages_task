# Batting Averages App

- Command line app which ingest a raw CSV file with player statistics and provide will player rankings based on their batting performance.
- Written by Matej Cica, on 2020-07-20, using ruby 2.7.1p83 (2020-03-31 revision a0c7c23c9c) [x86_64-linux]

How to run the app?
Cd to app's directory.
Install dependencies by running: `bundle install`
Few examples:
- ruby app.rb '/home/matejci/Batting.csv'
- ruby app.rb '/home/matejci/Batting.csv' 'year: 2000'
- ruby app.rb '/home/matejci/Batting.csv' 'team_name: Boston Red Stockings'
- ruby app.rb '/home/matejci/Batting.csv' 'year_and_team_name: 1871, Boston Red Stockings'

Note that first argument is the path to a file (make sure user has right permissions to access the file), second argument is a filter.
Filter is in format: `filter_name: filter_value` (don't forget quotes)

After script is finished, 'results.html' file will be generated in root of the app's directory (you should get the path printed in console).
For Linux based hosts, 'results.html' will be opened automatically by default browser and display the results.
For MacOS/Windows based hosts this is not supported, because I don't have Mac nor Windows OS so couldn't test it...

Text of the exercise and csv files used, can be found in 'task' directory.

# Tests

Run tests by executing: ruby -I . -e "Dir.glob('**/*_test.rb') { |f| require(f) }"
