module Ked
  enum TokenType
    # Extra, special tokens
    ILLEGAL # Unknown token
    EOF     # End of file

    # Identifiers / Literals
    IDENT      # add, foobar, x, y, etc
    VAR_PREFIX # € symbol denotes variables
    NUMBER     # integers and floats are both number tokens but will use Int and Float internally (inlike JS >.>)

    # Operators
    ASSIGN # = for assignment
    PLUS   # 'plus'

    # Delimiters
    COMMA  # ','
    LIKE   # 'like', ked's version of ;
    LPAREN # '('
    RPAREN # ')'
    LBRACE # '{'
    RBRACE # '}'

    # Keywords
    FUNCTION # 'bai' for function definition
    REMEMBER # 'remember' for variable assignment
    RETURN   # 'hereYaGoBai' for returning from a function
  end

  # Class for managing Tokens
  class Token
    def initialize(@type : TokenType, @literal : String)
    end
  end
end
