# TODO: Documentation
module Ked
  class Interpreter
    @text : String
    @current_char : Char
    @pos : Int64 = 0_i64
    @current_token : Token = Token.new TokenType::SOF, '\u{0}'

    def initialize(@text : String)
      if @text.size != 0
        @current_char = @text[@pos]
      else
        @current_char = '\u{0}'
      end
    end

    def error
      raise "Error parsing input"
    end

    # Advance the 'pos' pointer and set the 'current_char' variable
    def advance
      @pos += 1
      if @pos > @text.size - 1
        @current_char = '\u{0}'
      else
        @current_char = @text[@pos]
      end
    end

    def skip_whitespace
      while @current_char != '\u{0}' && @current_char == ' '
        self.advance
      end
    end

    # Return a multidigit integer consumed from the text
    def get_integer : Int
      result = [] of Char
      while @current_char != '\u{0}' && @current_char.to_i?
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
      while @current_char != '\u{0}'
        # Check for whitespace first
        if @current_char == ' '
          self.skip_whitespace
          next
        elsif @current_char.to_i?
          return Token.new TokenType::INTEGER, self.get_integer
        elsif @current_char == '+'
          self.advance
          return Token.new TokenType::PLUS, '+'
        elsif @current_char == '-'
          self.advance
          return Token.new TokenType::MINUS, '-'
        elsif @current_char == '*'
          self.advance
          return Token.new TokenType::MULTIPLY, '*'
        end
        self.error
      end
      Token.new TokenType::EOF, '\u{0}'
    end

    # Compare the current token type with the passed token type and if they match then "eat" the current token and assign the next token to current token, otherwise raise an exception
    def eat(token_type : TokenType)
      if @current_token.token_type == token_type
        @current_token = self.get_next_token
      else
        self.error
      end
    end

    # `expr -> INTEGER OPERATOR INTEGER`
    def expr
      # Set current token to first token from text
      @current_token = self.get_next_token
      # We expect the current token to be a single digit integer
      left = @current_token
      self.eat TokenType::INTEGER

      # Now we expect a PLUS or a MINUS symbol
      op = @current_token
      case op.token_type
      when TokenType::PLUS
        self.eat TokenType::PLUS
      when TokenType::MINUS
        self.eat TokenType::MINUS
      when TokenType::MULTIPLY
        self.eat TokenType::MULTIPLY
      end

      # Lastly we expect another single digit integer
      right = @current_token
      self.eat TokenType::INTEGER
      # After this our current_token should be an EOF token

      # At this point, an INTEGER OPERATOR INTEGER sequence of tokens has been found and this method can just return the result of running the operator on the two integers, thus effectively interpreting the user's input
      case op.token_type
      when TokenType::PLUS
        return left.value.to_i + right.value.to_i
      when TokenType::MINUS
        return left.value.to_i - right.value.to_i
      when TokenType::MULTIPLY
        return left.value.to_i * right.value.to_i
      end
    end
  end
end
