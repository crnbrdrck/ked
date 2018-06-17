require "./ast/*"

# TODO: Documentation
module Ked
  # Grammar rules
  # program:              statement_list
  # statement_list:       statement LIKE statement_list | statement LIKE EOF
  # statement:            assignment_statement | empty
  # assignment_statement: REMEMBER variable ASSIGN expr
  # variable:             VAR_PREFIX ID
  # expr:                 term ((PLUS | AWAY_FROM) term)*
  # term:                 factor ((TIMES | INTO | EASY_INTO) factor)*
  # factor:               UNARY_PLUS factor | MINUS factor | NUMBER | OPEN_PAREN expr CLOSE_PAREN | variable
  # empty:
  class Parser
    @lexer : Lexer
    @current_token : Token

    def initialize(text : String)
      @lexer = Lexer.new text
      @current_token = @lexer.get_next_token
    end

    def parse : AST::Node
      # Parse the program
      node = program
      # Ensure that we have reached the end of the file after parsing the program, and if not raise an error
      if @current_token.token_type != TokenType::EOF
        error
      end
      # Return the root node if the parsing was successful
      node
    end

    private def error
      raise "Error when parsing input. Current token: #{@current_token.to_s}"
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
      # Create a program node of the program's statement list
      AST::Program.new statement_list
    end

    # statement_list: statement LIKE | statement LIKE statement_list
    private def statement_list : Array(AST::Assign | AST::NoOp)
      # There's guaranteed to be at least one statement and a LIKE terminator
      node = statement
      nodes = [node]
      # Ensure the opening statement has been terminated
      eat TokenType::LIKE
      # Until we reach an EOF, keep parsing statements
      while @current_token.token_type != TokenType::EOF
        nodes << statement
        eat TokenType::LIKE
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
      node = AST::Assign.new left: left, token: token, right: right
    end

    # variable: VAR_PREFIX ID
    private def variable : AST::Node
      # Ensure that variables are prefixed with the € symbol
      eat TokenType::VAR_PREFIX
      # Create and return a Var node
      token = @current_token
      # Ensure that we now have an ID token
      eat TokenType::ID
      AST::Var.new token
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
        case token.token_type
        when TokenType::PLUS
          eat TokenType::PLUS
        when TokenType::AWAY_FROM
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
        TokenType::EASY_INTO,
      ]
      # Get the first factor for our term (which is not optional according to our grammar rules)
      node : AST::Node = factor
      while token_types.includes? @current_token.token_type
        token = @current_token
        case token.token_type
        when TokenType::TIMES
          eat TokenType::TIMES
        when TokenType::INTO
          eat TokenType::INTO
        when TokenType::EASY_INTO
          eat TokenType::EASY_INTO
        end
        node = AST::BinOp.new left: node, token: token, right: factor
      end
      node
    end

    # factor: UNARY_PLUS factor | MINUS factor | NUMBER | OPEN_PAREN expr CLOSE_PAREN | variable
    private def factor : AST::Node
      token = @current_token
      case token.token_type
      when TokenType::UNARY_PLUS
        eat TokenType::UNARY_PLUS
        AST::UnaryOp.new token: token, expr: factor
      when TokenType::MINUS
        eat TokenType::MINUS
        AST::UnaryOp.new token: token, expr: factor
      when TokenType::NUMBER
        eat TokenType::NUMBER
        AST::Num.new token
      when TokenType::OPEN_PAREN
        eat TokenType::OPEN_PAREN
        node = expr
        eat TokenType::CLOSE_PAREN
        node
      else
        # Assume it's a variable and attempt to parse it as such
        variable
      end
    end
  end
end
