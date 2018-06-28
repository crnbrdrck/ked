require "./statement"

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

      # A `Ked::AST::Identifier` node that represents the name of the variable being assigned to.
      getter name
      # The right hand side of the assignment statement, returns the value to be assigned to the variable.
      getter value
    end
  end
end
