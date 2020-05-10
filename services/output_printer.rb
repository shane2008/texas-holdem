require_relative '../models/constants'

class OutputPrinter

  include Constants

  def initialize(ranked_players)
    @ranked_players = ranked_players
  end

  def print
    last_comparison_string = ''
    @ranked_players.each_with_index do |player, index|
      kicker = kicker(player, @ranked_players[index+1])
      rank = player.comparison_string == last_comparison_string ? index : index + 1
      last_comparison_string = player.comparison_string
      puts "#{rank} #{player.name} #{player.hand_name} #{player.extra_info} #{kicker}"
    end
  end

  private

  def kicker(player, next_player)
    if player &&
        next_player &&
        player.hand_name == next_player.hand_name

      index = index_of_first_difference(player.hand, next_player.hand)

      if index && index >= HANDS_KICKER_START_INDEX[HANDS.index(player.hand_name)]
        return "Kicker #{FACE_NAMES[player.hand[index]]}"
      end
      ''
    end

  end

  def index_of_first_difference(array1, array2)
    (0..4).each do |index|
      return index if array1[index] != array2[index]
    end
    nil
  end

end