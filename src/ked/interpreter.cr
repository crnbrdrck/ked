# TODO: Documentation
module Ked
  class Interpreter
    @text : String
    @pos : Int64 = 0_i64
    @current_token : Token | Nil = nil

    def initialize(@text : String)
    end

    def error
      raise "Error parsing input"
    end

    # Lexical analyser (also known as scanner or tokeniser)
    #
    # This method is responsible for breaking a sentence apart into tokens. One token at a time.
    def get_next_token : Token
      text = @text

      # If our current position has gone past the end of our text, return our EOF token as there is no more input to read
      if @pos > text.size - 1
        return Token.new TokenType::EOF, nil
      end

      # Get the character at our current position and create a Token based on it
      char = text[@pos]
      # Ignore whitespace
      while char == ' '
        @pos += 1
        char = text[@pos]
      end

      # Read what the current token is, create a Token if we can from it, incremement our current position and return the Token
      # If no token can be created from the input, raise an error
      if char.to_i?
        digits = [char]
        @pos += 1
        # Handle multiple digit integers
        until @pos == text.size || !text[@pos].to_i?
          digits << text[@pos]
          @pos += 1
        end
        number = digits.join("").to_i
        return Token.new TokenType::INTEGER, number
      elsif char == '+'
        @pos += 1
        return Token.new TokenType::PLUS, char
      elsif char == '-'
        @pos += 1
        return Token.new TokenType::MINUS, char
      end
      self.error
    end

    # Compare the current token type with the passed token type and if they match then "eat" the current token and assign the next token to current token, otherwise raise an exception
    def eat(token_type : TokenType)
      if @current_token.not_nil!.token_type == token_type
        @current_token = self.get_next_token
      else
        self.error
      end
    end

    # `expr -> INTEGER PLUS INTEGER`
    def expr
      # Set current token to first token from text
      @current_token = self.get_next_token
      # We expect the current token to be a single digit integer
      left = @current_token.not_nil!
      self.eat TokenType::INTEGER

      # Now we expect a PLUS or a MINUS symbol
      op = @current_token.not_nil!
      begin
        self.eat TokenType::PLUS
      rescue
        # If attempting to eat a PLUS symbol doesn't work, try a MINUS symbol instead
        self.eat TokenType::MINUS
      end

      # Lastly we expect another single digit integer
      right = @current_token.not_nil!
      self.eat TokenType::INTEGER
      # After this our current_token should be an EOF token

      # At this point, an INTEGER PLUS|MINUS INTEGER sequence of tokens has been found and this method can just return the result of adding|subtractig the two integers, thus effectively interpreting the user's input
      if op.token_type == TokenType::PLUS
        left.value.not_nil!.to_i + right.value.not_nil!.to_i
      elsif op.token_type == TokenType::MINUS
        left.value.not_nil!.to_i - right.value.not_nil!.to_i
      end
    end
  end
end
