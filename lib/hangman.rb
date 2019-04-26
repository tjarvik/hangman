
class Game
    @@MAX_GUESSES = 10

    def initialize(mode)
        if mode =~ /S/i
            #load
        else
            @word = pick_word
            @letters_guessed = {}
            @wrong_letters = 0
        end
        display_word
        until @wrong_letters == @@MAX_GUESSES
            take_turn
        end
        puts "Hangman dies. The word was #{@word.join}"
    end

    def take_turn
        input = ""
        until input =~ /^[A-Z]$/i || input =~ /SAVE/i
            puts "Guess a letter or type SAVE to save game."
            input = gets.chomp
        end
        input = input.upcase
        save_game if input =~ /SAVE/
        if @letters_guessed.has_key?(input)
            puts "You already guessed #{input}!"
            return
        end
        @letters_guessed[input] = ""

        display_word(input)
    end

    def display_word(guess = "")
        correct = false
        blanks = false
        display_string = ""
        @word.each do |letter|
            if guess == letter
                display_string += "#{letter} "
                correct = true
            elsif @letters_guessed.has_key?(letter)
                display_string += "#{letter} "
            else
                display_string += "_ "
                blanks = true
            end
        end
        @wrong_letters += 1 unless correct && guess != ""
        display_string += " (#{@@MAX_GUESSES - @wrong_letters} guesses remaining)"
        puts display_string
        unless blanks
            puts "You win!"
            exit
        end
    end

    def pick_word
        filename = "5desk_dictionary.txt"
        choices = []
        File.readlines(filename).each do |line|
            next if line =~ /[A-Z]/
            line = line.strip
            next unless line.length.between?(5, 12)
            choices << line
        end
        choices[rand(0..(choices.length - 1))].upcase.split("")
    end

    def load

    end

    def save_game
        id = ""###
        game_data = ""###
        Dir.mkdir("saved_games") unless Dir.exists? "saved_games"
        filename = "saved_games/game_#{id}"
        File.open(filename,'w') do |file|
            file.puts game_data
        end
        exit
    end
end


class UI
    mode = ""
    until mode =~ /^[NS]$/i
        puts "Please press N for new game or S to load saved game."
        mode = gets.chomp
    end

    Game.new(mode)
end

UI.new