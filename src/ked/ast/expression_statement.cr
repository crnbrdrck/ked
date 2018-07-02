require "./expression"
require "./statement"

module Ked
  module AST
    # Class for handling ExpressionStatement nodes.
    #
    # An "ExpressionStatement" is a statement that consists of a single expression and nothing else i.e. `€x plus 10 like`.
    #
    # This is used solely so we can add expressions that are on their own to our `statements` list of our program node.
    class ExpressionStatement < Statement
      # The `Ked::Token` instance used to create this node
      @token : Token
      # The expression contained within this statement node
      @value : Expression

      def initialize(@token : Token, @value : Expression)
      end

      # Generate the token_literal for this node by returning the literal of the token used to create it
      def token_literal : String
        @token.literal
      end

      # Returns a string representation of this node
      def to_s
        # For this, simply return the string value of the expression
        @value.to_s
      end

      # The `Ked::Token` instance used to create this node
      getter token
      # The expression contained within this statement node
      getter value
    end
  end
end
