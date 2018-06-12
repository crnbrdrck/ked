require "./ast/*"

# TODO: Documentation
module Ked
  # Grammar rules
  # program:              statement_list
  # statement_list:       statement LIKE | statement LIKE statement_list
  # statement:            assignment_statement | empty
  # assignment_statement: REMEMBER variable ASSIGN expr
  # variable:             VAR_PREFIX ID
  # expr:                 term ((PLUS | MINUS) term)*
  # term:                 factor ((MUL | DIV) factor)*
  # factor:               PLUS factor | MINUS factor | INTEGER | OPEN_PAREN expr CLOSE_PAREN | variable
  # empty:
  class Parser
    @lexer : Lexer
    @current_token : Token

    def initialize(text : String)
      @lexer = Lexer.new text
      @current_token = @lexer.get_next_token
    end

    def parse : AST
      expr
    end

    private def error
      raise "Error when parsing input"
    end

    # Compare the current token type with the passed token type and if they match then "eat" the current token and assign the next token to current token, otherwise raise an exception
    private def eat(token_type : TokenType)
      if @current_token.token_type == token_type
        @current_token = @lexer.get_next_token
      else
        error
      end
    end

    # Grammar rules implementations
    # expr: term ((PLUS | MINUS) term)*
    private def expr : AST
      token_types = [
        TokenType::PLUS,
        TokenType::MINUS,
      ]
      # Get the first term for our expr (which is not optional according to our grammar rules)
      node : AST = term
      while token_types.includes? @current_token.token_type
        token = @current_token
        # Depending on which symbol our current token is currently on, do some maths
        if @current_token.token_type == TokenType::PLUS
          eat TokenType::PLUS
        elsif @current_token.token_type == TokenType::MINUS
          eat TokenType::MINUS
        end
        node = BinOp.new left: node, token: token, right: term
      end
      node
    end

    # term: factor ((MUL | DIV) factor)*
    private def term : AST
      token_types = [
        TokenType::MULTIPLY,
        TokenType::DIVIDE,
      ]
      # Get the first factor for our term (which is not optional according to our grammar rules)
      node : AST = factor
      while token_types.includes? @current_token.token_type
        token = @current_token
        # Depending on which symbol our current token is currently on, do some maths
        if @current_token.token_type == TokenType::MULTIPLY
          eat TokenType::MULTIPLY
        elsif @current_token.token_type == TokenType::DIVIDE
          eat TokenType::DIVIDE
        end
        node = BinOp.new left: node, token: token, right: factor
      end
      node
    end

    # factor: INTEGER | OPEN_PAREN expr CLOSE_PAREN
    private def factor : AST
      token = @current_token
      if token.token_type == TokenType::PLUS
        eat TokenType::PLUS
        return UnaryOp.new token: token, expr: factor
      elsif token.token_type == TokenType::MINUS
        eat TokenType::MINUS
        return UnaryOp.new token: token, expr: factor
      elsif token.token_type == TokenType::INTEGER
        eat TokenType::INTEGER
        return Num.new token
      elsif token.token_type == TokenType::OPEN_PAREN
        eat TokenType::OPEN_PAREN
        node = expr
        eat TokenType::CLOSE_PAREN
        return node
      end
      error
    end
  end
end
