module Ked
  # Might have to extend this later but we'll see
  alias TokenType = String

  # Class for managing Tokens
  class Token
    def initialize(@type : TokenType, @literal : String)
    end
  end
end
