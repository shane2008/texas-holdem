require_relative './constants'

class Player

  include Constants

  attr_reader :name, :cards, :hand_name, :hand, :comparison_string, :extra_info

  def initialize(name, community_cards, two_cards)
    @name = name
    @cards = community_cards + two_cards
    @face_stats, @suit_stats = build_card_stats(@cards)
  end

  # going through each hand from high to low, return when found
  def identify_hand

    flush_cards, flush_suit = has_flush(@suit_stats)
    straight_faces = has_straight(@face_stats)

    # has both straight and flush
    if flush_cards && straight_faces
      straight_flush_hand = has_straight_flush(straight_faces, flush_suit)
      if straight_flush_hand
        record_hand(ROYAL_FLUSH, straight_flush_hand) and return if is_royal_flush(straight_flush_hand)
        record_hand(STRAIGHT_FLUSH, straight_flush_hand, FACE_NAMES[straight_flush_hand.first]) and return
      end
    end

    four_oak_hand = is_four_oak(@face_stats)
    record_hand(FOUR_OAK, four_oak_hand, FACE_NAMES[four_oak_hand.first]) and return if four_oak_hand

    three_oaks, pairs = three_oaks_and_pairs(@face_stats)
    three_oak_hand = nil

    if three_oaks.any?
      full_house_hand = is_full_house(three_oaks, pairs)
      if full_house_hand
        extra_info = "#{FACE_NAMES[full_house_hand.first]} #{FACE_NAMES[full_house_hand[3]]}"
        record_hand(FULL_HOUSE, full_house_hand, extra_info) and return
      end
      #not to conclude three-of-a-kind until flush or straight is checked
      three_oak_hand = three_oak_hand(three_oaks, @face_stats)
    end

    if flush_cards
      flush_hand = flush_hand(flush_cards)
      record_hand(FLUSH, flush_hand, FACE_NAMES[flush_hand.first]) and return
    end

    if straight_faces
      straight_hand = straight_hand(straight_faces)
      record_hand(STRAIGHT, straight_hand, FACE_NAMES[straight_hand.first]) and return
    end

    record_hand(THREE_OAK, three_oak_hand, FACE_NAMES[three_oak_hand.first]) and return if three_oak_hand

    if pairs.any?
      two_pair_hand = is_two_pair(pairs, @face_stats)
      if two_pair_hand
        extra_info = "#{FACE_NAMES[two_pair_hand.first]} #{FACE_NAMES[two_pair_hand[2]]}"
        record_hand(TWO_PAIR, two_pair_hand, extra_info) and return
      end
      pair_hand = pair_hand(pairs, @face_stats)
      record_hand(PAIR, pair_hand, FACE_NAMES[pair_hand.first]) and return
    end

    high_card_hand = high_card_hand(@cards)
    record_hand(HIGH_CARD, high_card_hand, FACE_NAMES[high_card_hand.first])
  end

  private

  def record_hand(hand_name, hand, extra_info = '')
    @hand_name = hand_name
    @hand = hand
    @extra_info = extra_info
    @comparison_string = "#{HANDS.index(@hand_name)}-#{hand.map{|face| FACE_VALUES[face]}.join('-')}"
  end

  def build_card_stats(cards)
    face_stats = []
    suit_stats = []
    cards.each do |card|
      face, suit = card[0], card[1]
      face_index, suit_index = FACES.index(face), SUITS.index(suit)
      face_stats[face_index] = (face_stats[face_index] || 0) + 1
      suit_stats[suit_index] = (suit_stats[suit_index] || []) << card
    end
    [face_stats, suit_stats]
  end

  def has_flush(suit_stats)
    matched_faces_in_suit = suit_stats.find{|stat|stat && stat.size >= HAND_SIZE}
    flush_cards = matched_faces_in_suit ? matched_faces_in_suit : nil
    suit_code = matched_faces_in_suit ? flush_cards.first[1] : nil
    [flush_cards, suit_code]
  end

  def has_straight(face_stats)
    matched_stats = (2..HIGH_ACE_INDEX).select{|index|face_stats[index] && face_stats[index] >= 1}
    matched_stats.unshift(LOW_ACE_INDEX) if matched_stats.include?(HIGH_ACE_INDEX)
    consecutive_groups = matched_stats.slice_when { |prev, curr| curr != prev.next }
                            .to_a.select{|group| group.size >= HAND_SIZE}
    straight = consecutive_groups.any? ? consecutive_groups.flatten : nil
    straight
  end

  def has_straight_flush(faces, suit)
    faces.reverse.each_cons(HAND_SIZE).map{ |face| face }.each do |straight_hand|
      return straight_hand if (straight_hand.map{|face| FACES_WITH_ONE[face]+suit } - @cards).empty?
    end
    nil
  end

  def is_royal_flush(faces)
    faces[0] == HIGH_ACE_INDEX
  end

  def is_four_oak(face_stats)
    matched_four_oak_face = (2..HIGH_ACE_INDEX).find{|index|face_stats[index] && face_stats[index] == 4}
    if matched_four_oak_face
      next_highest_face = (2..HIGH_ACE_INDEX).to_a
                         .reverse.find{|index|face_stats[index] &&
                                              face_stats[index] != 4 &&
                                              face_stats[index] >= 1}
      return 4.times.map{|_| matched_four_oak_face } << next_highest_face
    end
    nil
  end

  def three_oaks_and_pairs(face_stats)
    [(2..HIGH_ACE_INDEX).select{|index|face_stats[index] && face_stats[index] == 3},
     (2..HIGH_ACE_INDEX).select{|index|face_stats[index] && face_stats[index] == 2}]
  end

  def is_full_house(three_oaks, pairs)
    if three_oaks.size == 2
      three_oak_face = three_oaks.max
      return 3.times.map{|_| three_oak_face } + 2.times.map{|_| (pairs << three_oaks.first).max }
    elsif three_oaks.size == 1 && pairs.size > 0
      three_oak_face = three_oaks.max
      return 3.times.map{|_| three_oak_face } + 2.times.map{|_| (pairs).max }
    end
    nil
  end

  def three_oak_hand(three_oaks, face_stats)
    three_oak_face = three_oaks.first
    faces_highest_first = reverse_index_list.select{|index| face_stats[index] &&
                                                      index != three_oak_face &&
                                                      face_stats[index] >= 1}
    3.times.map{|_| three_oak_face } + [faces_highest_first.first, faces_highest_first[1]]
  end

  def flush_hand(flush_cards)
    flush_cards.map{|card| FACES.index(card[0])}.sort.reverse[0,5]
  end

  def straight_hand(straight_faces)
    straight_faces.reverse[0,5]
  end

  def is_two_pair(pairs, face_stats)
    if pairs.size >= 2
      pairs.shift if pairs.size == 3
      highest_face = reverse_index_list.find{|index| face_stats[index] &&
                                                                   !pairs.include?(index) &&
                                                                   face_stats[index] >= 1}
      return [pairs.last, pairs.last, pairs.first, pairs.first, highest_face]
    end
    nil
  end

  def pair_hand(pairs, face_stats)
    pair_face = pairs.first
    faces_highest_first = reverse_index_list.select{|index| face_stats[index] &&
                                                      index != pair_face &&
                                                      face_stats[index] >= 1}
    return [pair_face, pair_face] + faces_highest_first[0,3]
  end

  def high_card_hand(cards)
    cards.map{|card| FACES.index(card[0])}.sort.reverse[0,5]
  end

  def reverse_index_list
    (2..HIGH_ACE_INDEX).to_a.reverse
  end

end