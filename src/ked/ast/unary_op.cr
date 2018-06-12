module Ked
  module AST
    class UnaryOp < Node
      def initialize(@token : Token, @expr : Node)
        @op = @token
      end

      def to_s
        "#{@token.value}(#{@expr.to_s})"
      end

      def visit : Int
        op = 1
        if @op.token_type == TokenType::MINUS
          op = -1
        end
        @expr.visit * op
      end
    end
  end
end
