require "json"

puts "Welcome to Hangman!"

def introduction
  puts %(
Please select your option.
[1] New Game
[2] Load Game
[3] Exit
  )
end

option = ""
$save_folder = "save_data"
$save_file = "save_file.json"

def save(game)
  if game.save_game == true
    Dir.mkdir($save_folder) unless File.exist?($save_folder)
    file = File.open($save_folder + "/" + $save_file, "w")
    file.puts game.to_json
    file.close
    puts "You have saved the game."
  end
end

def load(game)
  load_file = File.open($save_folder + "/" + $save_file, "r")
  game.from_json!(load_file)
  game.save_game = false
  game.finished = false
end

while not (1..3).include?(option)
  introduction
  option = gets.chomp

  case option
  when "1"
    puts "New Game!"
    game = Game.new()
    game.play

    if game.save_game == true
      save(game)
    end
  when "2"
    puts "Load Game"
    load(game = Game.new())
    game.play

    if game.save_game == true
      save(game)
    end
  when "3"
    puts "Exited.\nThanks for playing!"
    break
  else
    puts "Please enter valid option."
  end
end
