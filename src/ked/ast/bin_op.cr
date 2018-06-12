module Ked
  module AST
    # Class to represent binary operators (i.e +, -, *, /, or operators that act only on two operands)
    class BinOp < Node
      def initialize(@left : Node, @token : Token, @right : Node)
        @op = @token
      end

      def to_s
        "(#{@left.to_s} #{@token.value} #{@right.to_s})"
      end
    end
  end
end
