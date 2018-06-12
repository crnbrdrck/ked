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
    end
  end
end
