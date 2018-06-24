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
      self.read_next_char
    end

    # Read the next character in the input, checking first to see if we have reached the end of the input
    def read_next_char
      if @read_pos >= @input.size
        @current_char = Ked::NULL_CHAR
      else
        @current_char = @input[@read_pos]
      end
      # Update the positions of read_pos and pos
      @pos = @read_pos
      @read_pos += 1
    end

    # Skips whitespace characters entirely as they don't mean anything in ked
    def skip_whitespace_chars
      # TODO - Handle EOL tokens separately when we move to line based lexing
      while @current_char == ' ' || @current_char == '\t' || @current_char == '\n' || @current_char == '\r'
        self.read_next_char
      end
    end

    # Generate the next token from the input
    def get_next_token : Ked::Token
      # Skip whitespace before reading next token
      self.skip_whitespace_chars
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
      else
        # We need to check if the current character is a letter, and if so try to generate a keyword token for it
        if self.is_valid_identifier_char? @current_char
          value = self.read_identifier
          token_type = Ked::KEYWORDS.fetch value, TokenType::IDENT
          # Early return to avoid the extra call to read_next_char
          return Token.new token_type, value
        elsif @current_char.to_i?
          return Token.new TokenType::NUMBER, self.read_number
        else
          token = Token.new TokenType::ILLEGAL, @current_char.to_s
        end
      end
      # Read the next character and return the created token
      self.read_next_char
      token
    end

    # Method that reads in a series of characters as a potential token value
    def read_identifier
      pos = @pos
      while self.is_valid_identifier_char? @current_char
        self.read_next_char
      end
      # The identifier is the string between pos and @pos
      @input[pos...@pos]
    end

    # Method to read in multi digit numbers
    def read_number
      pos = @pos
      # TODO - Add float handling
      while @current_char.to_i?
        self.read_next_char
      end
      # The number is the string between pos and @pos
      @input[pos...@pos]
    end

    # Helper that checks if the character is a valid character for identifier names
    def is_valid_identifier_char?(char : Char)
      char.letter? || char == '_'
    end
  end
end
