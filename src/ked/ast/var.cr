module Ked
  module AST
    # Class to represent variables
    # The Var node is created from ID tokens
    class Var < Node
      @value : TokenValue

      def initialize(@token : Token)
        @value = @token.value
      end
    end
  end
end
