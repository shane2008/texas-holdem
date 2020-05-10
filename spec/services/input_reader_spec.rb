require_relative '../../services/input_reader'

describe InputReader do

  subject {InputReader.read}

  before do
    allow(STDIN).to receive(:gets).and_return(response)
  end

  describe ".read" do

    let(:response) {" KS AD  3H 7C TD\nJohn 9H 7S\nSam AC KH\nBecky JD QC\n\n"}

    context 'valid input' do
      it 'should prompt and return content from console' do

        expect{subject}
            .to output("Press ENTER on a new line to finish. For HELP run 'ruby texas_holdem_runner.rb help'\n").to_stdout
        expect(subject).to eq [' KS AD  3H 7C TD','John 9H 7S','Sam AC KH','Becky JD QC']
      end
    end

  end

end