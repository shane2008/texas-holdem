#!/usr/bin/env ruby
require './services/input_reader'
require './services/processor'
require './services/output_printer'

class TexasHoldemRunner
  def self.run
    input_lines = InputReader.read
    ranked_players = Processor.new(input_lines).parse_n_identify_n_rank
    OutputPrinter.new(ranked_players).print unless ranked_players.empty?
  end
end

if ARGV[0] == 'help'
  puts "Enter first line FIVE community cards and players with their two cards after first line. e.g."
  puts "KS AD 3H 7C TD"
  puts "John 9H 7S"
  puts "Sam AC KH"
  puts "Becky JD QC"
else
  TexasHoldemRunner.run
end