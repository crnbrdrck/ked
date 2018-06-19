module Ked
  module AST
    # AST node for printing out stuff using `saysI` command
    class Print
      def initialize(@expr : Node)
      end

      getter expr
    end
  end
end
