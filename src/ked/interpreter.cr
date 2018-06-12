module Ked
  class Interpreter
    @parser : Parser
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
    private def visit(node : AST::Assign) : Int
      0
    end

    # BinOp nodes
    private def visit(node : AST::BinOp) : Int
      case node.token_type
      when TokenType::PLUS
        return visit(node.left) + visit(node.right)
      when TokenType::AWAY_FROM
        return visit(node.right) - visit(node.left)
      when TokenType::TIMES
        return visit(node.left) * visit(node.right)
      when TokenType::INTO
        return visit(node.right) / visit(node.left)
      end
      error
    end

    # NoOp nodes
    private def visit(node : AST::NoOp) : Int
      0
    end

    # Num nodes
    private def visit(node : AST::Num) : Int
      node.value.to_i
    end

    # Program nodes
    private def visit(node : AST::Program) : Int
      0
    end

    # UnaryOp Nodes
    private def visit(node : AST::UnaryOp) : Int
      op = 1
      if node.op.token_type == TokenType::MINUS
        op = -1
      end
      visit(node.expr) * op
    end

    # Var nodes
    private def visit(node : AST::Var) : Int
      0
    end

    # Generic visit, throw exception as we should never get here
    private def visit(node : AST::Node)
      raise "No visit method defined for #{node.class.name}"
    end
  end
end
