require "./expression"

module Ked
  module AST
    # Class for handling `identifier` nodes.
    #
    # These can be variable names, function names, class names, etc.
    class Identifier < Expression
      # The `Ked::Token` instance used to create this node.
      @token : Token
      # The name of the identifier ("x", "add", etc).
      @value : String

      def initialize(@token : Token, @value : String)
      end

      # Return this node's token's literal as the node's literal.
      def token_literal : String
        @token.literal
      end

      # The `Ked::Token` instance used to create this node.
      getter token
      # The name of the identifier ("x", "add", etc).
      getter value
    end
  end
end
