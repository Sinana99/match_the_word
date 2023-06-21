require "yaml"


class Savefile
    attr_accessor :guesses, :display, :used_values, :codedword
    
    def initialize(guesses, code, display, used_values)
        @guesses = guesses
        @display = display
        @used_values = used_values
        @codedword = code

    end

    def to_yaml()
        YAML.dump({ 
            :guesses => @guesses,
            :display => @display,
            :used_values => @used_values,
            :codedword => codedword
            })
    end

    def from_yaml(savedata)
        data = YAML.load savedata
        p data

    end
    
    def get_guesses()
        self.guesses
    end

    def get_display()
        self.display
    end
    def get_used_values()
        self.used_values
    end
    def get_codedword()
        self.codedword
    end
    

end




def add_value(arr, letter, array)
    if !array.include?(letter) && !arr.include?(letter)
        arr.push(letter)
    end
    return arr   

end



def check_letter()
    letter = gets.chomp
    if letter == "5"
        return 5
    end
    while letter.length != 1 || !/[a-zA-Z]/.match?(letter)
        puts "Invalid input, try again"
        letter = gets.chomp.downcase
    end
    return letter
end



def check_used(letter, display, index_hash, used_values)

    while display.include?(letter) || index_hash.has_value?(letter) || used_values.include?(letter)
        puts "You have already used this value"
        puts "Try something else"
        letter = gets.chomp.downcase

    end

   return letter
end

def space()
    puts ""
end

def verify_letter(letter, codedword, index_hash,guesses, used_values, array)
    if codedword.include?(letter)
        p "it is in here! Goodjob!"
        codedword.split("").each_with_index do |_useless, index|
            
            
            if codedword[index] == letter && !index_hash.key?(index)
          

            index_hash[index] = letter

            end 
        end
        return guesses
    else
        p "Your letter was not in the word. Try again!"
        used_values = add_value(used_values, letter, array)
        return guesses -1
    
    end 

end

def show_stats(array, display)
    puts "used values: #{array.join(" ")}"
    p "#{display.join(" ")}"

    
end

def intro(guesses)
    puts "You got #{guesses} guesses left."
        space()
     p "input a letter or press 5 to save"

end


def save(guesses,display,used_values,codedword)
    puts "Enter your username, please"
    filename = gets.chomp
    Dir.mkdir("saves") unless Dir.exist?("saves")
    p "Enter your username"
    filename = "saves/#{filename}.yml"
    savefile = Savefile.new(guesses,codedword,display,used_values).to_yaml
  
    File.open(filename, "w") do |file|
    file.puts savefile

   end
    p "Your file has been saved. Thank you for playing!"
    exit

end

def get_code()
  words = File.open("words.txt","r")
  word = words.readlines
begin
    codedword = word[rand(word.length-1)].strip
end while !(codedword.length <= 12 && codedword.length >= 5)

return codedword

end

def gamestart(save = Savefile.new(guesses= 10, codedword = get_code(), display = Array.new(codedword.length, "_"), used_values =[]))
    index_hash = Hash.new()
    guesses = save.get_guesses
    display = save.get_display
    used_values = save.get_used_values
    codedword = save.get_codedword
    p "Welcome to playing hangman!"
    if guesses == 10 && used_values.length == 0 && !defined?(filename)
    p 'Do you want to 1) Start a new game or 2) Load your previous play?'

    load = gets.chomp.to_i

    while !(load == 1 || load == 2)
      puts "Enter 1 or 2"
      load = gets.chomp.to_i
    end
   else
     load = 1
   end
   puts !defined?(filename)
   if load == 2
   puts "Enter your username, please"
   filename = gets.chomp
   end

  


if load == 1
    p "Try to guess the word letter by letter. Goodluck!"
    array = used_values
    while display.join("") != codedword && guesses > 0
        intro(guesses)
        show_stats(array, display)

        
        letter = check_letter()
        if letter == 5
            save(guesses, display, used_values, codedword)
        end
        
        letter = check_used(letter, display,index_hash, used_values)
        space()
        
        guesses = verify_letter(letter, codedword, index_hash, guesses, used_values, array)

    index_hash.each do |key, value| 
         display[key] = value 
    end
    
    array = index_hash.values.push(used_values).uniq
    
    space()

    end

    puts display.join("") == codedword ? "You won! the word was #{codedword.upcase}" : "You lost:( the word was #{codedword.upcase}"
    if File.exist?("saves/#{filename}.yml")
     File.delete("saves/#{filename}.yml")
    end




else
   begin
   data = YAML.load_file("saves/#{filename}.yml")
   first = data[:guesses]
   second =  data[:display]
   third = data[:used_values]
   fourth = data[:codedword]
   p used_values
   save = Savefile.new(first,fourth,second,third)
   load -= 3

   rescue
    p "Savefile retrieveal fail. Try again with different username"
    exit
   end
   gamestart(save)
end

end

gamestart()
