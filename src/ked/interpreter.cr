module Ked
  class Interpreter
    @parser : Parser
    # Global variable scope. Is actually meant to be an ADT of its own but we're gonna run a Hash as a hack for a little while
    # It is meant to be an ADT for tracking symbols but since our only symbol currently is variables a Hash should suffice
    @GLOBAL_SCOPE = {} of TokenValue => TokenValue

    def initialize(text : String)
      @parser = Parser.new text
    end

    def interpret
      tree = @parser.parse
      # Pass global scope into the visit methods in case any node needs it
      puts visit tree
    end

    # Node visitor methods with that sweet sweet overloading
    # Assign nodes
    private def visit(node : AST::Assign) : TokenValue
      # Get the name of the variable and store its value in the GLOBAL_SCOPE
      var_name = node.left.value
      @GLOBAL_SCOPE[var_name] = visit(node.right)
    end

    # BinOp nodes
    private def visit(node : AST::BinOp) : Int
      case node.op.token_type
      when TokenType::PLUS
        return visit(node.left).to_i + visit(node.right).to_i
      when TokenType::AWAY_FROM
        return visit(node.right).to_i - visit(node.left).to_i
      when TokenType::TIMES
        return visit(node.left).to_i * visit(node.right).to_i
      when TokenType::INTO
        return visit(node.right).to_i / visit(node.left).to_i
      end
      raise "BinOp Error: Expected 'plus', 'awayFrom', 'times', 'into', Received #{node.op.value}"
    end

    # NoOp nodes
    private def visit(node : AST::NoOp)
      0
    end

    # Num nodes
    private def visit(node : AST::Num) : Int
      node.value.to_i
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
      # The variable needs to be in the global scope first in order for this to work
      var_name = node.value
      var = @GLOBAL_SCOPE.fetch(var_name, nil)
      if var.nil?
        # NameError, variable not in scope
        raise "NameError: Variable #{var_name} is undefined"
      end
      # Just return the received value
      var
    end

    # Generic visit, throw exception as we should never get here
    private def visit(node : AST::Node)
      raise "No visit method defined for #{node.class.name}"
    end
  end
end
