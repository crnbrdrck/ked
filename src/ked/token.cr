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
    ASSIGN   # = for assignment
    ADDITION # 'plus' operator for addition

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

  # Mapping of keywords to their respective token type
  # Dev note; Order should match order in the TokenType Enum
  KEYWORDS = {
    "plus"        => TokenType::ADDITION,
    "like"        => TokenType::LIKE,
    "bai"         => TokenType::FUNCTION,
    "remember"    => TokenType::REMEMBER,
    "hereYaGoBai" => TokenType::RETURN,
  }

  # Class for managing Tokens
  class Token
    # These are for a production environment for handling errors
    # We'll add handling for these at a later date
    @file_name : String = "" # Keeps track of the file from which the token was generated
    @line_num : Int32 = -1   # Keeps track of which line of the file the token was generated
    @char_num : Int32 = -1   # Keeps track of the position of where the token was generated

    def initialize(@token_type : TokenType, @literal : String)
    end

    # Getters
    getter token_type
    getter literal
  end
end
