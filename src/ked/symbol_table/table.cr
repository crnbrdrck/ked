require "../symbol/*"

module Ked
  module SymbolTable
    # ADT for managing symbols in a program
    class Table
      @table : Hash(String, Symbol::Base)

      def initialize
        @table = {} of String => Symbol::Base
        self.initialize_builtins
      end

      # Function that automatically populates the symbol table with any necessary builtin symbols
      def initialize_builtins
        # Create symbols for our `number` data type
        self.define Symbol::BuiltinType.new "NUMBER"
      end

      def to_s
        # Build up an array of the Symbols stored in the table
        symbol_strings = [] of String
        @table.each_value do |v|
          symbol_strings << v.to_s
        end
        "Symbols: #{symbol_strings}"
      end

      # Helper method that handles the definition of a symbol
      def define(symbol : Symbol::Base)
        # Print out the name for debug purposes
        @table[symbol.name] = symbol
      end

      # Helper method that performs a lookup for a symbol given a name and returns the symbol or nil if none can be found
      def lookup(name : String) : Symbol::Base?
        # Print out name for debug purposes
        # Try and get the corresponding symbol for the name and return it, or nil if none exists
        @table.fetch name, nil
      end
    end
  end
end
