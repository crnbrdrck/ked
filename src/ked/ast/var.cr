module Ked
  # Class to represent variables
  # The Var node is created from ID tokens
  class Var < AST
    def initialize(@token : Token)
      @value = @token.value
    end
  end
end
