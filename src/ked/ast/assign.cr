module Ked
  # Class to represent assignment statements
  class Assign < AST
    def initialize(@left : Var, @token : Token, @right : AST)
      @op = @token
    end
  end
end
