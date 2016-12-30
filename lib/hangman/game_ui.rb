puts "Welcome to Hangman!"

def introduction
  puts %(Please select your option.

[1] New Game
[2] Load Game
[3] Exit
  )
end

option = ""

while not (1..3).include?(option)
  introduction
  option = gets.chomp

  case option
  when "1"
    puts "New Game!"
    game = Game.new
  when "2"
    puts "Load Game"
  when "3"
    puts "Exited.\nThanks for playing!"
    break
  else
    puts "Please enter valid option:"
  end
end
