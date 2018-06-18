module Ked
  module AST
    # Class for handling function definitions
    class Definition < Node
      def initialize(@proc_name : String, @statement_list : Array(Ked::STATEMENT))
      end

      getter proc_name
      getter statement_list
    end
  end
end
