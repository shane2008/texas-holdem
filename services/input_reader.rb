class InputReader

  def self.read

    puts "Press ENTER on a new line to finish. For HELP run 'ruby texas_holdem_runner.rb help'"
    input = STDIN.gets("\n\n").chomp
    return input.split("\n")

  end

end