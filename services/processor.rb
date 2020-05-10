require 'set'
require_relative '../models/player'
require_relative '../models/constants'

class Processor

  include Constants

  def initialize(input_lines)

    @input_lines = input_lines
    @all_cards = Set.new
  end

  def parse_n_identify_n_rank
    begin
      raise 'Community cards and at one player is required' if (@input_lines.size < 2)
      community_cards = parse_community_cards(@input_lines.shift)
      players = []

      @input_lines.each_with_index do |line, index|
        players << parse_and_build_player(community_cards, line, index + 2)
      end
    rescue => e
      puts e.message
      return []
    end

    Processor.rank_players_by_hands(players)
  end

  def self.rank_players_by_hands(players)
    players.sort_by{ |player| player.comparison_string }.reverse
  end

  private

  def parse_community_cards(input_string)
    cards = input_string.split(' ')
    raise 'Invalid input for community cards - line 1' unless cards.size == 5
    cards.each do |card|
      raise "Invalid card #{card} - line 1" unless valid_card?(card, 1)
    end
  end

  def parse_and_build_player(community_cards, player_string, line_number)
    tokens = player_string.split(' ')
    raise "Invalid input for player - line #{line_number}" unless tokens.size == 3
    player_name, card1, card2 = tokens
    raise "Invalid card #{card1} - line #{line_number}" unless valid_card?(card1, line_number)
    raise "Invalid card #{card2} - line #{line_number}" unless valid_card?(card2, line_number)
    player = Player.new(player_name, community_cards, [card1, card2])
    player.identify_hand
    player
  end

  def valid_card?(card, line_number)
    card.upcase!
    valid = card.length == 2 && FACES.include?(card[0]) && SUITS.include?(card[1])
    raise "Duplicate card #{card} - line #{line_number}" if (valid && @all_cards.include?(card))
    @all_cards.add(card)
    valid
  end

end