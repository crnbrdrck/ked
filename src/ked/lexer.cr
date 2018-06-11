module Ked
  class Lexer
    @current_char : Char
    @pos : Int64 = 0_i64

    def initialize(@text : String)
      if @text.size != 0
        @current_char = @text[@pos]
      else
        @current_char = '\u{0}'
      end
    end

    def error
      raise "Error when parsing input: position #{@pos}"
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
          return Token.new TokenType::ADD, '+'
        elsif @current_char == '-'
          self.advance
          return Token.new TokenType::SUBTRACT, '-'
        elsif @current_char == '*'
          self.advance
          return Token.new TokenType::MULTIPLY, '*'
        elsif @current_char == '/'
          self.advance
          return Token.new TokenType::DIVIDE, '/'
        end
        self.error
      end
      Token.new TokenType::EOF, '\u{0}'
    end
  end
end
