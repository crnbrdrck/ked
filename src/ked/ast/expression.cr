require "./node"

module Ked
  module AST
    # Class for handling `expression` nodes
    # An expression is anything that returns a value
    class Expression < Node
      @token_literal = "Expression"
    end
  end
end
