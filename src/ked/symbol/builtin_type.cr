module Ked
  module Symbol
    # Class for symbols representing built-in types
    class BuiltinType < Base
      def initialize(name : String)
        super(name)
      end

      def to_s
        @name
      end
    end
  end
end
