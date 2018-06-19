module Ked
  module AST
    # AST node for handling parameters to a function
    class Param
      def initialize(@var_node : AST::Var)
        # Dynamic typing might kill me but be grand bai
      end

      getter var_node
    end
  end
end
