require "./ast/*"

module Ked
  # Class that takes in a sequence of tokens from a lexer and converts them into an AST based on the grammar rules for ked
  class Parser
    @lexer : Lexer
    @current_token : Token
    @peek_token : Token

    def initialize(@lexer : Lexer)
      # Read the first two tokens from the lexer to set up both current and peek tokens
      @current_token = @lexer.get_next_token
      @peek_token = @lexer.get_next_token
    end

    # Read the next token from the lexer and update both the current and peek tokens accordingly
    def get_next_token
      @current_token = @peek_token
      @peek_token = @lexer.get_next_token
    end

    # Create a Program node and parse the text accordingly
    def parse_program : AST::Program
      statement_list = [] of AST::Statement
      while @current_token.token_type != TokenType::EOF
        statement_node = self.parse_statement
        if !statement_node.nil?
          statement_list << statement_node
        end
        self.get_next_token
      end
      AST::Program.new statement_list
    end

    # Parse a statement and create the corresponding node for it
    def parse_statement : AST::Statement | Nil
      case @current_token.token_type
      when TokenType::REMEMBER
        # Parse and create a remember statement
        self.parse_remember_statement
      else
        # Return nil since we haven't found a statement
        nil
      end
    end

    # Parse a remember statement and create an AST::RememberStatement node to go along with it, or nil if its an invalid remember statement
    def parse_remember_statement : AST::RememberStatement | Nil
      # Save the current token
      remember_token = @current_token
      # So by the syntax for ked, if current_token is remember then the next token should be a var_prefix token
      if !self.eat TokenType::VAR_PREFIX
        return nil
      end
      # Try to get the IDENT token
      if !self.eat TokenType::IDENT
        return nil
      end
      # At this point, the ident token is the current token. With this we can create an Identifier node
      ident = AST::Identifier.new @current_token, @current_token.literal
      # Check for an assignment token
      if !self.eat TokenType::ASSIGN
        return nil
      end
      # Skip over the expression part for the time being
      # TODO - Handle expressions properly
      while @current_token.token_type != TokenType::LIKE
        self.get_next_token
      end
      # Create the statement node
      AST::RememberStatement.new remember_token, ident, AST::Expression.new
    end

    # Check that the peek token is the same as type as the type passed in.
    # If so, advance tokens as a side effect
    def eat(token_type : TokenType) : Bool
      if @peek_token.token_type == token_type
        self.get_next_token
        true
      else
        false
      end
    end
  end
end
