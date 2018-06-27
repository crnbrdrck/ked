module Ked
  module AST
    # Base AST Node Class
    class Node
      # The token literal is just a string that tells us the class of this node
      # It is used for debugging purposes
      @token_literal : String = "Node"

      getter token_literal
    end
  end
end
