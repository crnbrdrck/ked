module Ked
  module AST
    # Class to encapsulate a whole program
    class Program < Node
      def initialize(@statements : Array(Node))
      end

      # Getters
      getter statements
    end
  end
end
