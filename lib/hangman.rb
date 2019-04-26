
class Game
    attr_accessor :letters_guessed
    attr_accessor :wrong_letters
    attr_reader :word

    def initialize(mode)
        if mode =~ /S/i
            load
        else
            @word = pick_word
            @letters_guessed = {}
            @wrong_letters = 0
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

    def load###
        @word = pick_word
        @letters_guessed = {}
        @wrong_letters = 0
    end
end

class UI
    @@MAX_GUESSES = 10

    def initialize
        mode = ""
        until mode =~ /^[NS]$/i
            puts "Please press N for new game or S to load saved game."
            mode = gets.chomp
        end

        @game = Game.new(mode)
        display_word
        take_turn until @game.wrong_letters == @@MAX_GUESSES
        puts "Hangman dies. The word was #{@game.word.join}"
    end

    def display_word(guess = "")
        correct = false
        blanks = false
        display_string = ""
        @game.word.each do |letter|
            if guess == letter
                display_string += "#{letter} "
                correct = true
            elsif @game.letters_guessed.has_key?(letter)
                display_string += "#{letter} "
            else
                display_string += "_ "
                blanks = true
            end
        end
        @game.wrong_letters += 1 unless correct && guess != ""
        display_string += " (#{@@MAX_GUESSES - @game.wrong_letters} guesses remaining)"
        puts display_string
        unless blanks
            puts "You win!"
            exit
        end
    end

    def take_turn
        input = ""
        until input =~ /^[A-Z]$/i || input =~ /SAVE/i
            puts "Guess a letter or type SAVE to save game."
            input = gets.chomp
        end
        input = input.upcase
        save_game if input =~ /SAVE/
        if @game.letters_guessed.has_key?(input)
            puts "You already guessed #{input}!"
            return
        end
        @game.letters_guessed[input] = ""
        display_word(input)
    end

    def save_game
        id = ""###
        game_data = ""###word, letters guessed, wrong letters
        Dir.mkdir("saved_games") unless Dir.exists? "saved_games"
        filename = "saved_games/game_#{id}"
        File.open(filename,'w') do |file|
            file.puts game_data
        end
        exit
    end
end

UI.new