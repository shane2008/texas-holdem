require_relative '../../services/processor'

describe Processor do

  describe "#parse_n_identify_n_rank" do

    subject {Processor.new(input_lines)}

    describe "parse error" do

      context 'community cards and one player required' do

        let(:input_lines) {['']}

        it 'raises error' do
          expect(subject).to receive(:puts).with('Community cards and at one player is required')
          subject.parse_n_identify_n_rank
        end

      end

      context 'Invalid format for community cards line' do

        let(:input_lines) {['KS AD 3H 7C', 'John 9H 7S']}

        it 'raises error' do
          expect(subject).to receive(:puts).with('Invalid input for community cards - line 1')
          subject.parse_n_identify_n_rank
        end

      end

      context 'Invalid community card' do
        let(:input_lines) {['KS AD 3H 7C KK', 'John 9H 7S']}
        it 'raises error' do
          expect(subject).to receive(:puts).with('Invalid card KK - line 1')
          subject.parse_n_identify_n_rank
        end

      end

      context 'Invalid input for player line' do
        let(:input_lines) {['KS AD 3H 7C 9C', 'John Smith 9H 7S']}
        it 'raises error' do
          expect(subject).to receive(:puts).with('Invalid input for player - line 2')
          subject.parse_n_identify_n_rank
        end

      end

      context 'Invalid card in player line' do
        let(:input_lines) {['KS AD 3H 7C 9C', 'John 9H 7P']}
        it 'raises error' do
          expect(subject).to receive(:puts).with('Invalid card 7P - line 2')
          subject.parse_n_identify_n_rank
        end

      end

      context 'duplicate card detected' do

        let(:input_lines) {['KS AD 3H 7C 9C', 'John 3H 7S']}
        it 'raises error' do
          expect(subject).to receive(:puts).with('Duplicate card 3H - line 2')
          subject.parse_n_identify_n_rank
        end

      end

    end

    describe 'ranking players by hands' do

      context 'players have different hands' do
        let(:input_lines) {['KS AD 3H 7C TD', 'John 9H 7S', 'Sam AC KH', 'Becky JD QC']}

        it 'returns players based on ranked hand' do
          players = subject.parse_n_identify_n_rank
          expect(players.map{|player| player.name}).to eq ["Becky", "Sam", "John"]
        end

      end

      context 'players have same hands' do
        let(:input_lines) {['KS AD 3H 7C TD', 'John 9H 7S', 'Becky JD KC']}

        it 'returns players based on ranked hand' do
          players = subject.parse_n_identify_n_rank
          expect(players.map{|player| player.name}).to eq ["Becky", "John"]
        end

      end

      context 'works with lower case face and suit' do
        let(:input_lines) {['ks AD 3H 7C td', 'John 9H 7S', 'Sam Ac KH', 'Becky jd QC']}

        it 'returns players based on ranked hand' do
          players = subject.parse_n_identify_n_rank
          expect(players.map{|player| player.name}).to eq ["Becky", "Sam", "John"]
        end

      end

    end

  end
end