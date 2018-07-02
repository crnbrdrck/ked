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

      # Returns a string representation of this node
      def to_s
        builder = String::Builder.new ""
        # Add the token literal to the string
        builder << self.token_literal
        builder << " "
        # Add the string representation of the return value
        builder << @value.to_s
        # Add the "like"
        builder << "like"
        # Return the built string
        builder.to_s
      end

      # The `Ked::Token` instance used to generate this statement node
      getter token
      # The expression to be returned
      getter value
    end
  end
end
