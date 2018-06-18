# TODO: Documentation
module Ked
  enum TokenType
    # Data Types
    NUMBER # integer, float, etc
    # Operators
    PLUS       # 'plus' reserved word
    UNARY_PLUS # '+' unary operator
    MINUS      # Unary operator
    AWAY_FROM
    TIMES
    INTO      # Float div
    EASY_INTO # Int div
    # Parentheses
    OPEN_PAREN
    CLOSE_PAREN
    # Braces
    OPEN_BRACE
    CLOSE_BRACE
    # Statements
    LIKE       # End of statement
    REMEMBER   # Variable assignment
    ASSIGN     # Variable assignment
    VAR_PREFIX # (€) - Denotes variable ids
    ID         # Denotes identifier for variable / function / class
    BAI        # Function def keyword
    # Other Stuff
    SOF # StartOfFile, just used to remove nils. SOF will never be used anywhere other than the default initialization of the Parser
    EOF
  end

  alias TokenValue = String | Char | Int32 | Float64

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
