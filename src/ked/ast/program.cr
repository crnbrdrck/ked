module Ked
  module AST
    # Class to encapsulate a whole program
    class Program < Node
      def initialize(@statements : Array(Node))
      end
    end
  end
end
