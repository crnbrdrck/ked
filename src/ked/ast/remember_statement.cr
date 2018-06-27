module Ked
  module AST
    # Class for handling remember statements for assigning variables
    class RememberStatement < Statement
      @token : Token      # the TokenType::REMEMBER instance
      @name : Identifier  # The identifier node representing the variable being assigned
      @value : Expression # The RHS of the assignment, gathering the value to assign to the variable

      def initialize(@token : Token, @name : Identifier, @value : Expression)
      end

      # Define a token_literal function to return the name of the token's literal instead
      def token_literal : String
        @token.literal
      end
    end
  end
end
