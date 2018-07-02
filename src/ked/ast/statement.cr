require "./node"

module Ked
  module AST
    # Class for handling `statement` nodes.
    #
    # A statement is anything that does not return a value.
    #
    # See the list of subclasses to see what `statements` are currently available in Ked.
    class Statement < Node
      @token_literal = "Statement"
    end

    # Returns a string representation of this node
    def to_s
      ""
    end
  end
end
