# TODO: Documentation
module Ked
  # HashMap of reserved words to their representative tokens
  RESERVED_WORDS = {
    "remember" => Token.new(TokenType::REMEMBER, "REMEMBER"),
    "€"        => Token.new(TokenType::VAR_PREFIX, '€'),
    "like"     => Token.new(TokenType::LIKE, "like"),
    "plus"     => Token.new(TokenType::PLUS, "plus"),
    "awayFrom" => Token.new(TokenType::AWAY_FROM, "awayFrom"),
    "times"    => Token.new(TokenType::TIMES, "times"),
    "into"     => Token.new(TokenType::INTO, "into"),
  }

  # The terminator character marking the end of input
  # Using this instead of nil to avoid having `not_nil!` calls all over the shop
  TERMINATOR = '\u{0}'

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
      raise "Error when parsing input: position #{@pos}"
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

    def skip_whitespace
      while @current_char != Ked::TERMINATOR && @current_char == ' '
        self.advance
      end
    end

    # Return a multidigit integer consumed from the text
    def get_integer : Int
      result = [] of Char
      while @current_char != Ked::TERMINATOR && @current_char.to_i?
        result << @current_char
        self.advance
      end
      result.join("").to_i
    end

    # Lexical analyser (also known as scanner or tokeniser)
    #
    # This method is responsible for breaking a sentence apart into tokens. One token at a time.
    def get_next_token : Token
      # Loop through and generate tokens from the text
      while @current_char != Ked::TERMINATOR
        # Check for whitespace first
        if @current_char == ' '
          self.skip_whitespace
          next
        elsif @current_char.to_i?
          return Token.new TokenType::INTEGER, self.get_integer
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
