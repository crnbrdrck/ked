module Ked
  class Num < AST
    @value : TokenValue

    def initialize(@token : Token)
      @value = @token.value
    end
  end
end
