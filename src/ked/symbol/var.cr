module Ked
  module Symbol
    # Class for symbols that represent variables
    class Var < Base
      def initialize(name : String)
        super(name)
      end

      def to_s
        "<Variable: #{@name}>"
      end
    end
  end
end
