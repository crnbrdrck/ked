module Ked
  module SymbolTable
    # Class for automating the creation of a SymbolTable instance
    @current_scope : ScopedTable

    class Builder
      @current_scope = ScopedTable.new "global", 1

      def build(node : AST::Node)
        # Attempts to build a symbol table from the given root node
        visit node
      end

      # Define `visit` functions similar to the interpreter class for all available ADT node types
      # Assign nodes
      private def visit(node : AST::Assign)
        # Add the left hand side (variable) to the symbol table
        name = node.left.value
        @current_scope.insert Symbol::Var.new name.to_s
        # Now go visit the right hand side of the assignment statement
        visit node.right
      end

      # BinOp nodes
      private def visit(node : AST::BinOp)
        # Just visit the left and right nodes
        visit node.left
        visit node.right
      end

      # Function nodes
      private def visit(node : AST::Function)
        # Add the definition to the current scope, store it and create a new scope whose name is the name of the function and whose level is 1 more than the current
        # Create a Definition Symbol from the current node and add it to the current scope

      end

      # NoOp nodes
      private def visit(node : AST::NoOp)
        # Do nothing
      end

      # Num nodes
      private def visit(node : AST::Num)
        # Do nothing
      end

      # Program nodes
      private def visit(node : AST::Program)
        # For this, just visit each of the statements that the program has
        node.statements.each do |stmnt|
          visit stmnt
        end
      end

      # UnaryOp Nodes
      private def visit(node : AST::UnaryOp)
        # Just visit the node for this node's `expr`
        visit node.expr
      end

      # Var nodes
      private def visit(node : AST::Var)
        # Ensure that the var node exists (has been assigned already)
        name = node.value.to_s
        if @current_scope.lookup(name).nil?
          raise "NameError: '#{name}' has not been defined"
        end
      end

      # Generic visit, throw exception as we should never get here
      private def visit(node : AST::Node)
        raise "No visit method defined for #{node.class.name}"
      end
    end
  end
end
