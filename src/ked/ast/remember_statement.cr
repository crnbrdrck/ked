require "./statement"
require "./expression"

module Ked
  module AST
    # Class for handling `remember` statements used for assigning variables
    class RememberStatement < Statement
      # The `Ked::Token` instance used to generate this statement node.
      @token : Token
      # A `Ked::AST::Identifier` node that represents the name of the variable being assigned to.
      @name : Identifier
      # The right hand side of the assignment statement, returns the value to be assigned to the variable.
      @value : Expression

      def initialize(@token : Token, @name : Identifier, @value : Expression)
      end

      # Generates the token_literal for this node by returning the literal for the token used to create it.
      def token_literal : String
        @token.literal
      end

      # Returns a string representation of this node
      def to_s
        builder = String::Builder.new ""
        # Add the details of the statement to the string builder
        builder << self.token_literal
        builder << " €"
        builder << @name.to_s
        builder << " = "
        # Add the string value of the expression to the builder
        builder << @value.to_s
        # Add the "like" to the string
        builder << "like"
        # Return the built string
        builder.to_s
      end

      # A `Ked::AST::Identifier` node that represents the name of the variable being assigned to.
      getter name
      # The right hand side of the assignment statement, returns the value to be assigned to the variable.
      getter value
    end
  end
end
