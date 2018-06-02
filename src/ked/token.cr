# TODO: Documentation
module Ked
  enum TokenType
    INTEGER
    PLUS
    EOF
  end

  alias TokenValue = Char | Int32 | Nil

  class Token
    getter token_type : TokenType
    getter value : TokenValue

    def initialize(@token_type : TokenType, @value : TokenValue)
    end

    def to_s
      "Token(#{self.token_type}, #{self.value})"
    end
  end
end
