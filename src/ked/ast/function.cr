module Ked
  module AST
    # Class for handling function definitions
    class Function < Node
      def initialize(@func_name : String, @params : Array(AST::Param), @statement_list : Array(Ked::STATEMENT))
      end

      getter func_name
      getter params
      getter statement_list
    end
  end
end
