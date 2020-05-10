require_relative '../../models/player'
require_relative '../../models/constants'

include Constants

describe Player do

  describe "#identify_hand" do

    subject {Player.new('John', community_cards, two_cards)}

    before do
      subject.identify_hand
    end

    context 'High card' do

      let(:community_cards) {%w(4S 7D 9S 6H 2D)}
      let(:two_cards) {%w(JH KC)}

      it 'returns the correct hand name and comparison string' do
        expect(subject.hand_name).to eq HIGH_CARD
        expect(subject.extra_info).to eq 'King'
        expect(subject.comparison_string).to eq "0-13-11-09-07-06"
      end

    end

    context 'Pair' do
      let(:community_cards) {%w(KS AD 3H 7C 6D)}
      let(:two_cards) {%w(4H 7S)}

      it 'returns the correct hand name and comparison string' do
        expect(subject.hand_name).to eq PAIR
        expect(subject.extra_info).to eq '7'
        expect(subject.comparison_string).to eq "1-07-07-14-13-06"
      end
    end

    context 'Two pair' do
      let(:community_cards) {%w(KS AD 3H 7C TD)}
      let(:two_cards) {%w(AC KH)}

      it 'returns the correct hand name and comparison string' do
        expect(subject.hand_name).to eq TWO_PAIR
        expect(subject.extra_info).to eq 'Ace King'
        expect(subject.comparison_string).to eq "2-14-14-13-13-10"
      end

    end

    context 'Three of a kind' do
      let(:community_cards) {%w(TH 3H TS 7C 5D)}
      let(:two_cards) {%w(TD QH)}

      it 'returns the correct hand name and comparison string' do
        expect(subject.hand_name).to eq THREE_OAK
        expect(subject.extra_info).to eq '10'
        expect(subject.comparison_string).to eq "3-10-10-10-12-07"
      end

    end

    context 'Straight' do

      context 'with Ace and King' do
        let(:community_cards) {%w(KS AD 3H 9C TD)}
        let(:two_cards) {%w(JD QC)}

        it 'returns the correct hand name and comparison string' do
          expect(subject.hand_name).to eq STRAIGHT
          expect(subject.extra_info).to eq 'Ace'
          expect(subject.comparison_string).to eq "4-14-13-12-11-10"
        end

      end

      context 'with Ace and 2' do
        let(:community_cards) {%w(AD 3H 4H 7C 5D)}
        let(:two_cards) {%w(2D QC)}

        it 'returns the correct hand name and comparison string' do
          expect(subject.hand_name).to eq STRAIGHT
          expect(subject.extra_info).to eq '5'
          expect(subject.comparison_string).to eq "4-05-04-03-02-01"
        end
      end

    end

    context 'Flush' do
      let(:community_cards) {%w(AH 3H 4H TH 5C)}
      let(:two_cards) {%w(2D JH)}

      it 'returns the correct hand name and comparison string' do
        expect(subject.hand_name).to eq FLUSH
        expect(subject.extra_info).to eq 'Ace'
        expect(subject.comparison_string).to eq "5-14-11-10-04-03"
      end

    end

    context 'Full house' do

      context 'one three-oak' do
        let(:community_cards) {%w(4D 4H 3H JC 4C)}
        let(:two_cards) {%w(3D JD)}

        it 'returns the correct hand name and comparison string' do
          expect(subject.hand_name).to eq FULL_HOUSE
          expect(subject.extra_info).to eq '4 Jack'
          expect(subject.comparison_string).to eq "6-04-04-04-11-11"
        end
      end

      context 'two three-oak' do
        let(:community_cards) {%w(4D 4H 3H 3C 4C)}
        let(:two_cards) {%w(3D QC)}

        it 'returns the correct hand name and comparison string' do
          expect(subject.hand_name).to eq FULL_HOUSE
          expect(subject.extra_info).to eq '4 3'
          expect(subject.comparison_string).to eq "6-04-04-04-03-03"
        end
      end
    end

    context 'Four of a kind' do
      let(:community_cards) {%w(AD 5H 5C 7C 5S)}
      let(:two_cards) {%w(5D 3H)}

      it 'returns the correct hand name and comparison string' do
        expect(subject.hand_name).to eq FOUR_OAK
        expect(subject.extra_info).to eq '5'
        expect(subject.comparison_string).to eq "7-05-05-05-05-14"
      end

    end

    context 'Straight flush' do

      context '5 straight' do

        let(:community_cards) {%w(AD 2H 2D 5D 4D)}
        let(:two_cards) {%w(3D QC)}

        it 'returns the correct hand name and comparison string' do
          expect(subject.hand_name).to eq STRAIGHT_FLUSH
          expect(subject.extra_info).to eq '5'
          expect(subject.comparison_string).to eq "8-05-04-03-02-01"
        end
      end

      context '7 straight' do

        let(:community_cards) {%w(AD 2D 3D 5D 6D)}
        let(:two_cards) {%w(4D 7C)}

        it 'returns the correct hand name and comparison string' do
          expect(subject.hand_name).to eq STRAIGHT_FLUSH
          expect(subject.extra_info).to eq '6'
          expect(subject.comparison_string).to eq "8-06-05-04-03-02"
        end
      end

      context 'not straight flush - just flush' do

        let(:community_cards) {%w(AD 2D 3H 5D 6D)}
        let(:two_cards) {%w(4D 7C)}

        it 'returns the correct hand name and comparison string' do
          expect(subject.hand_name).to eq FLUSH
          expect(subject.extra_info).to eq 'Ace'
          expect(subject.comparison_string).to eq "5-14-06-05-04-02"
        end
      end

    end

    context 'Royal flush' do

      let(:community_cards) {%w(KH AH 2H 5H TH)}
      let(:two_cards) {%w(JH QH)}

      it 'returns the correct hand name and comparison string' do
        expect(subject.hand_name).to eq ROYAL_FLUSH
        expect(subject.extra_info).to eq ''
        expect(subject.comparison_string).to eq "9-14-13-12-11-10"
      end

    end

  end
end