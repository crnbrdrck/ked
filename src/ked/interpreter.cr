# TODO: Documentation
module Ked
  # Grammar rules
  # expr:   factor ((MUL | DIV) factor)*
  # factor: INTEGER
  class Interpreter
    @lexer : Lexer
    @current_token : Token

    def initialize(text : String)
      @lexer = Lexer.new text
      @current_token = @lexer.get_next_token
    end

    def error
      raise "Error when parsing input"
    end

    # Compare the current token type with the passed token type and if they match then "eat" the current token and assign the next token to current token, otherwise raise an exception
    def eat(token_type : TokenType)
      if @current_token.token_type == token_type
        @current_token = @lexer.get_next_token
      else
        self.error
      end
    end

    # Grammar rules implementations
    # factor: INTEGER
    def factor : Int
      token = @current_token
      self.eat TokenType::INTEGER
      token.value.to_i
    end

    # expr: factor ((MUL | DIV) factor)*
    def expr : Int
      token_types = [
        TokenType::MULTIPLY,
        TokenType::DIVIDE,
      ]
      # Get the first factor for our expr (which is not optional according to our grammar rules)
      result = self.factor
      while token_types.includes? @current_token.token_type
        # Depending on which symbol our current token is currently on, do some maths
        if @current_token.token_type == TokenType::MULTIPLY
          self.eat TokenType::MULTIPLY
          result *= self.factor
        elsif @current_token.token_type == TokenType::DIVIDE
          self.eat TokenType::DIVIDE
          result /= self.factor
        end
      end
      result
    end
  end
end
