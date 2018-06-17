# TODO: Documentation
module Ked
  # HashMap of reserved words to their representative tokens
  RESERVED_WORDS = {
    "remember" => Token.new(TokenType::REMEMBER, "remember"),
    "€"        => Token.new(TokenType::VAR_PREFIX, '€'),
    "like"     => Token.new(TokenType::LIKE, "like"),
    "plus"     => Token.new(TokenType::PLUS, "plus"),
    "awayFrom" => Token.new(TokenType::AWAY_FROM, "awayFrom"),
    "times"    => Token.new(TokenType::TIMES, "times"),
    "into"     => Token.new(TokenType::INTO, "into"),
    "easyInto" => Token.new(TokenType::EASY_INTO, "easyInto"),
  }

  # The terminator character marking the end of input
  # Using this instead of nil to avoid having `not_nil!` calls all over the shop
  TERMINATOR = '\u{0}'

  # Characters that are considered "whitespace" and should be skipped
  WHITESPACE_CHARS = [
    ' ',
    '\n',
  ]

  class Lexer
    @current_char : Char
    @pos : Int64 = 0_i64

    def initialize(@text : String)
      if @text.size != 0
        @current_char = @text[@pos]
      else
        @current_char = Ked::TERMINATOR
      end
    end

    def error
      raise "Error when parsing input: position #{@pos} (#{@text[@pos]})"
    end

    # Advance the 'pos' pointer and set the 'current_char' variable
    def advance
      @pos += 1
      if @pos > @text.size - 1
        @current_char = Ked::TERMINATOR
      else
        @current_char = @text[@pos]
      end
    end

    # Skip any character outlined in Ked::WHITESPACE_CHARS
    def skip_whitespace
      while @current_char != Ked::TERMINATOR && Ked::WHITESPACE_CHARS.includes? @current_char
        self.advance
      end
    end

    # Skip from a comment symbol to the end of a line
    def skip_comment
      while @current_char != '\n'
        self.advance
      end
      # Skip the newline char as well
      self.advance
    end

    # Return a multidigit integer or floating point number consumed from the text, as a Token
    def get_number : Token
      result = [] of Char
      is_float = false
      # First, get the integer part of the number
      while @current_char != Ked::TERMINATOR && @current_char.to_i?
        result << @current_char
        self.advance
      end

      # Next check if the current_character is a '.'
      if @current_char == '.'
        is_float = true
        result << @current_char
        self.advance

        # Get the portion of the number after the decimal point
        while @current_char != Ked::TERMINATOR && @current_char.to_i?
          result << @current_char
          self.advance
        end
      end
      # Join result together
      result = result.join ""
      if is_float
        result = result.to_f
      else
        result = result.to_i
      end
      # Create and return the token
      Token.new TokenType::NUMBER, result
    end

    # Lexical analyser (also known as scanner or tokeniser)
    #
    # This method is responsible for breaking a sentence apart into tokens. One token at a time.
    def get_next_token : Token
      # Loop through and generate tokens from the text
      while @current_char != Ked::TERMINATOR
        # Check for whitespace first
        if WHITESPACE_CHARS.includes? @current_char
          self.skip_whitespace
          next
          # Now check for comments
        elsif @current_char == '£'
          self.skip_comment
          next
        elsif @current_char.to_i?
          return self.get_number
        elsif @current_char == '+'
          self.advance
          return Token.new TokenType::UNARY_PLUS, '+'
        elsif @current_char == '-'
          self.advance
          return Token.new TokenType::MINUS, '-'
        elsif @current_char == '('
          self.advance
          return Token.new TokenType::OPEN_PAREN, '('
        elsif @current_char == ')'
          self.advance
          return Token.new TokenType::CLOSE_PAREN, ')'
        elsif @current_char == '='
          self.advance
          return Token.new TokenType::ASSIGN, '='
        end

        # Now check for the tokens that make up multiple characters
        if @current_char == '€' || @current_char.alphanumeric?
          return id
        end
        self.error
      end
      Token.new TokenType::EOF, Ked::TERMINATOR
    end

    # Check the next character in the text when lexing tokens from the text
    def peek : Char
      peek_pos = @pos + 1
      if peek_pos > @text.size - 1
        Ked::TERMINATOR
      else
        @text[peek_pos]
      end
    end

    # Handle parsing ID tokens, taking into account the reserved words in Ked
    private def id : Token
      result = [] of Char
      while @current_char != Ked::TERMINATOR && @current_char.alphanumeric?
        result << @current_char
        self.advance
      end
      # Special handling for the € VAR_ID symbol
      result = result.join ""
      if @current_char == '€'
        result = "€"
        advance
      end
      Ked::RESERVED_WORDS.fetch result, Token.new TokenType::ID, result
    end
  end
end
