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

      def visit : Int
        case @op.token_type
        when TokenType::PLUS
          return @left.visit + @right.visit
        when TokenType::AWAY_FROM
          return @right.visit - @left.visit
        when TokenType::TIMES
          return @left.visit * @right.visit
        when TokenType::INTO
          return @right.visit / @left.visit
        end
        return 0
      end
    end
  end
end
