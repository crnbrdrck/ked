require "./ast/*"

# TODO: Documentation
module Ked
  # Grammar rules
  # program:              statement_list
  # statement_list:       statement LIKE statement_list | statement LIKE CLOSE_PAREN | statement LIKE EOF
  # statement:            assignment_statement | definition_statement | empty
  # assignment_statement: REMEMBER variable ASSIGN expr
  # definition_statement: BAI ID OPEN_PAREN CLOSE_PAREN OPEN_BRACE statement_list CLOSE_PAREN
  # variable:             VAR_PREFIX ID
  # expr:                 term ((PLUS | AWAY_FROM) term)*
  # term:                 factor ((TIMES | INTO | EASY_INTO) factor)*
  # factor:               UNARY_PLUS factor | MINUS factor | NUMBER | OPEN_PAREN expr CLOSE_PAREN | variable
  # empty:

  # Keep track of TokenTypes that can end a statement list
  STATEMENT_LIST_END_TOKEN_TYPES = [
    TokenType::EOF,
    TokenType::CLOSE_PAREN,
  ]

  # TypeAlias for statements
  alias STATEMENT = (AST::Assign | AST::Definition | AST::NoOp)

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

    # statement_list: statement LIKE statement_list | statement LIKE CLOSE_PAREN | statement LIKE EOF
    private def statement_list : Array(Ked::STATEMENT)
      # There's guaranteed to be at least one statement and a LIKE terminator
      nodes = [] of Ked::STATEMENT
      nodes << statement
      # Ensure the opening statement has been terminated
      eat TokenType::LIKE
      # Until we reach an EOF, keep parsing statements
      while STATEMENT_LIST_END_TOKEN_TYPES.includes? @current_token.token_type
        nodes << statement
        eat TokenType::LIKE
      end

      # Return the list we parsed
      nodes
    end

    # statement: assignment_statement | definition_statement | empty
    private def statement : Ked::STATEMENT
      if @current_token.token_type == TokenType::REMEMBER
        return assignment_statement
      elsif @current_token.token_type == TokenType::BAI
        return definition_statement
      else
        return empty
      end
    end

    # assignment_statement: REMEMBER variable ASSIGN expr
    private def assignment_statement : AST::Assign
      # Ensure statement begins with REMEMBER token
      eat TokenType::REMEMBER
      left = variable
      token = @current_token
      eat TokenType::ASSIGN
      right = expr
      node = AST::Assign.new left: left, token: token, right: right
    end

    # definition_statement: BAI ID OPEN_PAREN CLOSE_PAREN OPEN_BRACE statement_list CLOSE_PAREN
    private def definition_statement : AST::Definition
      # Eat the definition Token
      eat TokenType::BAI
      func_name = @current_token.value.to_s
      eat TokenType::ID
      # Get parameter list
      eat TokenType::OPEN_PAREN
      # TODO
      eat TokenType::CLOSE_PAREN
      # Start the function
      eat TokenType::OPEN_BRACE
      stmnts = statement_list
      # Ensure function closed properly
      eat TokenType::CLOSE_BRACE
      # Create a definition node and return it
      AST::Definition.new func_name, stmnts
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
    private def empty : AST::NoOp
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
