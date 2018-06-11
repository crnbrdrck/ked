module Ked
  # Class to represent binary operators (i.e +, -, *, /, or operators that act only on two operands)
  class BinOp < AST
    def initialize(@left : AST, @token : Token, @right : AST)
      @op = @token
    end
  end
end
