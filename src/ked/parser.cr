require "./ast/*"

module Ked
  # The Parser generates an Abstract Syntax Tree (AST) by reading in the `Ked::Token` instances generated by an instance of `Ked::Lexer`.
  #
  # This AST will be generated based on the grammatical rules for the Ked syntax.
  class Parser
    @lexer : Lexer
    @current_token : Token
    @peek_token : Token
    @errors : Array(String)

    # Maintain an array of errors that are generated during the parsing
    getter errors

    def initialize(@lexer : Lexer)
      # Read the first two tokens from the lexer to set up both current and peek tokens
      @current_token = @lexer.get_next_token
      @peek_token = @lexer.get_next_token
      @errors = [] of String
    end

    # Read the next token from the Lexer and update both the current and peek tokens accordingly.
    def get_next_token
      @current_token = @peek_token
      @peek_token = @lexer.get_next_token
    end

    # Create a `Ked::AST::Program` node and generate its list of `Ked::AST::Statement` nodes by reading through the generated output from the lexer.
    def parse_program : AST::Program
      statement_list = [] of AST::Statement
      while !@current_token.token_type.eof?
        statement_node = self.parse_statement
        if !statement_node.nil?
          statement_list << statement_node
        end
        self.get_next_token
      end
      AST::Program.new statement_list
    end

    # Parse a `statement` and create the corresponding node for it.
    #
    # Returns `nil` if the attempted `statement` turns out to be invalid.
    def parse_statement : AST::Statement?
      case @current_token.token_type
      when TokenType::REMEMBER
        # Parse and create a remember statement
        self.parse_remember_statement
      when TokenType::RETURN
        # Parse and create a return (hereYaGoBai) statement
        self.parse_return_statement
      else
        # Return nil since we haven't found a statement
        nil
      end
    end

    # Parse a `remember statement` and create an `Ked::AST::RememberStatement` node for it.
    #
    # Returns `nil` if the attempted `remember statement` turns out to be invalid.
    # This will also cause an error to be added to the `errors` array
    def parse_remember_statement : AST::RememberStatement?
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
      while !@current_token.token_type.like?
        self.get_next_token
      end
      # Create the statement node
      AST::RememberStatement.new remember_token, ident, AST::Expression.new
    end

    # Parse a `return statement` and create an `Ked::AST::ReturnStatement` node for it.
    #
    # Returns `nil` if the attempted `return statement` turns out to be invalid.
    # This will also cause an error to be added to the `errors` array
    def parse_return_statement : AST::ReturnStatement?
      # Save the current token
      return_token = @current_token
      # The first thing we should expect after the return statement is simply an expression
      # We're currently skipping expressions
      while !@current_token.token_type.like?
        self.get_next_token
      end
      # Create the statement node and return it
      AST::ReturnStatement.new return_token, AST::Expression.new
    end

    # Check that the peek token is the same as type as the type passed in, and advance the current and peek token pointers if so.
    def eat(token_type : TokenType) : Bool
      if @peek_token.token_type == token_type
        self.get_next_token
        true
      else
        @errors << "ParserError in #{@peek_token.file_name} at line #{@peek_token.line_num} char #{@peek_token.char_num}: Expected #{token_type.to_s}, received #{@peek_token.token_type.to_s}"
        false
      end
    end
  end
end
