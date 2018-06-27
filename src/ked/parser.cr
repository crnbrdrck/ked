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
        if not statement_node.nil?
          statement_list << statement_node
        end
        self.get_next_token
      end
      AST::Program.new statement_list
    end
  end
end
