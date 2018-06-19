require "../symbol/*"

module Ked
  module SymbolTable
    # ADT for managing symbols in a program
    class ScopedTable
      @_symbols : Hash(String, Symbol::Base)

      def initialize(@scope_name : String, @scope_level : Int32)
        @_symbols = {} of String => Symbol::Base
        self.initialize_builtins
      end

      # Function that automatically populates the symbol table with any necessary builtin symbols
      def initialize_builtins
        # Create symbols for our `number` data type
        self.insert Symbol::BuiltinType.new "NUMBER"
      end

      # Generate an explanatory string that presents the table as verbose as possible
      def to_s
        header = "SCOPE (SCOPED SYMBOL TABLE)"
        sub_header = "Scope (Scoped symbol table) contents"
        lines = [
          "\n",
          header,
          "=" * header.size,
          "Scope Name     : #{@scope_name}",
          "Scope level    : #{@scope_level}",
          sub_header,
          '-' * sub_header.size,
        ]
        # Get the scope contents
        @_symbols.each do |k, v|
          lines << "#{k.rjust 7}: #{v.to_s}"
        end
        lines << "\n"
        # Return the message joined with newlines
        lines.join "\n"
      end

      # Helper method that handles the insertion of a symbol
      def insert(symbol : Symbol::Base)
        # Print out the name for debug purposes
        @_symbols[symbol.name] = symbol
      end

      # Helper method that performs a lookup for a symbol given a name and returns the symbol or nil if none can be found
      def lookup(name : String) : Symbol::Base?
        # Print out name for debug purposes
        # Try and get the corresponding symbol for the name and return it, or nil if none exists
        @_symbols.fetch name, nil
      end
    end
  end
end
