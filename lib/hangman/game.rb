require "json"

def get_secret_word
  dictionary = File.open("5desk.txt", "r")
  words = dictionary.readlines
  secret_word = ""
  until (5..12).to_a.include?(secret_word.length)
    secret_word = words.sample.upcase.chomp
  end
  dictionary.close
  secret_word.split("")
end

class Game
  attr_accessor :save_game, :finished

  def initialize(misses = 0)
    @secret_word = get_secret_word #"TEST".split("")
    @guess_word = []
    (@secret_word.length).times { |i| @guess_word << "_" }
    @misses = misses
    @misses_limit = 10
    @missed_letters = []
    @finished = false
    @save_game = false
  end

  def to_json
    hash = {}
    self.instance_variables.each do |v|
      hash[v] = self.instance_variable_get(v)
    end
    hash.to_json
  end

  def from_json!(string)
    JSON.load(string).each do |v, val|
      self.instance_variable_set v, val
    end
  end

  def play
    while @finished == false
      draw
      misses_counter
      get_guess
      guess_letter_to_word
      @finished = is_finished?
      puts
    end
  end

  def misses_counter
    puts "#{@misses}/#{@misses_limit} Misses"
    puts "Misses: #{@missed_letters.join(" ")}" if @missed_letters.empty? == false
  end

  def draw
    puts @guess_word.join(" ")
  end

  def get_response
    gets.chomp.upcase
  end

  def get_guess
    puts "Enter your guess: [A-Z] [GUESSWORD] [SAVE]"
    @guess_letter = get_response
    if @guess_letter == "GUESSWORD"
      get_full_guessword
    elsif @guess_letter == "SAVE"
    elsif not /^[A-Z]$/.match(@guess_letter)
      puts "Invalid guess. Please try again."
    elsif @missed_letters.include?(@guess_letter)
      puts "You have entered '#{@guess_letter}' already."
    end
  end

  def guess_letter_to_word
    if @secret_word.include?(@guess_letter)
      puts "There is '#{@guess_letter}'."
      @secret_word.each_with_index do |letter, i|
        if letter == @guess_letter
          @guess_word[i] = letter
        end
      end
    elsif @guess_letter == "SAVE" || @missed_letters.include?(@guess_letter)

    else
      if /^[A-Z]$/.match(@guess_letter)
        @misses += 1
        @missed_letters << @guess_letter
        puts "There is no '#{@guess_letter}'."
      end
    end
  end

  def get_full_guessword
    puts "Enter your guess word:"
    @guess_word_full = get_response.split("")
    @misses += 1
  end

  def is_finished?
    if @guess_letter == "SAVE"
      @save_game = true
      true
    elsif @guess_word_full == @secret_word || @guess_word == @secret_word || @misses == @misses_limit
      win_or_lose
      true
    else
      false
    end
  end

  def win_or_lose
    if @guess_word_full == @secret_word || @guess_word == @secret_word
      puts "You WIN!"
    else
      puts "You LOSE!"
    end
    puts "ANSWER: \n#{@secret_word.join(" ")}"
  end
end
