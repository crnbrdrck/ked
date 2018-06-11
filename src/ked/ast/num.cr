module Ked
  class Num < AST
    @value : TokenValue

    def initialize(@token : Token)
      @value = @token.value
    end

    def to_s
      "Num(#{@value})"
    end

    def visit : Int
      @value.to_i
    end
  end
end
