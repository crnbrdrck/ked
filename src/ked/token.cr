module Ked
  # Enum for representing the different types of Tokens that can be generated from Ked source code.
  #
  # An Enum is used so that we are able to use syntax like `TokenType::IDENT` when creating `Token` objects
  enum TokenType
    # Extra, special tokens

    # Unknown token, this usually means an error
    ILLEGAL
    # End Of File
    EOF

    # Identifiers / Literals

    # Name of variables/ functions, i.e: add, foobar, x, y, etc
    IDENT
    # € symbol denotes variables
    VAR_PREFIX
    # Integers and Floats are both Number tokens but will use Int and Float internally
    NUMBER

    # Operators (note that awayFrom and times work in the opposite direction)
    # 2 awayFrom 4 == 4 - 2

    # = for assignment
    ASSIGN
    # 'plus' operator for addition
    ADDITION
    # 'awayFrom' operator for subtraction
    SUBTRACTION
    # 'times' operator for multiplication
    MULTIPLICATION
    # 'into' operator for division
    DIVISION
    # 'is' (==)
    EQUALITY
    # 'not' for negation
    NEGATION
    # 'isNot' (!=)
    INEQUALITY
    # 'isSmallerThan' (>)
    LT
    # 'isBiggerThan' (<)
    GT

    # Delimiters

    # ','
    COMMA
    # 'like', ked's version of ;
    LIKE
    # '('
    LPAREN
    # ')'
    RPAREN
    # '{'
    LBRACE
    # '}'
    RBRACE

    # Keywords

    # 'bai' for function definition
    FUNCTION
    # 'remember' for variable assignment
    REMEMBER
    # 'hereYaGoBai' for returning from a function
    RETURN
    # 'gospel'
    TRUE
    # 'bull'
    FALSE
    # 'eh'
    IF
    # 'orEvenJust'
    ELSE
  end

  # Hash that maps the various Ked keywords to the TokenType that represents them.
  #
  # This is used in `Ked::Lexer#read_identifier` to determine whether the read string of characters represents a keyword or an identifier.
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

  # Class for managing Token instances generated by the Lexer.
  class Token
    # These are for a production environment for handling errors
    @file_name : String # Keeps track of the file from which the token was generated
    @line_num : Int32   # Keeps track of which line of the file the token was generated
    @char_num : Int32   # Keeps track of the position of where the token was generated

    def initialize(@token_type : TokenType, @literal : String, @file_name : String, @line_num : Int32, @char_num : Int32)
    end

    # Generate a string representation of the Token instance.
    def to_s
      "Token(#{@token_type}, #{literal}) (#{@file_name}:#{@line_num}:#{@char_num})"
    end

    # The type of this token.
    getter token_type
    # The value of the token.
    #
    # What this is depends on the type of the token:
    # - For keywords, this will be the string from `Ked::KEYWORDS` that maps to its type.
    # - For numbers, this will be the read number in string form.
    # - For identifiers, this will be the name of the variable / function.
    getter literal
    # Keeps track of the name of the file that this token was generated from.
    getter file_name
    # Keeps track of the line of the file from which the token was genereated from.
    getter line_num
    # Keeps track of the position in the line of the first character that caused the generation of this token.
    getter char_num
  end
end
