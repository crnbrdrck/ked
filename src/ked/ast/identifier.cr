module Ked
  module AST
    # Class for handling Identifier nodes
    # These can be variable names, function names, class names, etc
    class Identifier < Expression
      @token : Token
      @value : String

      def initialize(@token : Token, @value : String)
      end

      # Redefine the token_literal function to return this node's token's literak
      def token_literal : String
        @token.literal
      end
    end
  end
end
