module Ked
  module Symbol
    # Class for symbols that represent functions
    class Function < Base
      def initialize(name : String, @params : Array(Symbol::Var))
        super(name)
      end

      def initialize(name : String, symbol_type : String, @params : Array(Symbol::Var))
        super(name, symbol_type)
      end

      def to_s
        params = [] of String
        @params.each do |p|
          params << p.to_s
        end
        if @symbol_type.nil?
          "<Function: #{@name}(#{params})>"
        else
          "<Function: #{@name}(#{params}) -> #{@symbol_type}"
        end
      end
    end
  end
end
