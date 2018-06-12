# TODO: Documentation
module Ked
  # An Abstract Syntax Tree that will be the new foundation of our language.
  # We're getting closer to actually beginning the proper implementation of Ked.
  module AST
    class Node
      def to_s
        ""
      end

      def visit : Int
        raise "No visit method defined for #{self.class.name}"
      end
    end
  end
end
