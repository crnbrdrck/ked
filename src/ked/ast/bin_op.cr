module Ked
  # Class to represent binary operators (i.e +, -, *, /, or operators that act only on two operands)
  class BinOp < AST
    def initialize(@left : AST, @token : Token, @right : AST)
      @op = @token
    end

    def to_s
      "(#{@left.to_s} #{@token.value} #{@right.to_s})"
    end
  end
end
