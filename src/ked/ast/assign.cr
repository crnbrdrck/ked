module Ked
  module AST
    # Class to represent assignment statements
    class Assign < Node
      def initialize(@left : Var, @token : Token, @right : Node)
        @op = @token
      end
    end
  end
end
