module Ked
  class Interpreter
    @parser : Parser

    def initialize(text : String)
      @parser = Parser.new text
    end

    def interpret
      tree = @parser.parse
      tree.visit
    end
  end
end
