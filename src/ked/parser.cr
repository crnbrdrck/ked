require "./ast/*"

# TODO: Documentation
module Ked
  # Grammar rules
  # expr:   term ((ADD | SUB) term)*
  # term:   factor ((MUL | DIV) factor)*
  # factor: INTEGER | OPEN_PAREN expr CLOSE_PAREN
  class Parser
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
    # expr: term ((ADD | SUB) term)*
    def expr : AST
      token_types = [
        TokenType::ADD,
        TokenType::SUBTRACT,
      ]
      # Get the first term for our expr (which is not optional according to our grammar rules)
      node : AST = self.term
      while token_types.includes? @current_token.token_type
        token = @current_token
        # Depending on which symbol our current token is currently on, do some maths
        if @current_token.token_type == TokenType::ADD
          self.eat TokenType::ADD
        elsif @current_token.token_type == TokenType::SUBTRACT
          self.eat TokenType::SUBTRACT
        end
        node = BinOp.new left: node, token: token, right: self.term
      end
      node
    end

    # term: factor ((MUL | DIV) factor)*
    def term : AST
      token_types = [
        TokenType::MULTIPLY,
        TokenType::DIVIDE,
      ]
      # Get the first factor for our term (which is not optional according to our grammar rules)
      node : AST = self.factor
      while token_types.includes? @current_token.token_type
        token = @current_token
        # Depending on which symbol our current token is currently on, do some maths
        if @current_token.token_type == TokenType::MULTIPLY
          self.eat TokenType::MULTIPLY
        elsif @current_token.token_type == TokenType::DIVIDE
          self.eat TokenType::DIVIDE
        end
        node = BinOp.new left: node, token: token, right: self.factor
      end
      node
    end

    # factor: INTEGER | OPEN_PAREN expr CLOSE_PAREN
    def factor : AST
      token = @current_token
      if token.token_type == TokenType::INTEGER
        self.eat TokenType::INTEGER
        return Num.new token
      elsif token.token_type == TokenType::OPEN_PAREN
        self.eat TokenType::OPEN_PAREN
        node = self.expr
        self.eat TokenType::CLOSE_PAREN
        return node
      end
      self.error
    end
  end
end
