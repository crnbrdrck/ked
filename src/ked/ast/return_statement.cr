require "./statement"
require "./expression"

module Ked
  module AST
    # Class for handling `hereYaGoBai` statements that are used to return values from functions
    class ReturnStatement < Statement
      # The `Ked::Token` instance used to generate this statement node
      @token : Token
      # The expression to be returned
      @value : Expression

      def initialize(@token : Token, @value : Expression)
      end

      # Generate the literal for this node by returning the literal of its token
      def token_literal : String
        @token.literal
      end

      # The `Ked::Token` instance used to generate this statement node
      getter token
      # The expression to be returned
      getter value
    end
  end
end
