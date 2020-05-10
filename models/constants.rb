module Constants

  FACE_VALUES = [nil, '01',
                 '02', '03', '04', '05',
                 '06', '07', '08', '09',
                 '10', '11', '12', '13', '14']

  FACES = [nil, nil,
           '2', '3', '4', '5',
           '6', '7', '8', '9',
           'T', 'J', 'Q', 'K', 'A']

  FACES_WITH_ONE = [nil, 'A',
           '2', '3', '4', '5',
           '6', '7', '8', '9',
           'T', 'J', 'Q', 'K', 'A']

  FACE_NAMES = [nil, nil,
                '2', '3', '4', '5',
                '6', '7', '8', '9',
                '10', 'Jack', 'Queen', 'King', 'Ace']

  HIGH_ACE_INDEX = 14
  LOW_ACE_INDEX = 1

  HAND_SIZE = 5

  SUITS = %w(H S D C)

  SUIT_NAMES = %w(Hearts Spades Diamonds Clubs)

  HIGH_CARD = 'High Card'
  PAIR = 'Pair'
  TWO_PAIR = 'Two Pair'
  THREE_OAK = 'Three of A Kind'
  STRAIGHT = 'Straight'
  FLUSH = 'Flush'
  FULL_HOUSE = 'Full House'
  FOUR_OAK = 'Four of A Kind'
  STRAIGHT_FLUSH = 'Straight Flush'
  ROYAL_FLUSH = 'Royal Flush'

  HANDS = [HIGH_CARD, PAIR, TWO_PAIR,
           THREE_OAK, STRAIGHT, FLUSH,
           FULL_HOUSE, FOUR_OAK,
           STRAIGHT_FLUSH, ROYAL_FLUSH]

  # starting position (0 to 4) of card in a hand for kickers
  HANDS_KICKER_START_INDEX = [1, 2, 4, 3, nil, 1, nil, 4, nil, nil]

end