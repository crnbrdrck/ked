module Ked
  # The AST module contains classes that define the different types of nodes that will be used as part of the Abstract Syntax Tree (AST) for the Ked language.
  module AST
    # Base AST Node Class that all other Nodes inherit from.
    class Node
      # The token literal is just a string that tells us the class of this node.
      #
      # It is used for debugging purposes
      @token_literal : String = "Node"

      # The token literal is just a string that tells us the class of this node.
      #
      # It is used for debugging purposes
      getter token_literal
    end
  end
end
