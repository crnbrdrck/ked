module Ked
  module Symbol
    # Define the base symbol class
    class Base
      @symbol_type : Base? = nil

      def initialize(@name : String)
      end

      def initialize(@name : String, @symbol_type : String)
      end

      def to_s
        "#{@name}"
      end

      getter name
      getter symbol_type
    end
  end
end
