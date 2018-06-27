module Ked
  module AST
    # Class for handling programs
    # Programs are the root node of our AST
    # In Ked, a Program simply contains an array of statements
    class Program < Node
      @statements : Array(Statement)

      def initialize(@statements : Array(Statement))
      end

      # In the Program class. token_literal is a method
      # And thankfully, Crystal accepts this as long as it returns a string
      def token_literal : String
        if @statements.size > 0
          @statements[0].token_literal
        else
          ""
        end
      end
    end
  end
end
