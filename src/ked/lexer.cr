module Ked
  # Lexer takes source and generates a list of tokens from it
  # TODO - Lexer should take a File object which enables us to get things like filenames and linenumbers for the Tokens
  # => This should enable us to generate more meaningful errors
  class Lexer
    @pos : Int32 = 0      # Current position in input (points to current char)
    @read_pos : Int32 = 0 # Current reading position (after current char)
    @current_char : Char  # Current character being examined

    # TODO - Change input to be a file and use line / character based positioning instead of pos in String
    def initialize(@input : String)
      # Initialize the current_char
      @current_char = @input[@pos] # Will throw an error if the input string is empty but be grand for now
    end
  end
end
