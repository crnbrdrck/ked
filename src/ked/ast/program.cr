require "./node"

module Ked
  module AST
    # Class for handling `program` nodes.
    #
    # A `program` node is the root node of our AST.
    #
    # In Ked, a `program` simply contains an array of `Ked::AST::Statement` nodes.
    class Program < Node
      # The array of statements in this `program`.
      @statements : Array(Statement)

      def initialize(@statements : Array(Statement))
      end

      # Generates the token_literal for the `program` node by returning the token_literal for the first statement in the program.
      def token_literal : String
        if @statements.size > 0
          @statements[0].token_literal
        else
          ""
        end
      end

      # The array of statements in this `program`.
      getter statements
    end
  end
end
