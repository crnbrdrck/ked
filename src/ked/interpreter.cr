require "./symbol_table/*"

module Ked
  class Interpreter
    @parser : Parser
    # Global scope. Stores the values of all the variables in the program. Whether or not the variables are correctly defined is now handled by our new SymbolTable::Builder class
    @global_scope : Hash(TokenValue, TokenValue)
    @symtab_builder : SymbolTable::Builder

    def initialize(text : String)
      @parser = Parser.new text
      @global_scope = {} of TokenValue => TokenValue
      @symtab_builder = Ked::SymbolTable::Builder.new
    end

    def interpret
      tree = @parser.parse
      # Build up the symbol table to ensure that everything is properly defined as it should be
      @symtab_builder.build tree
      # We are now testing by checking the global_scope
      visit tree
    end

    # Node visitor methods with that sweet sweet overloading
    # Assign nodes
    private def visit(node : AST::Assign) : TokenValue
      # Get the name of the variable and store its value in the global_scope
      var_name = node.left.value
      @global_scope[var_name] = visit(node.right)
    end

    # BinOp nodes
    private def visit(node : AST::BinOp) : Int32 | Float64
      # Get the left and right values by visiting them
      left_val = visit(node.left).to_s
      right_val = visit(node.right).to_s
      # Try and cast them to the proper types
      if left_val.to_f?
        left_val = left_val.to_f
      elsif left_val.to_i?
        left_val = left_val.to_i
      else
        raise "BinOp Error: Expected numeric value, Received #{left_val}"
      end
      if right_val.to_f?
        right_val = right_val.to_f
      elsif right_val.to_i?
        right_val = right_val.to_i
      else
        raise "BinOp Error: Expected numeric value, Received #{right_val}"
      end
      # Now do the maths
      case node.op.token_type
      when TokenType::PLUS
        return left_val + right_val
      when TokenType::AWAY_FROM
        return right_val - left_val
      when TokenType::TIMES
        return left_val * right_val
      when TokenType::INTO
        # To do float division, one param has to be a float already
        return right_val.to_f / left_val
      when TokenType::EASY_INTO
        return right_val / left_val
      end
      raise "BinOp Error: Expected 'plus', 'awayFrom', 'times', 'into', 'easyInto', Received #{node.op.value}"
    end

    # Definition Nodes
    private def visit(node : AST::Definition)
      # TODO - Next part of tutorial
    end

    # NoOp nodes
    private def visit(node : AST::NoOp)
      0
    end

    # Num nodes
    private def visit(node : AST::Num) : Int32 | Float64
      val = node.value.to_s
      if val.to_f?
        # It's a float
        return val.to_f
      elsif val.to_i?
        # It's an integer
        return val.to_i
      else
        raise "AST::Num: Invalid value. Expected numeric type, got #{val} (#{typeof(val)})"
      end
    end

    # Program nodes
    private def visit(node : AST::Program) : Int
      # For this, just visit each of the statements that the program has
      node.statements.each do |stmnt|
        visit stmnt
      end
      0
    end

    # UnaryOp Nodes
    private def visit(node : AST::UnaryOp) : Int
      op = 1
      if node.op.token_type == TokenType::MINUS
        op = -1
      end
      visit(node.expr).to_i * op
    end

    # Var nodes
    private def visit(node : AST::Var) : TokenValue
      # Because of the symbol table builder, we can just assume the variable is defined properly
      @global_scope[node.value]
    end

    # Generic visit, throw exception as we should never get here
    private def visit(node : AST::Node)
      raise "No visit method defined for #{node.class.name}"
    end

    getter global_scope
  end
end
