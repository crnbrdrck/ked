module Ked
  module AST
    class Num < Node
      @value : TokenValue

      def initialize(@token : Token)
        @value = @token.value
      end

      def to_s
        "Num(#{@value})"
      end

      def visit : Int
        @value.to_i
      end
    end
  end
end
