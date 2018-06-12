require "./ast/*"

# TODO: Documentation
module Ked
  # Grammar rules
  # program:              statement_list
  # statement_list:       statement LIKE | statement LIKE statement_list
  # statement:            assignment_statement | empty
  # assignment_statement: REMEMBER variable ASSIGN expr
  # variable:             VAR_PREFIX ID
  # expr:                 term ((PLUS | AWAY_FROM) term)*
  # term:                 factor ((TIMES | INTO) factor)*
  # factor:               UNARY_PLUS factor | MINUS factor | INTEGER | OPEN_PAREN expr CLOSE_PAREN | variable
  # empty:
  class Parser
    @lexer : Lexer
    @current_token : Token

    def initialize(text : String)
      @lexer = Lexer.new text
      @current_token = @lexer.get_next_token
    end

    def parse : AST::Node
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
    # program: statement_list
    private def program : AST::Node
      statement_list
    end

    # statement_list: statement LIKE | statement LIKE statement_list
    private def statement_list : AST::Node
      # There's guaranteed to be at least one statement and a LIKE terminator
      node = statement
      nodes = [node]

      # Now there could be another statement_list here, all statements separated by LIKE tokens
      while @current_token.token_type == TokenType::LIKE
        eat TokenType::LIKE
        nodes << statement
      end

      # There has to be a terminating LIKE here at the end too
      eat TokenType::LIKE

      # We shouldn't be currently looking at an ID type token
      if @current_token.token_type == TokenType::ID
        error
      end

      # Return the list we parsed
      nodes
    end

    # statement: assignment_statement | empty
    private def statement : AST::Node
      if @current_token.token_type == TokenType::REMEMBER
        node = assignment_statement
      else
        node = empty
      end
      # Return the found node
      node
    end

    # assignment_statement: REMEMBER variable ASSIGN expr
    private def assignment_statement : AST::Node
      # Ensure statement begins with REMEMBER token
      eat TokenType::REMEMBER
      left = variable
      token = @current_token
      eat TokenType::ASSIGN
      right = expr
      node = AST::Assign.new
    end

    # variable: VAR_PREFIX ID
    private def variable : AST::Node
      # Ensure that variables are prefixed with the € symbol
      eat TokenType::VAR_PREFIX
      # Create and return a Var node
      AST::Var.new @current_token
    end

    # empty:
    private def empty : AST::Node
      # Return a NoOp node
      # Still unsure if we need this at all
      AST::NoOp.new
    end

    # expr: term ((PLUS | AWAY_FROM) term)*
    private def expr : AST::Node
      token_types = [
        TokenType::PLUS,
        TokenType::AWAY_FROM,
      ]
      # Get the first term for our expr (which is not optional according to our grammar rules)
      node : AST::Node = term
      while token_types.includes? @current_token.token_type
        token = @current_token
        # Depending on which symbol our current token is currently on, do some maths
        if @current_token.token_type == TokenType::PLUS
          eat TokenType::PLUS
        elsif @current_token.token_type == TokenType::AWAY_FROM
          eat TokenType::AWAY_FROM
        end
        node = AST::BinOp.new left: node, token: token, right: term
      end
      node
    end

    # term: factor ((TIMES | INTO) factor)*
    private def term : AST::Node
      token_types = [
        TokenType::TIMES,
        TokenType::INTO,
      ]
      # Get the first factor for our term (which is not optional according to our grammar rules)
      node : AST::Node = factor
      while token_types.includes? @current_token.token_type
        token = @current_token
        # Depending on which symbol our current token is currently on, do some maths
        if @current_token.token_type == TokenType::TIMES
          eat TokenType::TIMES
        elsif @current_token.token_type == TokenType::INTO
          eat TokenType::INTO
        end
        node = AST::BinOp.new left: node, token: token, right: factor
      end
      node
    end

    # factor: UNARY_PLUS factor | MINUS factor | INTEGER | OPEN_PAREN expr CLOSE_PAREN | variable
    private def factor : AST::Node
      token = @current_token
      if token.token_type == TokenType::UNARY_PLUS
        eat TokenType::UNARY_PLUS
        AST::UnaryOp.new token: token, expr: factor
      elsif token.token_type == TokenType::MINUS
        eat TokenType::MINUS
        AST::UnaryOp.new token: token, expr: factor
      elsif token.token_type == TokenType::INTEGER
        eat TokenType::INTEGER
        AST::Num.new token
      elsif token.token_type == TokenType::OPEN_PAREN
        eat TokenType::OPEN_PAREN
        node = expr
        eat TokenType::CLOSE_PAREN
        node
      else
        # Assume it's a variable and parse as such
        variable
      end
    end
  end
end
