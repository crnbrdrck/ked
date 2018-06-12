module Ked
  module AST
    class UnaryOp < Node
      def initialize(@token : Token, @expr : Node)
        @op = @token
      end

      def to_s
        "#{@token.value}(#{@expr.to_s})"
      end

      # Getters
      getter op
      getter expr
    end
  end
end
