module Ked
  enum TokenType
    # Extra, special tokens
    ILLEGAL # Unknown token, this usually means an error
    EOF     # End Of File

    # Identifiers / Literals
    IDENT      # add, foobar, x, y, etc
    VAR_PREFIX # € symbol denotes variables
    NUMBER     # integers and floats are both number tokens but will use Int and Float internally (inlike JS >.>)

    # Operators (note that awayFrom and times work in the opposite direction)
    # 2 awayFrom 4 == 4 - 2
    ASSIGN         # = for assignment
    ADDITION       # 'plus' operator for addition
    SUBTRACTION    # 'awayFrom' operator for subtraction
    MULTIPLICATION # 'times' operator for multiplication
    DIVISION       # 'into' operator for division
    EQUALITY       # 'is' (==)
    NEGATION       # 'not' for negation
    INEQUALITY     # 'isNot' (!=)
    LT             # 'isSmallerThan' (>)
    GT             # 'isBiggerThan' (<)

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
    TRUE     # 'gospel'
    FALSE    # 'bull'
    IF       # 'eh'
    ELSE     # 'orEvenJust'
  end

  # Mapping of keywords to their respective token type
  # Dev note; Order should match order in the TokenType Enum
  KEYWORDS = {
    "plus"          => TokenType::ADDITION,
    "awayFrom"      => TokenType::SUBTRACTION,
    "times"         => TokenType::MULTIPLICATION,
    "into"          => TokenType::DIVISION,
    "is"            => TokenType::EQUALITY,
    "not"           => TokenType::NEGATION,
    "isNot"         => TokenType::INEQUALITY,
    "isSmallerThan" => TokenType::LT,
    "isBiggerThan"  => TokenType::GT,
    "like"          => TokenType::LIKE,
    "bai"           => TokenType::FUNCTION,
    "remember"      => TokenType::REMEMBER,
    "hereYaGoBai"   => TokenType::RETURN,
    "gospel"        => TokenType::TRUE,
    "bull"          => TokenType::FALSE,
    "eh"            => TokenType::IF,
    "orEvenJust"    => TokenType::ELSE,
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

    def intialize(@token_type : TokenType, @literal : String, @file_name : String, @line_num : Int32, @char_num : Int32)
    end

    def to_s
      "Token(#{@token_type}, #{literal})"
    end

    # Getters
    getter token_type
    getter literal
  end
end
