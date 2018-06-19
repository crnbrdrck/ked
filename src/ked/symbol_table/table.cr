require "../symbol/*"

module Ked
  module SymbolTable
    # ADT for managing symbols in a program
    class ScopedTable
      @_symbols : Hash(String, Symbol::Base)
      @parent_scope : ScopedTable?

      def initialize(@scope_name : String, @scope_level : Int32, @parent_scope : ScopedTable?)
        @_symbols = {} of String => Symbol::Base
        self.initialize_builtins
      end

      getter scope_name
      getter scope_level

      # Function that automatically populates the symbol table with any necessary builtin symbols
      def initialize_builtins
        # Only do anything here if we're at scope level 0
        if @scope_level != 0
          return
        end
        # Create symbols for our `number` data type
        self.insert Symbol::BuiltinType.new "NUMBER"
      end

      # Generate an explanatory string that presents the table as verbose as possible
      def to_s
        header = "SCOPE (SCOPED SYMBOL TABLE)"
        sub_header = "Scope (Scoped symbol table) contents"
        enclosing_scope_name = "None"
        if !@parent_scope.nil?
          enclosing_scope_name = @parent_scope.not_nil!.scope_name
        end
        lines = [
          "\n",
          header,
          "=" * header.size,
          "Scope Name      : #{@scope_name}",
          "Scope level     : #{@scope_level}",
          "Enclosing Scope : #{enclosing_scope_name}",
          sub_header,
          "-" * sub_header.size,
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
        # Try and get the corresponding symbol for the name and return it, checking parent_scope if needed, or nil if none exists in any scope in the tree of this scope
        current_scope_result = @_symbols.fetch name, nil
        # If it's not in this scope, check the parent (if one exists)
        if current_scope_result.nil? && !@parent_scope.nil?
          return @parent_scope.not_nil!.lookup name
        end
        return current_scope_result
      end
    end
  end
end
