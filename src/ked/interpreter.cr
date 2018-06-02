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
      while char == ' '
        @pos += 1
        char = text[@pos]
      end

      # Read what the current token is, create a Token if we can from it, incremement our current position and return the Token
      # If no token can be created from the input, raise an error
      if char.to_i?
        @pos += 1
        return Token.new TokenType::INTEGER, char.to_i
      elsif char == '+'
        @pos += 1
        return Token.new TokenType::PLUS, char
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

      # Now we expect a PLUS symbol
      op = @current_token.not_nil!
      self.eat TokenType::PLUS

      # Lastly we expect another single digit integer
      right = @current_token.not_nil!
      self.eat TokenType::INTEGER
      # After this our current_token should be an EOF token

      # At this point, an INTEGER PLUS INTEGER sequence of tokens has been found and this method can just return the result of adding the two integers, thus effectively interpreting the user's input
      left.value.not_nil!.to_i + right.value.not_nil!.to_i
    end
  end
end
