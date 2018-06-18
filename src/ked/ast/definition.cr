module Ked
  module AST
    # Class for handling function definitions
    class Definition < Node
      def initialize(@proc_name : String, @statement_list : Array(AST::Node))
      end
    end
  end
end