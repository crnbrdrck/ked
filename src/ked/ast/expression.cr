require "./node"

module Ked
  module AST
    # Class for handling `expression` nodes.
    #
    # An expression is anything that returns a value.
    #
    # See the list of subclasses to see what `expressions` are currently available in Ked.
    class Expression < Node
      @token_literal = "Expression"
    end

    # Returns a string representation of this node
    def to_s
      ""
    end
  end
end
