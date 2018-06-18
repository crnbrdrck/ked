module Ked
  module AST
    # Class to encapsulate a whole program
    class Program < Node
      def initialize(@statements : Array(Ked::STATEMENT))
      end

      # Getters
      getter statements
    end
  end
end
