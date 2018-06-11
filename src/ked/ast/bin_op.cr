module Ked
  # Class to represent binary operators (i.e +, -, *, /, or operators that act only on two operands)
  class BinOp < AST
    def initialize(@left : AST, @token : Token, @right : AST)
      @op = @token
    end

    def to_s
      "(#{@left.to_s} #{@token.value} #{@right.to_s})"
    end

    def visit : Int
      case @op.token_type
      when TokenType::ADD
        return @left.visit + @right.visit
      when TokenType::SUBTRACT
        return @left.visit - @right.visit
      when TokenType::MULTIPLY
        return @left.visit * @right.visit
      when TokenType::DIVIDE
        return @left.visit / @right.visit
      end
      return 0
    end
  end
end
