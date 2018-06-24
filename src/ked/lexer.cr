module Ked
  # Null character
  NULL_CHAR = '\u{0}'

  # Lexer takes source and generates a list of tokens from it
  # TODO - Lexer should take a File object which enables us to get things like filenames and linenumbers for the Tokens
  # => This should enable us to generate more meaningful errors
  class Lexer
    @pos : Int32 = 0                      # Current position in input (points to current char)
    @read_pos : Int32 = 0                 # Current reading position (after current char)
    @current_char : Char = Ked::NULL_CHAR # Current character being examined

    # TODO - Change input to be a file and use line / character based positioning instead of pos in String
    def initialize(@input : String)
      # Initialize the current_char
      self.read_char
    end

    # Read the next character in the input, checking first to see if we have reached the end of the input
    def read_char
      if @read_pos >= @input.size
        @current_char = Ked::NULL_CHAR
      else
        @current_char = @input[@read_pos]
      end
      # Update the positions of read_pos and pos
      @pos = @read_pos
      @read_pos += 1
    end

    # Generate the next token from the input
    def get_next_token : Ked::Token
      token : Ked::Token
      case @current_char
      when '='
        token = Token.new TokenType::ASSIGN, "="
      when '('
        token = Token.new TokenType::LPAREN, "("
      when ')'
        token = Token.new TokenType::RPAREN, ")"
      when '{'
        token = Token.new TokenType::LBRACE, "{"
      when '}'
        token = Token.new TokenType::RBRACE, "}"
      when ','
        token = Token.new TokenType::COMMA, ","
      when '€'
        token = Token.new TokenType::VAR_PREFIX, "€"
      when Ked::NULL_CHAR
        token = Token.new TokenType::EOF, ""
      end
      # Read the next character and return the created token
      self.read_char
      token
    end
  end
end
