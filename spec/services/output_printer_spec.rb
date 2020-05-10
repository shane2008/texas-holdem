require_relative '../../services/output_printer'
require_relative '../../services/processor'

describe OutputPrinter do

  describe "#print" do

    context 'different hands' do

      let(:input_lines) {['KS AD 3H 7C TD', 'John 9H 7S', 'Sam AC KH', 'Becky JD QC']}
      let(:players) {Processor.new(input_lines).parse_n_identify_n_rank}

      it 'prints name and descriptions' do
        expect{OutputPrinter.new(players).print}.
            to output("1 Becky Straight Ace \n2 Sam Two Pair Ace King \n3 John Pair 7 \n").to_stdout
      end

    end

    context 'same hands' do

      context 'no kicker needed' do

        let(:input_lines) {['KS AD 3H 7C TD', 'John 9H 7S', 'Sam 3C QH']}
        let(:players) {Processor.new(input_lines).parse_n_identify_n_rank}

        it 'prints name and descriptions' do
          expect{OutputPrinter.new(players).print}.
              to output("1 John Pair 7 \n2 Sam Pair 3 \n").to_stdout
        end

      end

      context 'kicker needed' do

        let(:input_lines) {['AS TD TS 3C 2C', 'John AC KC', 'Sam AH 8H']}
        let(:players) {Processor.new(input_lines).parse_n_identify_n_rank}

        it 'include kicker' do
          expect{OutputPrinter.new(players).print}.
              to output("1 John Two Pair Ace 10 Kicker King\n2 Sam Two Pair Ace 10 \n").to_stdout
        end

      end

      context 'tie' do

        let(:input_lines) {['AS TD TS 3C 2C', 'John aC 8C', 'Sam AH 8H', 'Tom 2H 5D']}
        let(:players) {Processor.new(input_lines).parse_n_identify_n_rank}

        it 'displays the same rankings' do
          expect{OutputPrinter.new(players).print}.
              to output("1 John Two Pair Ace 10 \n1 Sam Two Pair Ace 10 \n3 Tom Two Pair 10 2 \n").to_stdout
        end

      end

    end

  end
end