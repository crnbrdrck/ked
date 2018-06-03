# TODO: Documentation
module Ked
  enum TokenType
    # Data Types
    INTEGER
    # Operators
    PLUS
    MINUS
    MULTIPLY
    # Other Stuff
    SOF # StartOfFile, just used to remove nils. SOF will never be used anywhere other than the default initialization of the Interpreter
    EOF
  end

  alias TokenValue = Char | Int32

  class Token
    getter token_type : TokenType
    getter value : TokenValue

    def initialize(@token_type : TokenType, @value : TokenValue)
    end

    def to_s
      "Token(#{self.token_type}, #{self.value})"
    end

    def ==(other : self)
      self.token_type == other.token_type && self.value == other.value
    end
  end
end
