module Ked
  class Num < AST
    @value : TokenValue

    def initialize(@token : Token)
      @value = @token.value
    end

    def to_s
      "Num(#{@value})"
    end
  end
end
