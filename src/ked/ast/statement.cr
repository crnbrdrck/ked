require "./node"

module Ked
  module AST
    # Class for `statement` nodes
    # Statements are anything that do not produce a value
    class Statement < Node
      @token_literal = "Statement"
    end
  end
end
